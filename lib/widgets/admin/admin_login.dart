import 'dart:convert';
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
  String movies;

  void createRecord() async {
    await firestore
        .collection("sessions")
        .document(session.sessionId.toString())
        .setData({}).then((value) {
      firestore
          .collection("sessions")
          .document(session.sessionId.toString())
          .setData({});

      firestore
          .collection("sessions")
          .document(session.sessionId.toString())
          .updateData({"movies_json": this.movies});
      firestore
          .collection("sessions")
          .document(session.sessionId.toString())
          .collection("votes")
          .document("dummy_doc")
          .setData({});
    });
  }

  uploadMovies() async {
    await MovieHandler.getMovies(session).then((movies) {
      this.movies =
          json.encode(movies); //movie result als json string erstellen
      createRecord(); // eintrag erstellen mit movies als Liste bevor
    });
  }

  @override
  initState() {
    uploadMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Text(
                    "Deine Gruppe wurde erstellt!",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: SelectableText(
                    "Um zu starten, müssen deine Freunde den unterstehenden Code eingeben. Wenn alle den Code haben, kannst auch du anfangen, indem "
                    "du auf Start klickst. Sobald du und deine Freunde fertig sind, könnt ihr euch alle die Ergebnisse anschauen. Los gehts!",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Text(
                    session.sessionId.toString(),
                    style: TextStyle(
                        letterSpacing: 10,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return Swipe_View(this.movies, session.sessionId);
                      }));
                    },
                    child: Text("Start"),
                    backgroundColor: Colors.pinkAccent,
                    //label: Text("Start"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
