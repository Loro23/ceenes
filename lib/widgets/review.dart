import 'dart:convert';

import 'package:ceenes_prototype/util/session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  Future getRating() async {
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
        for (int i = 0; i < session.numMov; i++) {
          rating[i] += rate[i];
        }
      }
      print(rating);
    });

    print(rating);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          getRating();
        },
        label: Text("Ergebnisse"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
