import 'dart:convert';

import 'package:ceenes_prototype/util/colors.dart';
import 'package:ceenes_prototype/widgets/review2.dart';
import 'package:ceenes_prototype/widgets/start_view.dart';
import 'package:ceenes_prototype/widgets/swipe_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

class Login_view extends StatefulWidget {
  Login_view({this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _Login_viewState createState() => _Login_viewState(analytics, observer);
}

class _Login_viewState extends State<Login_view> {
  _Login_viewState(this.analytics, this.observer);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String movies_enc;

  Future<void> _sendAnalyticsEvent(String what) async {
    if (!consent) return;
    await analytics.logEvent(
      name: what,
    );
  }

  Future<String> fetchMovies(int sessionId) async {
    await firestore
        .collection("sessions")
        .document(sessionId.toString())
        .get()
        .then((value) {
      // print(value.data()["movies_json"]);
      movies_enc = value.data()["movies_json"];
    });
  }

  final TextEditingController _controller = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: primary_color, width: 2),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sendAnalyticsEvent("Login View - Init State");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundcolor_dark,
      child: WillPopScope(
        onWillPop: () async => true,
        child: Container(
          color: backgroundcolor_dark,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 70),
                    child: SingleChildScrollView(
                      child: Container(
                        //color: Colors.blue,
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/giphy_tired.gif",
                              height: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                "Gib hier den Code ein.",
                                style: TextStyle(fontSize: 25),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: PinPut(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 30),
                                pinAnimationType: PinAnimationType.slide,
                                keyboardType: TextInputType.number,
                                eachFieldWidth: 40,
                                eachFieldHeight: 40,
                                fieldsCount: 6,
                                toolbarOptions: ToolbarOptions(
                                    paste: true,
                                    copy: true,
                                    cut: true,
                                    selectAll: true),
                                onSubmit: (String pin) => print(pin),
                                focusNode: _pinPutFocusNode,
                                controller: _controller,
                                submittedFieldDecoration:
                                    _pinPutDecoration.copyWith(
                                        borderRadius: BorderRadius.circular(5),
                                        border:
                                            Border.all(color: primary_color)),
                                selectedFieldDecoration: _pinPutDecoration,
                                followingFieldDecoration:
                                    _pinPutDecoration.copyWith(
                                  //color: Colors.black12,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: FlatButton(
                                      height: 75,
                                      color: blue_ceenes,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Ergebnisse\nansehen",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      onPressed: () async {
                                        String sessionId = _controller.text;
                                        // print(sessionId);
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: new Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        new CircularProgressIndicator(
                                                      valueColor:
                                                          new AlwaysStoppedAnimation<
                                                                  Color>(
                                                              blue_ceenes),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: new Text(
                                                        "Prüfe eingabe..."),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                        await checkCorrect(sessionId)
                                            .then((exists) {
                                          if (!exists) {
                                            _sendAnalyticsEvent(
                                                "Login View - Fehler bei Code Eingabe");
                                            Navigator.pop(context);
                                            showDialog(
                                              child: Dialog(
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        Icons.error_outline,
                                                        color: Colors.red,
                                                        size: 40,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: new Text(
                                                            "Bitte überprüfe deine Eingabe und gib den richtigen Code ein.",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              context: context,
                                            );
                                          } else {
                                            fetchMovies(int.parse(sessionId))
                                                .whenComplete(() {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(builder:
                                                      (BuildContext context) {
                                                return Review2(
                                                    int.parse(sessionId),
                                                    jsonDecode(movies_enc));
                                              }));
                                            });
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: FlatButton(
                                      height: 75,
                                      onPressed: () async {
                                        String sessionId = _controller.text;
                                        // print(sessionId);
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: new Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        new CircularProgressIndicator(
                                                      valueColor:
                                                          new AlwaysStoppedAnimation<
                                                                  Color>(
                                                              blue_ceenes),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: new Text(
                                                        "Prüfe eingabe..."),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                        await checkCorrect(sessionId)
                                            .then((exists) {
                                          if (!exists) {
                                            _sendAnalyticsEvent(
                                                "Login View - Fehler bei Code Eingabe");
                                            Navigator.pop(context);
                                            showDialog(
                                              child: Dialog(
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        Icons.error_outline,
                                                        color: Colors.red,
                                                        size: 40,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: new Text(
                                                            "Bitte überprüfe deine Eingabe und gib den richtigen Code ein.",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              context: context,
                                            );
                                          } else {
                                            fetchMovies(int.parse(sessionId))
                                                .whenComplete(() {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(builder:
                                                      (BuildContext context) {
                                                return Swipe_View(movies_enc,
                                                    int.parse(sessionId));
                                              }));
                                            });
                                          }
                                        });
                                      },

                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Jetzt swipen",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      color: primary_color,
                                      //label: Text("Start"),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
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
                            _sendAnalyticsEvent("Login View - Back Button");
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
        ),
      ),
    );
  }

  Future<bool> checkCorrect(String sessionId) async {
    if (sessionId == null || sessionId == "") {
      return false;
    }
    final snapshot =
        await firestore.collection("sessions").document(sessionId).get();
    if (!snapshot.exists) {
      return false;
    }
    return true;
  }
}
