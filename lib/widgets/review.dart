import 'dart:async';
import 'dart:convert';

import 'package:ceenes_prototype/util/colors.dart';
import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/review_overview.dart';
import 'package:ceenes_prototype/widgets/start_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import 'dart:collection';

import 'package:tmdb_api/tmdb_api.dart';

import 'details_view.dart';

int _sessionId;
List _movies_dec;

class Review extends StatefulWidget {
  Review(int sessionId, List movies_dec) {
    _sessionId = sessionId;
    _movies_dec = movies_dec;
  }

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<int> rating = []; //gesamtes rating

  List<List> snapshotWithoutDummy = [];

  LinkedHashMap<Map<String, dynamic>, int> sortedMap;

  bool isEnabled = true;

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
      print(snapshot.documents);
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
      child: Dialog(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new CircularProgressIndicator(),
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

  Widget getReviewView() {
    providerimg = [];
    genres = "";

    //getNumberParts();
    if (sortedMap == null || _numVotes != _sessionParts) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Warte, bis deine Freunde fertig geswiped haben!"),
          Text(_numVotes.toString() +
              " von " +
              _sessionParts.toString() +
              " sind fertig."),
        ],
      ));
    }

    for (Map x in sortedMap.keys.toList()[0]["watch/providers"]["results"]["DE"]
        ["flatrate"]) {
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
    // print(sortedMap.keys.toList()[0]);
    for (Map x in sortedMap.keys.toList()[0]["genres"]) {
      genres = genres + x["name"] + ", ";
    }
    genres = genres.substring(0, genres.length - 2);
    // ignore: missing_return
    String getCorrectPosterpath(int id) {
      for (int i = 0; i < _movies_dec.length; i++) {
        if (_movies_dec[i]["id"] == id) {
          return _movies_dec[i]["poster_path"];
        }
      }
    }


    return Material(
        child: Container(
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
                      child: Image.network("http://image.tmdb.org/t/p/w500/" +
                          sortedMap.keys.toList()[0]["poster_path"]),
                    ),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    sortedMap.keys.toList()[0]["title"],
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 3, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text("In Flatrate enthalten bei"),
                      ),
                      Row(
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
                          header: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Überblick",
                              style: TextStyle(fontWeight: FontWeight.w600),
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
                            tapBodyToExpand: false, tapHeaderToExpand: true
                          ),

                          expanded: Container(
                            height: 500,
                            child: ListView.builder(
                              itemCount: sortedMap.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Card(
                                    child: InkWell(
                                      onTap: () {
                                        showDetails(context,sortedMap.entries.elementAt(index).key);
                                      },
                                      child: Row(
                                        children: [
                                          Image.network(
                                            "http://image.tmdb.org/t/p/w92/" +
                                                getCorrectPosterpath(sortedMap.entries
                                                    .elementAt(index)
                                                    .key["id"]),
                                            height: 80,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 8),
                                              child: Text(
                                                sortedMap.entries.elementAt(index).key["title"],
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              sortedMap.entries
                                                  .elementAt(index)
                                                  .value
                                                  .toString(), //voting
                                            ),
                                          )
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
                          header: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Hier findet ihr alle Filme",
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 23),
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

  @override
  initState() {
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
              getReviewView(),
              /*
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: FloatingActionButton.extended(
                        heroTag: "10",
                        onPressed: () async {
                          await getNumberVotes();
                          getRating();
                        },
                        label: Text(
                          "Neu laden",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.pinkAccent,
                      ),
                    ),
                  ],
                ),
              ),

               */

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
}

/*

*/
