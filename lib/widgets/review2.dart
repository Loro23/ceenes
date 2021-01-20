import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:ceenes_prototype/util/api.dart';
import 'package:ceenes_prototype/util/colors.dart';
import 'package:ceenes_prototype/widgets/start_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import 'details_view.dart';

List _movies_dec;
int _sessionId;

class Review2 extends StatefulWidget {
  final FirebaseAnalytics analytics;

  final FirebaseAnalyticsObserver observer;
  Review2(int sessionId, List movies_dec, {this.analytics, this.observer}) {
    _sessionId = sessionId;
    _movies_dec = movies_dec;
  }
  @override
  _Review2State createState() => _Review2State(analytics, observer);
}

class _Review2State extends State<Review2> {
  final FirebaseAnalyticsObserver observer;

  final FirebaseAnalytics analytics;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<int> rating = [];

  List<List> voteDocuments = []; //gesamtes rating

  LinkedHashMap<Map<String, dynamic>, int> sortedMap;

  bool isEnabled = true;

  int _numVotes = 0;

  List<Widget> providerimg = [];

  String genres = "";

  List<Widget> allMoviesList = [];

  _Review2State(this.analytics, this.observer);

  setNumberVotes() async {
    await firestore
        .collection("sessions")
        .document(_sessionId.toString())
        .collection("votes")
        .getDocuments()
        .then((snapshot) {
      setState(() {
        this._numVotes = snapshot.documents.length - 1;
      });
    });
  }

