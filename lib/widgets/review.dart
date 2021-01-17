import 'dart:async';
import 'dart:convert';

import 'package:ceenes_prototype/util/api.dart';
import 'package:ceenes_prototype/util/colors.dart';
import 'package:ceenes_prototype/util/create_view_utils.dart';
import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/start_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import 'dart:collection';
import 'package:http/http.dart' as http;

import 'package:tmdb_api/tmdb_api.dart';
import 'package:toast/toast.dart';

import 'details_view.dart';
import 'package:intl/intl.dart';

int _sessionId;
List _movies_dec;

class Review extends StatefulWidget {
  Review(int sessionId, List movies_dec, {this.analytics, this.observer}) {
    _sessionId = sessionId;
    _movies_dec = movies_dec;
  }

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _ReviewState createState() => _ReviewState(analytics, observer);
}

class _ReviewState extends State<Review> {
  _ReviewState(this.analytics, this.observer);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<int> rating = []; //gesamtes rating

  List<List> snapshotWithoutDummy = [];

  LinkedHashMap<Map<String, dynamic>, int> sortedMap;

  bool isEnabled = true;

  Future<void> _sendAnalyticsEvent(String what) async {
    await analytics.logEvent(
      name: what,
    );
  }

  showDetails(context, Map moviedetails) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Wrap(children: [Details_view(moviedetails)]);
        });
  }

  getNumberVotes() async {
    await firestore
        .collection("sessions")
        .document(_sessionId.toString())
        .collection("votes")
        .getDocuments()
        .then((snapshot) {
      // print(snapshot.documents);
      setState(() {
        this._numVotes = snapshot.documents.length - 1;
      });
    });
  }

  int _numVotes = 0;
  int _sessionParts = 0;

  getRating() async {
    showDialog(
      barrierDismissible: false,
      // ignore: deprecated_member_use
      child: Dialog(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(blue_ceenes),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  "Lade Ergebnisse...",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ),
      context: context,
    );

    setState(() {
      rating = [];
      snapshotWithoutDummy = [];
      sortedMap = null;
    });

    for (int i = 0; i < _movies_dec.length; i++) {
      rating.add(0);
    }

    // print(1);
    await firestore
        .collection("sessions")
        .document(_sessionId.toString())
        .collection("votes")
        .getDocuments()
        .then((snapshot) {
      //print(2);
      for (int i = 0; i < snapshot.documents.length; i++) {
        if (snapshot.documents[i].id == "dummy_doc") {
          continue;
        }
        List rate =
            jsonDecode(snapshot.documents[i].data().values.elementAt(0));
        //print(rate);
        snapshotWithoutDummy.add(rate);
      }

      //print('rating berechnen');
      for (List rate in snapshotWithoutDummy) {
        for (int j = 0; j < rate.length; j++) {
          rating[j] += rate[j]; //aufaddieren der votes
        }
      }

      //filme auf rating mappen
      //hier werden fie filme und das rating gespeichert, sie müssen noch nach dem value sorteiert werden
      Map<Map<String, dynamic>, int> mapping = {};

      for (int i = 0; i < _movies_dec.length; i++) {
        mapping.putIfAbsent(_movies_dec[i], () => rating[i]);
        //print(i);
        //print(_movies_dec[i]);
      }
      //print(mapping.entries);

      //um die map zu sortieren nutzen wir die was von stackoverflow

      var sortedKeys = mapping.keys.toList(growable: false)
        ..sort((k1, k2) => mapping[k2].compareTo(mapping[k1]));
      setState(() {
        sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
            key: (k) => k, value: (k) => mapping[k]);
      });
    });

    Timer(Duration(milliseconds: 1000), () {
      setState(() {
        Navigator.pop(context);
      });
    });
  }

  List<Widget> providerimg = [];
  String genres = "";

  Future<Widget> getReviewView() async {
    providerimg = [];

    //getNumberParts();
    if (sortedMap == null || _numVotes < _sessionParts) {
      print("noch nicht fertig");
      return Container(
        color: backgroundcolor_dark,
        child: Center(
            child: RefreshIndicator(
          color: blue_ceenes,
          onRefresh: () async {
            _sendAnalyticsEvent("Review View - Refresh Indicator");
            await getNumberVotes();
            getRating();
          },
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("Warte, bis deine Freunde fertig geswiped haben!"),
                    Text(_numVotes.toString() +
                        " von " +
                        _sessionParts.toString() +
                        " sind fertig."),
                    Text(
                        "Zum aktualisieren nach unten ziehen oder den Button klicken."),
                  ],
                ),
              ),
            ],
          ),
        )),
      );
    }
    final response = await http.get("https://api.themoviedb.org/3/movie/" +
        sortedMap.keys.toList()[0]["id"].toString() +
        "/watch/providers?api_key=" +
        apiKey);

    for (Map x in jsonDecode(response.body)["results"]["DE"]["flatrate"]) {
      print(x.values);
      providerimg.add(Padding(
        padding: const EdgeInsets.only(
          right: 8,
        ),
        child: Container(
          child: Image.network(
            "http://image.tmdb.org/t/p/w500/" + x["logo_path"],
          ),
          height: 50,
        ),
      ));
    }
    print(1);

    List<String> genres =
        getGenreStrings(sortedMap.keys.toList()[0]["genre_ids"]);
    print(genres);
    String genresFinal = "";
    for (String genre in genres) {
      print(genre);
      genresFinal += genre + ", ";
    }
    print(genresFinal);
    genresFinal = genresFinal.substring(0, genresFinal.length - 2);

    // ignore: missing_return
    print(3);
    String getCorrectPosterpath(int id) {
      for (int i = 0; i < _movies_dec.length; i++) {
        if (_movies_dec[i]["id"] == id) {
          return _movies_dec[i]["poster_path"];
        }
      }
    }

    print("vor return");
    return Material(
        color: backgroundcolor_dark,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            color: backgroundcolor_dark,
            child: ExpandableTheme(
              data: const ExpandableThemeData(
                iconColor: Colors.blue,
                useInkWell: true,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 400),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                                "http://image.tmdb.org/t/p/w500/" +
                                    sortedMap.keys.toList()[0]["poster_path"]),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              sortedMap.keys.toList()[0]["title"],
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(238, 238, 238, 1)),
                            )),
                            _getPercentage(0),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, top: 3, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Text("In Flatrate enthalten bei"),
                            ),
                            Wrap(
                              children: providerimg,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ExpandableNotifier(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            ScrollOnExpand(
                              child: ExpandablePanel(
                                theme: const ExpandableThemeData(
                                  headerAlignment:
                                      ExpandablePanelHeaderAlignment.center,
                                  tapBodyToCollapse: true,
                                ),
                                collapsed: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    sortedMap.keys.toList()[0]["overview"],
                                    softWrap: true,
                                    textAlign: TextAlign.left,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                expanded: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    sortedMap.keys.toList()[0]["overview"],
                                    softWrap: true,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                tapHeaderToExpand: true,
                                hasIcon: true,
                                tapBodyToCollapse: true,
                                iconColor: blue_ceenes,
                                header: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Überblick",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              scrollOnExpand: true,
                              scrollOnCollapse: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ExpandableNotifier(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ScrollOnExpand(
                              child: ExpandablePanel(
                                theme: const ExpandableThemeData(
                                  headerAlignment:
                                      ExpandablePanelHeaderAlignment.center,
                                  tapBodyToCollapse: true,
                                  tapBodyToExpand: false,
                                  tapHeaderToExpand: true,
                                ),
                                expanded: Container(
                                  height: 500,
                                  child: ListView.builder(
                                    itemCount: sortedMap.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Card(
                                          child: InkWell(
                                            /*
                                            onTap: () {

                                              showDetails(
                                                  context,
                                                  sortedMap.entries
                                                      .elementAt(index)
                                                      .key);
                                            },

                                             */
                                            onTap: () async {
                                              print("id: " +
                                                  sortedMap.entries
                                                      .elementAt(index)
                                                      .key["id"]
                                                      .toString());
                                              Map movieDetails = await tmdb
                                                  .v3.movies
                                                  .getDetails(
                                                      sortedMap.entries
                                                          .elementAt(index)
                                                          .key["id"],
                                                      appendToResponse:
                                                          "watch/providers",
                                                      language: "de-DE");
                                              showDetails(
                                                  context, movieDetails);
                                            },
                                            child: Row(
                                              children: [
                                                Image.network(
                                                  "http://image.tmdb.org/t/p/w92/" +
                                                      getCorrectPosterpath(
                                                          sortedMap.entries
                                                              .elementAt(index)
                                                              .key["id"]),
                                                  height: 80,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Text(
                                                      sortedMap.entries
                                                          .elementAt(index)
                                                          .key["title"],
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: _getPercentage(
                                                        index) //voting
                                                    ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                tapHeaderToExpand: true,
                                hasIcon: true,
                                tapBodyToCollapse: true,
                                iconColor: blue_ceenes,
                                header: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Hier findet ihr alle Filme",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 23),
                                  ),
                                ),
                              ),
                              scrollOnExpand: true,
                              scrollOnCollapse: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  getNumberParts() async {
    await firestore
        .collection("sessions")
        .document(_sessionId.toString())
        .get()
        .then((snapshot) {
      setState(() {
        _sessionParts = snapshot.data()["numberPart"];
      });
    });
    print(_sessionParts);
  }

  Widget _getPercentage(int _index) {
    double percent;
    percent = sortedMap.entries.elementAt(_index).value.toDouble();
    percent = percent / _numVotes;
    percent = percent * 100;
    if (percent >= 75) {
      return Text(
        percent.toString() + "%",
        style: TextStyle(color: Colors.green),
      );
    } else if (percent >= 50) {
      return Text(
        percent.toString() + "%",
        style: TextStyle(color: Colors.yellow),
      );
    } else
      return Text(
        percent.toString() + "%",
        style: TextStyle(color: Colors.red),
      );
  }

  @override
  initState() {
    _sendAnalyticsEvent("Review View - Init State");
    super.initState();
    //getRating();
    getNumberVotes();
    getNumberParts();
  }

  bool firstCall = true;
  @override
  Widget build(BuildContext context) {
    if (firstCall) {
      Timer(Duration(milliseconds: 100), () {
        getRating();
      });
      firstCall = false;
    }

    return WillPopScope(
        onWillPop: () async => false,
        child: Material(
          child: Stack(
            children: [
              FutureBuilder(
                  future: getReviewView(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data;
                    } else {
                      return SizedBox();
                    }
                  }),
              getRefreshButton(),
              //Stack für header
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent
                      ])),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            _sendAnalyticsEvent("Review View - Home Button");
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        StartView()),
                                (Route<dynamic> route) => false);
                          },
                          icon: Icon(Icons.home),
                          splashRadius: 20,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 8, bottom: 8, right: 12),
                              child: Image.asset(
                                "assets/ceenes_logo_yellow4x.png",
                                height: 40,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  _sendFeedback() async {
    _sendAnalyticsEvent("Review View - Feedback gesendet");
    await firestore
        .collection("feedback")
        .add({DateTime.now().toString(): feedbackTextContr.text});
    Toast.show(
      "Danke für dein Feedback!",
      context,
      duration: 2,
      gravity: Toast.TOP,
      backgroundColor: primary_color,
      textColor: Colors.black87,
    );
  }

  TextEditingController feedbackTextContr = TextEditingController();

  getRefreshButton() {
    if (_sessionParts == _numVotes) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: FloatingActionButton.extended(
                    backgroundColor: red_ceenes,
                    onPressed: () {
                      _sendAnalyticsEvent("Review View - Feedback Button");
                      showDialog(
                          context: context,
                          child: Dialog(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Feedback",
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText:
                                          "Wie fandest du die Anzahl der Filme?\n"
                                          "Wie findest du die Farbe / das Desgin der App?\n"
                                          "Welche Features wünscht du dir?\n"
                                          "War es bis hierhin einfach einen gemeinsamen Film zu finden?\n"
                                          "Sind Probleme / Fehler aufgetreten? Wenn ja, welche?\n"
                                          "Hast du weiteres Feedback?",
                                    ),
                                    controller: feedbackTextContr,
                                    maxLines: 15,
                                    keyboardType: TextInputType.multiline,
                                    cursorColor: primary_color,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton.extended(
                                    label: Text(
                                      "Jetzt senden",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () async {
                                      _sendAnalyticsEvent(
                                          "Review View - Feedback senden Button");
                                      print(feedbackTextContr.value.text);
                                      await _sendFeedback();
                                      feedbackTextContr.clear();
                                      Navigator.pop(context);
                                    },
                                    backgroundColor: red_ceenes,
                                  ),
                                )
                              ],
                            ),
                          ));
                    },
                    label: Text(
                      'Feedback',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: FloatingActionButton.extended(
                    backgroundColor: blue_ceenes,
                    onPressed: () {
                      _sendAnalyticsEvent(
                          "Review View - Nochmal Swipen Button");
                      showDialog(
                          context: context,
                          child: Dialog(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Wünscht du dir dieses Feature?",
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              "Leider gibt es dieses Feature noch nicht, aber wir arbeiten daran.\n" +
                                                  "Aktuell musst du eine neue Gruppe auf machen, um erneut mit deinen Freunden zu swipen.",
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                    label: Text(
                      'nochmal swipen',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    )),
              ),
            ],
          ),
        ),
      );
    }
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: FloatingActionButton(
          heroTag: "10",
          onPressed: () async {
            _sendAnalyticsEvent("Review View - Refresh Button");
            await getNumberVotes();
            getRating();
          },
          child: Icon(
            Icons.refresh,
            color: blue_ceenes,
          ),
          backgroundColor: Colors.grey[800],
        ),
      ),
    );
  }
}

/*

*/

/*
  getRefreshButton() {
    if (_sessionParts == _numVotes) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:8.0,right:8.0),
                child: FloatingActionButton.extended(
                    backgroundColor: red_ceenes,
                    onPressed: () {
                      _sendAnalyticsEvent("Review View - Refresh Button");

                    showDialog(
                          context: context,
                          child: Dialog(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Feedback",
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText:
                                          "Wie fandest du die Anzahl der Filme?\n"
                                          "Wie findest du die Farbe?\n"
                                          "Welche Features wünscht du dir?\n"
                                          "War es bishier hin einfach einen gemeinsamen Film zu finden?\n"
                                          "Sind Probleme/Fehler aufgetreten? Wenn ja, welche?\n"
                                          "Hast du weiteres Feedback?",
                                    ),
                                    controller: feedbackTextContr,
                                    maxLines: 15,
                                    keyboardType: TextInputType.multiline,
                                    cursorColor: primary_color,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton.extended(
                                    label: Text(
                                      "Jetzt senden",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold,),
                                    ),
                                    onPressed: () async {
                                      print(feedbackTextContr.value.text);
                                      await _sendFeedback();
                                      feedbackTextContr.clear();
                                      Navigator.pop(context);
                                    },
                                    backgroundColor:red_ceenes,
                                  ),
                                )
                              ],
                            ),
                          ));
                    },
                    label: Text(
                      'Feedback',
                      style:
                          TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    )),
              ),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0,right: 8.0),
                    child: FloatingActionButton.extended(
                    backgroundColor: blue_ceenes,
                    onPressed: () {
                      showDialog(
                          context: context,
                          child: Dialog(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Wünscht du dir dieses Feature?",
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                              ),
                                             Text(
                                             "Leider gibt es dieses Feature noch nicht, aber wir arbeiten daran.\n"+
                                             "Aktuell musst du eine neue Gruppe auf machen, um erneut mit deinen Freunden zu swipen.",
                                             overflow: TextOverflow.clip,
                                             style: TextStyle(fontSize: 15),
                                          ),
                                          ],
                                        ),
                                      ),

                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                    label: Text(
                      'nochmal swipen',
                      style:
                          TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    )),
                  ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
                backgroundColor: red_ceenes,
                onPressed: () {
                  _sendAnalyticsEvent("Review View - Refresh Button");
                  showDialog(
                      context: context,
                      child: Dialog(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Feedback",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText:
                                      "Wie fandest du die Anzahl der Filme?\n"
                                      "Wie findest du die Farbe?\n"
                                      "Welche Features wünscht du dir?\n"
                                      "War es bishier hin einfach einen gemeinsamen Film zu finden?\n"
                                      "Sind Probleme/Fehler aufgetreten? Wenn ja, welche?\n"
                                      "Hast du weiteres Feedback?",
                                ),
                                controller: feedbackTextContr,
                                maxLines: 15,
                                keyboardType: TextInputType.multiline,
                                cursorColor: primary_color,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FloatingActionButton.extended(
                                label: Text(
                                  "Jetzt senden",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black87),
                                ),
                                onPressed: () async {
                                  _sendAnalyticsEvent(
                                      "Review View - Feedback Button");
                                  await _sendFeedback();
                                  feedbackTextContr.clear();
                                  Navigator.pop(context);
                                },
                                backgroundColor: primary_color,
                              ),
                            )
                          ],
                        ),
                      ));
                },
                label: Text(
                  'Feedback',
                  style:
                      TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                )),
        ),
      );
    }
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: FloatingActionButton(
          heroTag: "10",
          onPressed: () async {
            await getNumberVotes();
            getRating();
          },
          child: Icon(
            Icons.refresh,
            color: blue_ceenes,
          ),
          backgroundColor: Colors.grey[800],
        ),
      ),
    );
  }
}



   */
