import 'dart:async';
import 'dart:convert';

import 'package:ceenes_prototype/util/session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:collection';

import 'package:tmdb_api/tmdb_api.dart';

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

  String _reviewButtonText = "Refresh";

  Color _reviewButtonColor = Colors.blue;

  Future getRating() async {
    showDialog(
      barrierDismissible: false,
      child: Dialog(
        child: SizedBox(
          height: 100,
          width: 150,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new CircularProgressIndicator(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text("Lade Ergebnisse..."),
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

    print(0);
    print(_movies_dec.length);
    for (int i = 0; i < _movies_dec.length; i++) {
      rating.add(0);
    }

    print(1);
    await firestore
        .collection("sessions")
        .document(_sessionId.toString())
        .collection("votes")
        .getDocuments()
        .then((snapshot) {
      print(2);
      for (int i = 0; i < snapshot.documents.length; i++) {
        if (snapshot.documents[i].id == "dummy_doc") {
          continue;
        }
        List rate =
            jsonDecode(snapshot.documents[i].data().values.elementAt(0));
        snapshotWithoutDummy.add(rate);
      }

      print('rating berechnen');
      for (List i in snapshotWithoutDummy) {
        for (int j = 0; j < i.length; j++) {
          rating[j] += i[j]; //aufaddieren der votes
        }
      }

      //filme auf rating mappen
      //hier werden fie filme und das rating gespeichert, sie müssen noch nach dem value sorteiert werden
      Map<Map<String, dynamic>, int> mapping = {};

      for (int i = 0; i < _movies_dec.length; i++) {
        mapping.putIfAbsent(_movies_dec[i], () => rating[i]);
      }

      //um die map zu sortieren nutzen wir die was von stackoverflow

      var sortedKeys = mapping.keys.toList(growable: false)
        ..sort((k1, k2) => mapping[k2].compareTo(mapping[k1]));
      setState(() {
        sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
            key: (k) => k, value: (k) => mapping[k]);
      });

      for (MapEntry<Map<String, dynamic>, int> entry in sortedMap.entries) {
        print(entry.key["title"] + ": " + entry.value.toString());
      }
    });

    Timer(Duration(milliseconds: 1000), () {
      setState(() {
        Navigator.pop(context);
      });
    });
  }

  Widget getReviewView() {
    if (sortedMap == null) {
      return Center(
          child: Text("Warte, bis deine Freunde fertig geswiped haben!"));
    }
    return Column(
      children: [
        Container(
          child: Text("Hier ist euer Ergebnis"),
          color: Colors.transparent,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: sortedMap.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Card(
                  child: InkWell(
                    onTap: () {
                      print("tapped");
                    },
                    child: Row(
                      children: [
                        Image.network(
                          "http://image.tmdb.org/t/p/w92/" +
                              _movies_dec[index]["poster_path"],
                          height: 120,
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            sortedMap.entries.elementAt(index).key["title"],
                            overflow: TextOverflow.clip,
                          ),
                        )),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: getRating,
        label: Text(_reviewButtonText),
        backgroundColor: _reviewButtonColor,
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      //floatingActionButtonLocation: FloatingActionButtonLocation.ri,
      body: getReviewView(),
    );
  }
}
