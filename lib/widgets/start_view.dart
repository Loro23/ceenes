import 'dart:async';
import 'dart:js' as js;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:ceenes_prototype/util/colors.dart';
import 'package:ceenes_prototype/widgets/admin/create_view.dart';
import 'package:ceenes_prototype/widgets/license_view.dart';
import 'package:ceenes_prototype/widgets/login_view.dart';
import 'package:ceenes_prototype/widgets/privacy.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

bool consent = false;

class StartView extends StatefulWidget {
  StartView({this.analytics, this.observer});

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _StartViewState createState() => _StartViewState(analytics, observer);
}

class _StartViewState extends State<StartView> {
  var showConsent = true;

  bool disableAnalytics = true;

  _StartViewState(this.analytics, this.observer);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  consentSetTrueSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('consentSet', true);
  }

  getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    int boolValue = await prefs.getBool('consent') ?? 0;
    return boolValue;
  }

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
    return height * 0.025;
  }

  getButtonHeightSize() {
    double height = MediaQuery.of(context).size.height;
    return _getHeight() * 0.08;
  }

  getLogoSize() {
    return _getHeight() * 0.11;
  }

  Future<void> _sendAnalyticsEvent(String what) async {
    if (!consent) return;
    await analytics.logEvent(
      name: what,
    );
  }

  @override
  void initState() {
    super.initState();
    _sendAnalyticsEvent("Start View - Init State");
    if (js.context.callMethod("getCookie", ["acceptedAllCookies"]) != "true") {
      Timer(Duration(milliseconds: 100), () {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            enableDrag: false,
            context: context,
            isDismissible: false,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Wrap(
                children: [
                  Center(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 600),
                      color: backgroundcolor_dark,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Datenschutz und Cookies",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                          "Um unseren Service auf einem hohen Qualitätslevel halten zu können, setzen wir wenige, technisch notwendige, und nicht-personenbezogene Drittanbieterdienste und Cookies ein."),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FlatButton(
                                    color: Colors.grey[700],
                                    height: 50,
                                    onPressed: () {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        isDismissible: false,
                                        enableDrag: false,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          bool _disableAnalytics = true;
                                          bool _consent = false;
                                          return Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              color: backgroundcolor_dark,
                                              constraints: BoxConstraints(
                                                  maxWidth: 600,
                                                  maxHeight:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height),
                                              child: SingleChildScrollView(
                                                child: StatefulBuilder(builder:
                                                    (BuildContext context,
                                                        StateSetter setState) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    "Präferenzen auswählen - Was möchten Sie erlauben?",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                  Text(
                                                                    "Klicken sie rechts auf das Symbol um zu der Datenschutzerklörung zu gelangen.",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Tooltip(
                                                              message:
                                                                  'Datenschutzerklärung',
                                                              child: IconButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(builder:
                                                                          (BuildContext
                                                                              context) {
                                                                    return PrivacyPolicy();
                                                                  }));
                                                                },
                                                                icon: Icon(Icons
                                                                    .security),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Divider(
                                                          thickness: 1,
                                                          color: Colors.grey,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                  "Cookies & Tracking (Google Analytics): Wir nutzen den Google Dienst Google "
                                                                  "Analytics um zu erfahren, wie viele Leute sich wann auf unserer Website befinden. "
                                                                  "Dabei werden nicht-personenbezogene und nicht-zuordnungsbare Informationen gesammelt, wie "
                                                                  "unteranderem Zeitpunkt des Aufrufs der Webseite, Aufenthaltsdauer auf der Webseite, ungefährer "
                                                                  "Standort des Nutzers, Informationen zum Endgerät etc. Weitere Informationen zu Google Analytics finden "
                                                                  "Sie in unserer Datenschutzerklärung."),
                                                            ),
                                                            Checkbox(
                                                                value:
                                                                    !_disableAnalytics,
                                                                activeColor:
                                                                    Colors.blue,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    _disableAnalytics =
                                                                        !value;
                                                                  });
                                                                  print(
                                                                      _disableAnalytics);
                                                                })
                                                          ],
                                                        ),
                                                        Divider(
                                                          thickness: 1,
                                                          color: Colors.grey,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                  "Ergeinis Tracking: Ergeinis (\"Event\") Tracking beinhaltet das Sammeln vo Daten bezüglich "
                                                                  "Eingaben, die Nutzer auf unserer Website machen. Eingaben können zum Beispiel Klicks auf Button sein, "
                                                                  "Interaktionen mit der Website, und deren Zeitpunkt. Das Hauptziel von Event Tracking ist herauszufinden, "
                                                                  "wie Nutzer sich auf unserer Website verhalten, also hauptsächlich, auf welche Buttons am meisten geklickt wird. "
                                                                  "Dabei werden keine personenbezogenen Daten gesammelt und Events sind niemanden zuordnungsbar."),
                                                            ),
                                                            Checkbox(
                                                                value: _consent,
                                                                activeColor:
                                                                    Colors.blue,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    _consent =
                                                                        value;
                                                                  });
                                                                })
                                                          ],
                                                        ),
                                                        Divider(
                                                          thickness: 1,
                                                          color: Colors.grey,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                FlatButton(
                                                                    height: 50,
                                                                    color: Colors
                                                                            .grey[
                                                                        700],
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        "Zurück")),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                FlatButton(
                                                                    height: 50,
                                                                    color: Colors
                                                                            .grey[
                                                                        700],
                                                                    onPressed:
                                                                        () {
                                                                      disableAnalytics =
                                                                          _disableAnalytics;
                                                                      consent =
                                                                          _consent;

                                                                      print(
                                                                          disableAnalytics);

                                                                      if (!disableAnalytics) {
                                                                        js.context.callMethod(
                                                                            'disableAnalytics',
                                                                            [
                                                                              disableAnalytics
                                                                            ]);
                                                                      }
                                                                      consentSetTrueSP();
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        "Auswahl\nbestätigen")),
                                                              ],
                                                            ),
                                                            FlatButton(
                                                                height: 50,
                                                                color:
                                                                    Colors.blue,
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _disableAnalytics =
                                                                        false;
                                                                    _consent =
                                                                        true;
                                                                  });
                                                                  disableAnalytics =
                                                                      _disableAnalytics;
                                                                  consent =
                                                                      _consent;

                                                                  if (!disableAnalytics) {
                                                                    js.context
                                                                        .callMethod(
                                                                            'disableAnalytics',
                                                                            [
                                                                          disableAnalytics
                                                                        ]);
                                                                  }
                                                                  consentSetTrueSP();
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    "Alle auswählen\nund bestätigen")),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Text("Verwalten")),
                                FlatButton(
                                    color: Colors.blue,
                                    height: 50,
                                    onPressed: () {
                                      consent = true;
                                      disableAnalytics = false;

                                      js.context.callMethod('setCookie',
                                          ["acceptedAllCookies", "true", 30]);

                                      print(js.context.callMethod(
                                          "getCookie", ["acceptedAllCookies"]));

                                      //cookie setzten dass alles akzeptiert wurde
                                      js.context.callMethod('disableAnalytics',
                                          [disableAnalytics]);
                                      consentSetTrueSP();

                                      Navigator.pop(context);
                                    },
                                    child: Text("Akzeptieren"))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            });
      });
      firstCall = false;
    }
  }

  bool firstCall = true;

  BuildContext contextMain;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundcolor_dark,
      child: Stack(
        children: [
          SingleChildScrollView(
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
                                          top: 8,
                                          left: 8,
                                          bottom: 8,
                                          right: 12),
                                      child: Image.asset(
                                        "assets/ceenes_logo_yellow4x.png",
                                        height: getLogoSize(),
                                      )),
                                  AutoSizeText(
                                    "Finde den perfekten Film. Swipe zusammen mit deinen Freunden.",
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
                                                " Erstellen ",
                                                style: TextStyle(
                                                    fontSize:
                                                        getButtonFontSize(),
                                                    color: backgroundcolor_dark,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              color: primary_color,
                                              onPressed: () {
                                                _sendAnalyticsEvent(
                                                    "Erstellen");
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return Create_View(
                                                    analytics: this.analytics,
                                                    observer: this.observer,
                                                  );
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
                                                      color: primary_color,
                                                      width: 2,
                                                      style: BorderStyle.solid),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: Text(
                                                " Teilnehmen ",
                                                style: TextStyle(
                                                    fontSize:
                                                        getButtonFontSize(),
                                                    color: primary_color),
                                              ),
                                              onPressed: () {
                                                _sendAnalyticsEvent(
                                                    "Teilnehmen");
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return Login_view(
                                                      analytics: this.analytics,
                                                      observer: this.observer);
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
                                padding: const EdgeInsets.only(top: 30),
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
                                                  padding:
                                                      const EdgeInsets.all(1),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    child: Container(
                                                        color:
                                                            backgroundcolor_dark,
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
                                      style: TextStyle(
                                          fontSize: 18, letterSpacing: 1),
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
                                                  padding:
                                                      const EdgeInsets.all(1),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    child: Container(
                                                        color:
                                                            backgroundcolor_dark,
                                                        padding:
                                                            EdgeInsets.only(
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
                                      style: TextStyle(
                                          fontSize: 18, letterSpacing: 1),
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
                                                  padding:
                                                      const EdgeInsets.all(1),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    child: Container(
                                                        color:
                                                            backgroundcolor_dark,
                                                        padding:
                                                            EdgeInsets.only(
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
                                  style:
                                      TextStyle(fontSize: 18, letterSpacing: 1),
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
                                  "Produkt erstellen, um euch den \"Film-Entscheidungs-Prozess\" zu erleichtern. ",
                                  style:
                                      TextStyle(fontSize: 18, letterSpacing: 1),
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
                                    onTap: () {
                                      _sendAnalyticsEvent(
                                          "Start View - Profil Lorenz");
                                      _launchURL2();
                                    },
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
                                      onTap: () {
                                        _sendAnalyticsEvent(
                                            "Start View - Profil Benji");
                                        _launchURL();
                                      },
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
                              /*
                              FlatButton(
                                  onPressed: () {
                                    setState(() {});
                                  },
                                  child: Text("Change background")),

                               */
                              InkWell(
                                onTap: () {
                                  _sendAnalyticsEvent(
                                      "Start View - Instagram Button");
                                  _launchURLIG();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                          _sendAnalyticsEvent(
                                              "Start View - Lizenzen und Credits Button");
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
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
                                          _sendAnalyticsEvent(
                                              "Start View - Privacy Policy Button");
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
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
          )
        ],
      ),
    );
  }
}
