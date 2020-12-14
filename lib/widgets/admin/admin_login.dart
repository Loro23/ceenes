import 'dart:html';

import 'package:ceenes_prototype/util/movie.dart';
import 'package:ceenes_prototype/util/movie_handler.dart';
import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/swipe_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'create_view.dart';

Session b;

class AdminLogin extends StatefulWidget {
  AdminLogin(int numPats, int numMov, List<String> genres) {
    b = new Session(numPats, numMov, genres);
  }

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Movie> movies;

  List<int> movieIds = [];

  //api request
  //antwort: ids
  //in movieIds
  //firestore > Collection mit Id von der Sesson > movies > firestore.upload(moviesIds)

  void createRecord() async {
    await firestore
        .collection("sessions")
        .document(b.sessionId.toString())
        .setData({}).then((value) {
      firestore
          .collection("sessions")
          .document(b.sessionId.toString())
          .collection("movies")
          .document("movieIds")
          .setData({});

      for (int i = 0; i < 20; i++) {
        firestore
            .collection("sessions")
            .document(b.sessionId.toString())
            .collection("movies")
            .document("movieIds")
            .updateData({i.toString(): movieIds[i]});
      }
      firestore
          .collection("sessions")
          .document(b.sessionId.toString())
          .collection("votes")
          .document("dummy_doc")
          .setData({});
    });
  }

  fetchMovieIds() async {
    // ignore: missing_return
    movies = await MovieHandler.getMovies(b).then((value) {
      for (Movie m in value) {
        movieIds.add(m.id);
        print(m.id);
      }
      createRecord();
    });
  }

  @override
  initState() {
    fetchMovieIds();
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
            Text(b.sessionId.toString()),
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
