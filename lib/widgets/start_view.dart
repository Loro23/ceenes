import 'dart:convert';

import 'package:ceenes_prototype/util/colors.dart';
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
import 'package:carousel_slider/carousel_slider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class StartView extends StatefulWidget {
  @override
  _StartViewState createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  List<String> carouselcontent = [
    "1. Erstelle eine Gruppe.",
    "2. Gib deine Anbieter ein.",
    "3. Wähle deine Genres aus.",
    "4. Teile deine Gruppe mit Freunden.",
    "5. Swipe dich durch die Auswahl.",
    "6. gemeinsam den besten Film genießen."
  ];
  List<String> carouselimages = [
    "assets/streaming_screen.png",
    "assets/genres_screen.png",
    "assets/moviecover.png",
    "assets/swipe_screen.png"
  ];
  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundcolor_dark,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
                height: MediaQuery.of(context).size.height * .4,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/popcorn_ceenes.jpg"),
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.75), BlendMode.darken),
                ))),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.only(top:50, left:25, right: 25),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            "Finde den besten Film. Swipe zusammen mit deinen Freunden.",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),

                          SizedBox(height: 10,),
                          AutoSizeText(
                            "Starte jetzt - keine Anmeldung, keine Registrierung, keine Kosten",
                            style: TextStyle( fontSize: 18),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right:30),
                  child: Column(
                    children: [
                      ButtonTheme(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.only(top:20, bottom: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: RaisedButton(
                                  child: Text(
                                    "Erstellen",
                                    style: TextStyle(
                                        fontSize: 21,
                                        color: backgroundcolor_dark,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  color: Colors.yellow.withOpacity(0.95),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return Create_View();
                                    }));
                                  },
                                ),
                              ),
                              SizedBox(width: 15,),
                              Expanded(
                                child: RaisedButton(
                                  color: blue_ceenes,
                                  child: Text(
                                    "Teilnehmen",
                                    style: TextStyle(
                                        fontSize: 21,
                                        color: backgroundcolor_dark),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return Login_view();
                                    }));
                                  },
                                ),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                        ),
                        height: 60,
                      ),

                      Container(
                        width: double.maxFinite,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Wie funktioniert's?",
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700 ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "1. Erstelle eine Gruppe",
                                style: TextStyle(fontSize: 23,fontWeight: FontWeight.w600 ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Lege fest, was für Filme ihr angezeigt bekommen wollt. Welche Streaming-Anbieter habt ihr, welche Genres wollt ihr?",
                                style: TextStyle(fontSize: 16,),
                                textAlign: TextAlign.center,

                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "2. Swipe mit Freunden",
                                style: TextStyle(fontSize: 23,fontWeight: FontWeight.w600 ),
                                textAlign: TextAlign.center,

                              ),
                              Text(
                                "Entscheide dich jeden Film: Gefällt er dir, swipe nach rechts, sonst nach links",
                                style: TextStyle(fontSize: 16,),
                                textAlign: TextAlign.center,

                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "3. Ergebnis anzeigen",
                                style: TextStyle(fontSize: 23,fontWeight: FontWeight.w600 ),
                              ),
                              Text(
                                "Am Ende wird euch der Film angezeigt, der euer gemeinsamer Favorit ist. Ihr könnt euch aber auch alle anderen Filme anschauen",
                                style: TextStyle(fontSize: 16,),
                                textAlign: TextAlign.center,

                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),

            Align(
              alignment: Alignment.topCenter,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
    );
  }
}
