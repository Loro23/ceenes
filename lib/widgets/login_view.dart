import 'dart:convert';

import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/swipe_view.dart';
import 'package:ceenes_prototype/widgets/swipe_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:smart_select/smart_select.dart';

class Login_view extends StatefulWidget {
  @override
  _Login_viewState createState() => _Login_viewState();
}

class _Login_viewState extends State<Login_view> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController _controller = new TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Text(
                    "Um teilzunehmen, gib bitte den Code ein:",
                    style: TextStyle(fontSize: 35),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        //labelText: 'Gib hier den Code ein',
                        hintText: 'Gib hier den Code ein',
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        labelStyle: TextStyle(color: Colors.black)
                        //hintText: 'Code...'
                        ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: FloatingActionButton(
                    onPressed: () async {
                      String code = _controller.text;
                      print(code);
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
                                  child: new CircularProgressIndicator(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Text("Filme laden..."),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                      //TODO prüfen ob der code richtig ist
                      await fetchMovies(int.parse(code)).whenComplete(() {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return Swipe_View(movies_enc, session);
                        }));
                      });
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
