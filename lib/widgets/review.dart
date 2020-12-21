import 'dart:async';
import 'dart:convert';

import 'package:ceenes_prototype/util/session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:collection';

import 'package:tmdb_api/tmdb_api.dart';

Session session;
List movies_dec;

class Review extends StatefulWidget {
  Review(Session _session, List _movies_dec) {
    session = _session;
    movies_dec = _movies_dec;
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
    setState(() {
      rating = [];
      snapshotWithoutDummy = [];
      sortedMap = null;
      isEnabled = false;
      _reviewButtonText = "warten...";
      _reviewButtonColor = Colors.red;
    });

    for (int i = 0; i < session.numMov; i++) {
      rating.add(0);
    }

    await firestore
        .collection("sessions")
        .document(session.sessionId.toString())
        .collection("votes")
        .getDocuments()
        .then((snapshot) {
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

      for (int i = 0; i < movies_dec.length; i++) {
        mapping.putIfAbsent(movies_dec[i], () => rating[i]);
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

    Timer(Duration(seconds: 3), () {
      setState(() {
        isEnabled = true;
        _reviewButtonColor = Colors.blue;
        _reviewButtonText = "Refresh";
      });
    });
  }

  Widget getReviewView() {
    if (sortedMap == null) {
      return Center(child: Text("bitte refereshen"));
    }
    return Column(
      children: [
        Text("Hier ist euer Ergebnis"),
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
                              movies_dec[index]["poster_path"],
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
        onPressed: isEnabled ? () => getRating() : null,
        label: Text(_reviewButtonText),
        backgroundColor: _reviewButtonColor,
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      //floatingActionButtonLocation: FloatingActionButtonLocation.ri,
      body: getReviewView(),
    );
  }
}
