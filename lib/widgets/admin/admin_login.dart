import 'dart:convert';
import 'dart:html';

import 'package:ceenes_prototype/util/colors.dart';
import 'package:ceenes_prototype/util/movie.dart';
import 'package:ceenes_prototype/util/movie_handler.dart';
import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/swipe_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'create_view.dart';
import 'package:clipboard/clipboard.dart';
import 'package:share/share.dart';

Session _session;
String _movies;

class AdminLogin extends StatefulWidget {
  AdminLogin(Session session, String movies, {this.analytics, this.observer}) {
    _session = session;
    _movies = movies;
  }
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _AdminLoginState createState() => _AdminLoginState(analytics, observer);
}

class _AdminLoginState extends State<AdminLogin> {
  _AdminLoginState(this.analytics, this.observer);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _sendAnalyticsEvent(String what) async {
    await analytics.logEvent(
      name: what,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sendAnalyticsEvent("Admin Login - Init State");
  }

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
                padding: const EdgeInsets.only(top: 50),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/giphy_happy.gif",
                              height: 140,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:25, right:25, bottom: 22),
                              child: SelectableText(
                                "Deine Gruppe wurde erstellt!",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:25, right:25, bottom: 22),
                              child: SelectableText(
                                "Um zu starten, teile den Code mit deinen Freunden und klicke dann auf Start!",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 22),
                              child: SelectableText(
                                _session.sessionId.toString(),
                                style: TextStyle(
                                    letterSpacing: 10,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            FloatingActionButton.extended(
                              onPressed: () {
                                _sendAnalyticsEvent(
                                    "Admin Login - Kopieren Button");
                                FlutterClipboard.copy(
                                    _session.sessionId.toString());
                              },
                              backgroundColor: Colors.grey[800],
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Text(
                                      "Kopieren",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Icon(Icons.copy, color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, bottom:18),
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            _sendAnalyticsEvent("Admin Login - Start Button");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return Swipe_View(_movies, _session.sessionId,
                                  analytics: this.analytics,
                                  observer: this.observer);
                            }));
                          },
                          label: Text(
                            "Start",
                          ),
                          backgroundColor: primary_color,
                          heroTag: "2",
                        ),
                      ),
                    ),
                  ],
                ),
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
                        _sendAnalyticsEvent("Admin Login - Back Button");
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
