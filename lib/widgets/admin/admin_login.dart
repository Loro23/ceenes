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

Session _session;
String _movies;

class AdminLogin extends StatefulWidget {
  AdminLogin(Session session, String movies) {
    _session = session;
    _movies = movies;
  }

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: SelectableText(
                        "Deine Gruppe wurde erstellt!",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
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
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: SelectableText(
                        _session.sessionId.toString(),
                        style: TextStyle(
                            letterSpacing: 10,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: Text(
                      "Zurück",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.grey[700],
                    heroTag: "1",
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        //print(_movies);
                        return Swipe_View(_movies, _session.sessionId);
                      }));
                    },
                    label: Text(
                      "Start",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.pinkAccent,
                    heroTag: "2",
                  )
                ],
              ),
            ),
          ),
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
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top:8, left: 8, bottom: 8, right: 12),
                      child: Image.asset("assets/ceenes_logo_yellow4x.png", height: 40,)
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
