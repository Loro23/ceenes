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
import 'package:carousel_slider/carousel_slider.dart';

class StartView extends StatefulWidget {
  @override
  _StartViewState createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  List<String> carouselcontent = ["1. Erstelle eine Gruppe.","2. Gib deine Anbieter ein.", "3. Wähle deine Genres aus.", "4. Teile deine Gruppe mit Freunden.", "5. Swipe dich durch die Auswahl.", "6. gemeinsam den besten Film genießen."];
   List<String> carouselimages = ["assets/streaming_screen.png","assets/genres_screen.png","assets/moviecover.png","assets/swipe_screen.png"];
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/film_roll.jpg'),
                  fit: BoxFit.fitHeight))),
          Container(color: Color.fromRGBO(0, 0, 0, .8)),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Padding(
                  padding: const EdgeInsets.only(left:20.0, right: 20, top: 15, bottom: 10),
                  child: Text("Finde den besten Film! Zusammen mit deinen Freunden.", style: TextStyle(fontSize: 20),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:30.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                            width: 130,
                            height: 60,
                            child: Hero(
                              tag: "2",
                              child: RaisedButton(
                                child: Text(
                                  "Erstellen",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black54,
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
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                    child: SizedBox(
                  width: 130,
                  height: 60,
                  child: Hero(
                    tag: "14",
                    child: RaisedButton(
                          color: Colors.grey[700],
                          child: Text(
                            "Teilnehmen",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (BuildContext context) {
                              return Login_view();
                            }));
                          },
                    ),
                  ),
                    ),
                        ),
                      )
                    ],
                  ),
                ),
                
              ],
            ),
          ),
          //Stack für header
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
                mainAxisAlignment: MainAxisAlignment.end,
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
    );
  }
}
