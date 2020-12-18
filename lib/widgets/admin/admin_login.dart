import 'dart:html';

import 'package:ceenes_prototype/util/movie.dart';
import 'package:ceenes_prototype/util/movie_handler.dart';
import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/swipe_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'create_view.dart';

Session session;

class AdminLogin extends StatefulWidget {
  AdminLogin(int numPats, int numMov, List<String> genres) {
    session = new Session(numPats, numMov, genres);
  }

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  List<int> movieIds = [];

  //api request
  //antwort: ids
  //in movieIds
  //firestore > Collection mit Id von der Sesson > movies > firestore.upload(moviesIds)

  void createRecord(List movies) async {
    await firestore
        .collection("sessions")
        .document(session.sessionId.toString())
        .setData({}).then((value) {
      firestore
          .collection("sessions")
          .document(session.sessionId.toString())
          .collection("movies")
          .document("movie_entries")
          .setData({});

      for (int i = 0; i < 20; i++) {
        firestore
            .collection("sessions")
            .document(session.sessionId.toString())
            .collection("movies")
            .document("movie_entries")
            .updateData({i.toString(): movies[1][i].toString()});
      }
      firestore
          .collection("sessions")
          .document(session.sessionId.toString())
          .collection("votes")
          .document("dummy_doc")
          .setData({});
    });
  }

  uploadMovies() async {
    // ignore: missing_return
    await MovieHandler.getMovies(session).then((_movies) {
      createRecord(_movies);
    });
  }

  @override
  initState() {
    uploadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          children: [
            Text("Deine Gruppe wurde erstellt!"),
            Text(
                "wenn ihr swipen wollt müsst ihr lediglich den Code auf der Find Group Seite angeben und ihr könnt swipen"),
            Text(session.sessionId.toString()),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return Swipe_View(movieIds);
                }));
              },
              child: Text("Start"),
            )
          ],
        ),
      ),
    );
  }
}