  showDetails(context, Map moviedetails, String overviewEn) async {
    showModalBottomSheet(
        backgroundColor: backgroundcolor_dark,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Wrap(
            children: [Details_view(moviedetails, overviewEn)],
          );
        });
  }

  Future<void> _sendAnalyticsEvent(String what) async {
    if (!consent) return;
    await analytics.logEvent(
      name: what,
    );
  }

  // ignore: missing_return
  String getCorrectPosterpath(int id) {
    for (int i = 0; i < _movies_dec.length; i++) {
      if (_movies_dec[i]["id"] == id) {
        return _movies_dec[i]["poster_path"];
      }
    }
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
  //get Refersh Button ends here

  Widget getRefreshButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Feedback Button
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
            ),
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
          //Nochmal swipen Button
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
            ),
            child: FloatingActionButton.extended(
                backgroundColor: blue_ceenes,
                onPressed: () {
                  _sendAnalyticsEvent("Review View - Nochmal Swipen Button");
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
          //Refresh Button
          Padding(
            padding: const EdgeInsets.all(8),
            child: FloatingActionButton(
              heroTag: "10",
              onPressed: () async {
                _sendAnalyticsEvent("Review View - Refresh Button");
                await setNumberVotes();
                getRating();
              },
              child: Icon(
                Icons.refresh,
                color: blue_ceenes,
              ),
              backgroundColor: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Text _getPercentage(int _index) {
    double percent;
    percent = sortedMap.entries.elementAt(_index).value.toDouble();
    percent = percent / _numVotes;
    percent = percent * 100;
    if (percent >= 75) {
      return Text(
        percent.toInt().toString() + "%",
        style: TextStyle(color: Colors.green),
      );
    } else if (percent >= 50) {
      return Text(
        percent.toInt().toString() + "%",
        style: TextStyle(color: Colors.yellow),
      );
    } else
      return Text(
        percent.toInt().toString() + "%",
        style: TextStyle(color: Colors.red),
      );
  }

  getRating() async {
    showDialog(
      barrierDismissible: false,
      // ignore: deprecated_member_use
      child: Dialog(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
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

//setze Werte auf 0, falls vorher schon was drin stand
    setState(() {
      rating = [];
      voteDocuments = [];
      sortedMap = null;
    });
//fülle das rating auf mit 0en damit man addieren kann
    for (int i = 0; i < _movies_dec.length; i++) {
      rating.add(0);
    }
//hole Dokumente aus Datenbank (votes)
    QuerySnapshot voteDocumentsWithDummy = await firestore
        .collection("sessions")
        .doc(_sessionId.toString())
        .collection("votes")
        .get();

    //prüfe für je
    for (int i = 0; i < voteDocumentsWithDummy.docs.length; i++) {
      if (voteDocumentsWithDummy.docs[i].id == "dummy_doc") {
        continue;
      }
      //Füge jede votes Liste zu voteDocuments hinzu
      List indivRating =
          jsonDecode(voteDocumentsWithDummy.docs[i].data().values.elementAt(0));
      voteDocuments.add(indivRating);
    }
    //jede votes Liste wird auf die gesamt votes liste (rating liste) addiert
    for (List votes in voteDocuments) {
      for (int j = 0; j < votes.length; j++) {
        rating[j] += votes[j]; //aufaddieren der votes
      }
    }

    //filme auf rating mappen
    //hier werden fie filme und das rating gespeichert, sie müssen noch nach dem value sorteiert werden
    // der key ist der Film, der Value ist das Rating (die Anzahl der Votes für diesen Film)
    Map<Map<String, dynamic>, int> mapping = {};

    for (int i = 0; i < _movies_dec.length; i++) {
      mapping.putIfAbsent(_movies_dec[i], () => rating[i]);
    }

    //um die map zu sortieren nutzen wir die was von stackoverflow
    //sortedMap enthält dann an erster Stelle den Film mit den meisten Votes
    var sortedKeys = mapping.keys.toList(growable: false)
      ..sort((k1, k2) => mapping[k2].compareTo(mapping[k1]));
    setState(() {
      sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
          key: (k) => k, value: (k) => mapping[k]);
    });
    //damit nicht zu schnell erneut vom Nutzer aktualisert wird, muss mindestens 1 Sekunden gewartet werden
    Timer(Duration(milliseconds: 1000), () {
      setState(() {
        Navigator.pop(context);
      });
    });
  }

  // lädt die votes dokumente aus der Datenbank runter und berechnet für jeden Film die Anzahl der Stimmen
  Future<Widget> getReviewView() async {
    allMoviesList.clear();
    for (int index = 0; index < sortedMap.length; index++) {
      allMoviesList.add(InkWell(
        splashColor: Colors.white.withOpacity(0.5),
        onTap: () async {
          // print("id: " +
          //     sortedMap.entries.elementAt(index).key["id"].toString());
          Map movieDetails = await tmdb.v3.movies.getDetails(
              sortedMap.entries.elementAt(index).key["id"],
              appendToResponse: "watch/providers",
              language: "de-DE");

          var rep = await http.get("https://api.themoviedb.org/3/movie/" +
              sortedMap.entries.elementAt(index).key["id"].toString() +
              "?api_key=" +
              apiKey +
              "&language=en-US");
          String overview = jsonDecode(rep.body)["overview"];

          showDetails(context, movieDetails, overview);
        },
        child: Card(
          color: Colors.grey[850],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  "http://image.tmdb.org/t/p/w92/" +
                      getCorrectPosterpath(
                          sortedMap.entries.elementAt(index).key["id"]),
                  height: 80,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    sortedMap.entries.elementAt(index).key["title"],
                    overflow: TextOverflow.clip,
                  ),
                ),
                _getPercentage(index),
              ],
            ),
          ),
        ),
      ));
    }
    print("nach for");

    //daten für das Ergebnis holen

    providerimg = []; //Provider Bilder

//sortedMap.keys.toList()[0] ist der Ergebniss Film
    //hole watch privders für Ergebnis Film
    final response = await http.get("https://api.themoviedb.org/3/movie/" +
        sortedMap.keys.toList()[0]["id"].toString() +
        "/watch/providers?api_key=" +
        apiKey);
    final details = await http.get("https://api.themoviedb.org/3/movie/" +
        sortedMap.keys.toList()[0]["id"].toString() +
        "?api_key=" +
        apiKey +
        "&language=en-US");
    print(jsonDecode(details.body).toString());
    String runtime = jsonDecode(details.body)["runtime"].toString();
    String overview = sortedMap.keys.toList()[0]["overview"];
    String en_overview = jsonDecode(details.body)["overview"];
    if (overview == "") {
      overview = en_overview;
    }
    //füge alle Provider Bilder providerimg hinzu als Widget
    for (Map x in jsonDecode(response.body)["results"]["DE"]["flatrate"]) {
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

      var allMoviesList;

      return Material(
          color: backgroundcolor_dark,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: BoxConstraints(maxWidth: 600),
              color: backgroundcolor_dark,
              child: RefreshIndicator(
                color: blue_ceenes,
                onRefresh: () async {
                  _sendAnalyticsEvent("Review View - Refresh Indicator");
                  await setNumberVotes();
                  getRating();
                },
                child: ExpandableTheme(
                  data: const ExpandableThemeData(
                    iconColor: Colors.blue,
                    useInkWell: true,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Builder(builder: (context) {
                            if (this._numVotes == 1) {
                              return Text(
                                "Bis jetzt hast nur du abgestimmt.",
                                style: TextStyle(fontSize: 19),
                                textAlign: TextAlign.center,
                              );
                            }
                            return Text(
                              "Es haben " +
                                  this._numVotes.toString() +
                                  " Personen abgestimmt.",
                              style: TextStyle(fontSize: 19),
                              textAlign: TextAlign.center,
                            );
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 400),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                  "http://image.tmdb.org/t/p/w500/" +
                                      sortedMap.keys.toList()[0]
                                          ["poster_path"]),
                            ),
                          ),
                        ),
                        Padding(
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
                              /*
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Text(runtime + "min"),
                              ),

                               */
                              _getPercentage(0),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8, top: 3, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text("In Flatrate enthalten bei"),
                              ),
                              Wrap(
                                children: providerimg,
                              ),
                            ],
                          ),
                        ),
                        ExpandableNotifier(
                          child: Column(
                            children: [
                              ScrollOnExpand(
                                child: ExpandablePanel(
                                  theme: const ExpandableThemeData(
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.center,
                                    tapBodyToCollapse: true,
                                    tapHeaderToExpand: true,
                                    hasIcon: true,
                                    tapBodyToExpand: true,
                                    useInkWell: true,
                                  ),
                                  iconColor: blue_ceenes,
                                  collapsed: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      overview,
                                      style: TextStyle(fontSize: 15),
                                      softWrap: true,
                                      textAlign: TextAlign.left,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  expanded: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      sortedMap.keys.toList()[0]["overview"],
                                      softWrap: true,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  header: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Überblick",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ExpandableNotifier(
                          initialExpanded: true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ScrollOnExpand(
                                child: ExpandablePanel(
                                  theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                      tapBodyToExpand: true,
                                      tapHeaderToExpand: true),
                                  expanded: Container(
                                    height: 400,
                                    child: SingleChildScrollView(
                                      physics: ClampingScrollPhysics(),
                                      child: Column(
                                        children: this.allMoviesList,
                                      ),
                                    ),
                                  ),
                                  iconColor: blue_ceenes,
                                  header: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Alle Filme",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 23),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ));
    }
  }

  @override
  initState() {
    _sendAnalyticsEvent("Review View - Init State");
    super.initState();
    setNumberVotes();
  }

  bool firstCall = true;

  @override
  Widget build(BuildContext context) {
    // print("hallo");
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
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                _sendAnalyticsEvent(
                                    "Review View - Home Button");
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
                            SizedBox(
                              width: 5,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Color.fromRGBO(68, 68, 68, 1)
                                    .withOpacity(0.5),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    _sessionId.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
}
