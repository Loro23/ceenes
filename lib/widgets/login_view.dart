import 'dart:convert';

import 'package:ceenes_prototype/util/colors.dart';
import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/swipe_view.dart';
import 'package:ceenes_prototype/widgets/swipe_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:smart_select/smart_select.dart';
import 'package:pinput/pin_put/pin_put.dart';

class Login_view extends StatefulWidget {
  @override
  _Login_viewState createState() => _Login_viewState();
}

class _Login_viewState extends State<Login_view> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String movies_enc;

  Future<String> fetchMovies(int sessionId) async {
    await firestore
        .collection("sessions")
        .document(sessionId.toString())
        .get()
        .then((value) {
      print(value.data()["movies_json"]);
      movies_enc = value.data()["movies_json"];
    });
  }

  final TextEditingController _controller = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.yellow, width: 2),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async => true,
        child: Container(
          color: backgroundcolor_dark,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 70),
                child: SingleChildScrollView(
                  child: Container(
                    //color: Colors.blue,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Text(
                            "Gib hier den Code ein.",
                            style: TextStyle(fontSize: 35),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: PinPut(
                            autofocus: true,
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 30),
                            pinAnimationType: PinAnimationType.slide,
                            keyboardType: TextInputType.number,
                            eachFieldWidth: 50,
                            eachFieldHeight: 50,
                            fieldsCount: 6,
                            toolbarOptions: ToolbarOptions(
                                paste: true,
                                copy: true,
                                cut: true,
                                selectAll: true),
                            onSubmit: (String pin) => print(pin),
                            focusNode: _pinPutFocusNode,
                            controller: _controller,
                            submittedFieldDecoration: _pinPutDecoration.copyWith(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: Colors.yellow.withOpacity(0.95))),
                            selectedFieldDecoration: _pinPutDecoration,
                            followingFieldDecoration: _pinPutDecoration.copyWith(
                              //color: Colors.black12,
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: FloatingActionButton(
                              heroTag: "14",
                              onPressed: () async {
                                String sessionId = _controller.text;
                                print(sessionId);
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child:
                                                new CircularProgressIndicator(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Text("Prüfe eingabe"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                                await checkCorrect(sessionId).then((exists) {
                                  if (!exists) {
                                    Navigator.pop(context);
                                    showDialog(
                                      child: Dialog(
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.error_outline,
                                                color: Colors.red,
                                                size: 40,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: new Text(
                                                    "Bitte überprüfe deine Eingabe und gib den richtigen Code ein.",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                    overflow: TextOverflow.clip),
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
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return Swipe_View(
                                            movies_enc, int.parse(sessionId));
                                      }));
                                    });
                                  }
                                });
                              },
                              child: Text(
                                "Start",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600),
                              ),
                              backgroundColor: Colors.yellow.withOpacity(0.95),
                              //label: Text("Start"),
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
