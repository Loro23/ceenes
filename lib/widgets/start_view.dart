import 'dart:convert';

import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/admin/admin_login.dart';
import 'package:ceenes_prototype/widgets/admin/create_view.dart';
import 'package:ceenes_prototype/widgets/login_view.dart';
import 'package:ceenes_prototype/widgets/swipe_view.dart';
import 'package:ceenes_prototype/widgets/swipe_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../util/api.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:smart_select/smart_select.dart';

class StartView extends StatefulWidget {
  @override
  _StartViewState createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Text(
                    "Wähle aus, ob du eine Gruppe erstellen oder an einer teilnehmen willst.",
                    style: TextStyle(fontSize: 35),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: SizedBox(
                    width: 250,
                    height: 80,
                    child: Hero(
                      tag: "2",
                      child: RaisedButton(
                        child: Text(
                          "Erstellen",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) {
                            return Create_View();
                          }));
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 250,
                  height: 80,
                  child: Hero(
                    tag: "14",
                    child: RaisedButton(
                      color: Colors.pinkAccent,
                      child: Text(
                        "Teilnehmen",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return Login_view();
                            }));
                      },
                    ),
                  ),
                )
              ],
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
