import 'dart:convert';
import 'dart:html';

import 'package:ceenes_prototype/util/colors.dart';
import 'package:ceenes_prototype/util/movie.dart';
import 'package:ceenes_prototype/util/movie_handler.dart';
import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/swipe_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'create_view.dart';
import 'package:clipboard/clipboard.dart';
import 'package:share/share.dart';

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
      color: backgroundcolor_dark,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/giphy_happy.gif",
                          height: 150,
                        ),
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
                            "Um zu starten, teile den Code mit deinen Freunden und klicke dann auf Start!",
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
                        FlatButton(
                          onPressed: () {
                            FlutterClipboard.copy(
                                _session.sessionId.toString());
                          },
                          color: Colors.grey[800],
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Kopieren",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.copy),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return Swipe_View(_movies, _session.sessionId);
                  }));
                },
                label: Text(
                  "Start",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                ),
                backgroundColor: primary_color,
                heroTag: "2",
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      splashRadius: 20,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 8, bottom: 8, right: 12),
                      child: Image.asset(
                        "assets/ceenes_logo_yellow4x.png",
                        height: 40,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
