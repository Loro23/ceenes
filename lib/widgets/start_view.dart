import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:ceenes_prototype/util/colors.dart';
import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/admin/admin_login.dart';
import 'package:ceenes_prototype/widgets/admin/create_view.dart';
import 'package:ceenes_prototype/widgets/license_view.dart';
import 'package:ceenes_prototype/widgets/login_view.dart';
import 'package:ceenes_prototype/widgets/privacy.dart';
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
import 'package:url_launcher/url_launcher.dart';

class StartView extends StatefulWidget {
  @override
  _StartViewState createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  _launchURL() async {
    const url =
        'https://de.linkedin.com/in/benjamin-kasten-a68466155?challengeId=AQGWWfDdKCKNjwAAAXYVZyJsoBJBTAUesYA_Y30jgQvYM8XZnLmkfnDvN58rnfxhg077ug-e2Nqb_PqTIvsQiITK9rtxoP1jFw&submissionId=ab2c09ea-1410-4c16-c6a2-30032c387a20';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURL2() async {
    const url = 'https://de.linkedin.com/in/lorenz-pott-156a6513b';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURLIG() async {
    const url = 'https://www.instagram.com/ceenes.official/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  double _getHeight() {
    return MediaQuery.of(context).size.height;
  }

  double _getWidth() {
    return MediaQuery.of(context).size.width;
  }

  getTitleFontSize() {
    double height = MediaQuery.of(context).size.height;
    return height * 0.03;
  }

  getSubtitleFontSize() {
    double height = MediaQuery.of(context).size.height;
    return height * 0.025;
  }

  getButtonFontSize() {
    double height = MediaQuery.of(context).size.height;
    if (_getWidth() < 300) {
      return height * 0.02;
    }
    return height * 0.03;
  }

  getButtonHeightSize() {
    double height = MediaQuery.of(context).size.height;
    return _getHeight() * 0.08;
  }

  getLogoSize() {
    return _getHeight() * 0.11;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundcolor_dark,
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Stack(
          children: [
            Center(
              child: Container(
                  height: MediaQuery.of(context).size.height * .6,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/movie_cover_2rows.png"),
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.75), BlendMode.darken),
                  ))),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, left: 8, bottom: 8, right: 12),
                                  child: Image.asset(
                                    "assets/ceenes_logo_yellow4x.png",
                                    height: getLogoSize(),
                                  )),
                              AutoSizeText(
                                "Finde den besten Film. Swipe zusammen mit deinen Freunden.",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: getTitleFontSize(),
                                    letterSpacing: 1),
                                textAlign: TextAlign.center,
                                maxLines: 5,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              AutoSizeText(
                                "Starte jetzt - keine Anmeldung, keine Registrierung, keine Kosten",
                                style: TextStyle(
                                    fontSize: getSubtitleFontSize(),
                                    letterSpacing: 1),
                                textAlign: TextAlign.center,
                                maxLines: 5,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ButtonTheme(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: RaisedButton(
                                          child: Text(
                                            "Erstellen",
                                            style: TextStyle(
                                                fontSize: getButtonFontSize(),
                                                color: backgroundcolor_dark,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          color:
                                              Colors.yellow.withOpacity(0.95),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return Create_View();
                                            }));
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: RaisedButton(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.yellow,
                                                  width: 2,
                                                  style: BorderStyle.solid),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Text(
                                            "Teilnehmen",
                                            style: TextStyle(
                                                fontSize: getButtonFontSize(),
                                                color: Colors.yellow),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return Login_view();
                                            }));
                                          },
                                        ),
                                      ),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                  ),
                                ),
                                height: getButtonHeightSize(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Column(
                        children: [
                          Container(
                            width: double.maxFinite,
                            child: Card(
                              color: Colors.grey[800],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Wie funktioniert's?",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "1. Erstell eine Gruppe",
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Lege fest, was für Filme ihr angezeigt bekommen wollt. Welche Streaming-Anbieter habt ihr, welche Genres wollt ihr?",
                                  style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 1,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[700],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(1),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                child: Container(
                                                    color: backgroundcolor_dark,
                                                    child: Image.asset(
                                                      "assets/create.gif",
                                                      width: 300,
                                                    )),
                                              ),
                                            )),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "2. Swipe mit Freunden",
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Entscheide für jeden Film: Gefällt er dir, swipe nach rechts, sonst nach links",
                                  style:
                                      TextStyle(fontSize: 18, letterSpacing: 1),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[700],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(1),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                child: Container(
                                                    color: backgroundcolor_dark,
                                                    padding: EdgeInsets.only(
                                                        bottom: 8,
                                                        left: 10,
                                                        right: 10),
                                                    child: Image.asset(
                                                      "assets/swipe.gif",
                                                      width: 300,
                                                    )),
                                              ),
                                            )),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "3. Ergebnis anzeigen",
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Am Ende wird euch der Film angezeigt, der euer gemeinsamer Favorit ist. Ihr könnt euch aber auch alle anderen Filme anschauen",
                                  style:
                                      TextStyle(fontSize: 18, letterSpacing: 1),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[700],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(1),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                child: Container(
                                                    color: backgroundcolor_dark,
                                                    padding: EdgeInsets.only(
                                                        bottom: 8,
                                                        left: 10,
                                                        right: 10),
                                                    child: Image.asset(
                                                      "assets/review.gif",
                                                      width: 300,
                                                    )),
                                              ),
                                            )),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 80,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              color: Colors.grey[800],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Was ist Ceenes überhaupt?",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Ceenes will euch dabei helfen, das ewige Suchen nach einem Film auf Netflix, Prime Video oder eurem Liebelings-"
                              "Streaming-Anbieter zu beenden. Wir schlagen euch Filme vor, ihr entscheidet. ",
                              style: TextStyle(fontSize: 18, letterSpacing: 1),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              color: Colors.grey[800],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Über uns",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Ceenes entsteht ihm Rahmen eines Seminars an der Universiät Paderborn. Wir, Lorenz und Benjamin, "
                              "stecken über ein Semester viel Energie in die Entwicklung dieser Webapp und wollen ein qualitativ hochwertiges "
                              "Produkt erstellen, um euch bei den \"Film-Entscheidungs-Prozess\" zu erleichtern. ",
                              style: TextStyle(fontSize: 18, letterSpacing: 1),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //profil Loro
                              InkWell(
                                onTap: _launchURL2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(200),
                                        child: Image.asset(
                                          "assets/profil_loro.jpg",
                                          height: 100,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Lorenz',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                              height: 20,
                                              child: Image.asset(
                                                "assets/linkdin.png",
                                                color: Colors.white,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              //Profil benji
                              InkWell(
                                  onTap: _launchURL,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(200),
                                          child: Image.asset(
                                            "assets/profil_benji.jpg",
                                            height: 100,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Benjamin',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                                height: 20,
                                                child: Image.asset(
                                                  "assets/linkdin.png",
                                                  color: Colors.white,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 120,
                          ),
                          InkWell(
                            onTap: _launchURLIG,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/ig.webp",
                                    height: 18,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "ceenes.offcial",
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FlatButton(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        "Lizenzen & Credits",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return LicenceCredits_View();
                                      }));
                                    },
                                  ),
                                  FlatButton(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        "Datenschutz",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return PrivacyPolicy();
                                      }));
                                    },
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
