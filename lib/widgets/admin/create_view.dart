import 'dart:async';
import 'dart:convert';

import 'package:ceenes_prototype/util/colors.dart';
import 'package:ceenes_prototype/util/create_view_utils.dart';
import 'package:ceenes_prototype/util/movie_handler.dart';
import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/admin/admin_login.dart';
import 'package:ceenes_prototype/widgets/start_view.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Create_View extends StatefulWidget {
  Create_View({this.analytics, this.observer});

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  Create_ViewState createState() => Create_ViewState(analytics, observer);
}

class Create_ViewState extends State<Create_View>
    with TickerProviderStateMixin {
  Create_ViewState(this.analytics, this.observer);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  String movies;
  Session session;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final mycontroller = TextEditingController();
  final _myController = TextEditingController();

  AnimationController _controller;
  Animation<Color> animation;

  AnimationController _controller2;
  Animation<Color> animation2;

  List<String> valueGenre = [];
  List<String> valueProvider2 = [
    'Netflix',
    "Amazon Prime Video",
    "Joyn",
    "Disney Plus",
    "Sky Ticket",
  ];

  final introKey = GlobalKey<IntroductionScreenState>();
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final formKey = GlobalKey<FormState>();
  List<String> formValue = [];

  final formKey2 = GlobalKey<FormState>();
  List<String> formValue2 = [];

  bool _isDisabled = true;

  void createRecord() async {
    await firestore
        .collection("sessions")
        .document(session.sessionId.toString())
        .setData({}).then((value) {
      firestore
          .collection("sessions")
          .document(session.sessionId.toString())
          .setData({});

      firestore
          .collection("sessions")
          .document(session.sessionId.toString())
          .updateData({"movies_json": this.movies});
      firestore
          .collection("sessions")
          .document(session.sessionId.toString())
          .updateData({"numberPart": session.numPats});

      /*
      firestore
          .collection("sessions")
          .document(session.sessionId.toString())
          .updateData({"session": jsonEncode(session)});

      firestore
          .collection("sessions")
          .document(session.sessionId.toString())
          .updateData({"nextSession": null});

       */

      firestore
          .collection("sessions")
          .document(session.sessionId.toString())
          .collection("votes")
          .document("dummy_doc")
          .setData({});
    });
  }

  Future<void> _sendAnalyticsEvent(String what) async {
    if (!consent) return;
    await analytics.logEvent(
      name: what,
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _sendAnalyticsEvent("Create View - Init State");
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    animation = ColorTween(
      begin: Colors.grey[600],
      end: primary_color,
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    animation2 = ColorTween(
      begin: Colors.grey[100],
      end: backgroundcolor_dark,
    ).animate(_controller2)
      ..addListener(() {
        setState(() {});
      });
  }

  String valuePart = "3";
  RangeValues _currentRangeValues = const RangeValues(2000, 2021);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Material(
      color: backgroundcolor_dark,
      child: WillPopScope(
        onWillPop: () async => true,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: IntroductionScreen(
                    globalBackgroundColor: backgroundcolor_dark,
                    key: introKey,
                    pages: [
                      // PageViewModel(
                      //   titleWidget: Padding(
                      //     padding: const EdgeInsets.only(
                      //         left: 25, right: 25, top: 50),
                      //     child: Text(
                      //       "Wie viele Personen seid ihr?",
                      //       style: TextStyle(
                      //         fontSize: 36,
                      //         fontWeight: FontWeight.w600,
                      //       ),
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ),
                      //   bodyWidget: ChipsChoice<String>.single(
                      //     value: valuePart,
                      //     onChanged: (val) => setState(() {
                      //       valuePart = val;
                      //       //print(valueProvider2);
                      //     }),
                      //     choiceItems: C2Choice.listFrom<String, String>(
                      //       source: optionsPart,
                      //       value: (i, v) => v,
                      //       label: (i, v) => v,
                      //       tooltip: (i, v) => v,
                      //     ),
                      //     choiceActiveStyle: C2ChoiceStyle(
                      //         color: primary_color,
                      //         borderWidth: 2,
                      //         labelStyle: TextStyle(fontSize: 25),
                      //         borderOpacity: 0.5),
                      //     choiceStyle: C2ChoiceStyle(
                      //         color: Colors.white.withOpacity(0.8),
                      //         labelStyle: TextStyle(fontSize: 25)),
                      //     wrapped: true,
                      //     alignment: WrapAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     scrollPhysics: ClampingScrollPhysics(),
                      //     runSpacing: 5,
                      //     spacing: 5,
                      //   ),
                      // ),
                      PageViewModel(
                        titleWidget: Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 50),
                          child: Text(
                            "Welche Genres?",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        bodyWidget: ChipsChoice<String>.multiple(
                          value: valueGenre,
                          wrapped: true,
                          onChanged: (val) => setState(() {
                            valueGenre = val;
                            // print(valueGenre);
                          }),
                          choiceItems: C2Choice.listFrom<String, String>(
                            source: optionsGenre2,
                            value: (i, v) => v,
                            label: (i, v) => v,
                          ),
                          choiceActiveStyle: C2ChoiceStyle(
                              color: primary_color,
                              borderWidth: 2,
                              labelStyle: TextStyle(fontSize: 18),
                              borderOpacity: 0.5),
                          choiceStyle: C2ChoiceStyle(
                              color: Colors.white.withOpacity(0.8),
                              labelStyle: TextStyle(fontSize: 18)),
                          alignment: WrapAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          scrollPhysics: ClampingScrollPhysics(),
                          runSpacing: 5,
                          spacing: 5,
                        ),
                      ),
                      PageViewModel(
                          titleWidget: Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 50),
                            child: Text(
                              "Erscheinungsjahr",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          bodyWidget: Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Text(
                              _currentRangeValues.start.toInt().toString() +
                                  " - " +
                                  _currentRangeValues.end.toInt().toString(),
                              style: TextStyle(fontSize: 35),
                            ),
                          ),
                          footer: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Row(
                              children: [
                                Text("1950"),
                                Expanded(
                                  child: RangeSlider(
                                    activeColor: primary_color,
                                    inactiveColor:
                                        Colors.yellow.withOpacity(0.1),
                                    values: _currentRangeValues,
                                    min: 1950,
                                    max: 2021,
                                    divisions: 71,
                                    labels: RangeLabels(
                                      _currentRangeValues.start
                                          .round()
                                          .toString(),
                                      _currentRangeValues.end
                                          .round()
                                          .toString(),
                                    ),
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        _currentRangeValues = values;
                                      });
                                    },
                                  ),
                                ),
                                Text("2021"),
                              ],
                            ),
                          )),
                      PageViewModel(
                        titleWidget: Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 50),
                          child: Text(
                            "Welche Streaming-Anbieter habt ihr?",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        bodyWidget: Form(
                          key: formKey2,
                          child: Column(
                            children: [
                              FormField<List<String>>(
                                autovalidate: true,
                                initialValue: formValue2,
                                onSaved: (val) =>
                                    setState(() => formValue2 = val),
                                validator: (List value) {
                                  if (value.isEmpty) {
                                    return "Wähle mindestens einen Anbieter aus.";
                                  }
                                  _isDisabled = false;
                                  return null;
                                },
                                builder: (state) {
                                  return Column(
                                    children: [
                                      ChipsChoice<String>.multiple(
                                        value: state.value,
                                        onChanged: (val) {
                                          state.didChange(val);
                                          //  print(formKey2.currentState.validate());
                                          if (formKey2.currentState
                                              .validate()) {
                                            // If the form is valid, save the value.
                                            formKey2.currentState.save();
                                            valueProvider2 = val;
                                            // print(valueProvider2);
                                            setState(() {
                                              _isDisabled = false;
                                            });
                                            _controller.forward();
                                            _controller2.forward();
                                          } else {
                                            _controller.reverse();
                                            _controller2.reverse();

                                            setState(() {
                                              _isDisabled = true;
                                            });
                                          }
                                        },
                                        choiceItems:
                                            C2Choice.listFrom<String, String>(
                                          source: optionsProvider2,
                                          value: (i, v) => v,
                                          label: (i, v) => v,
                                          tooltip: (i, v) => v,
                                        ),
                                        choiceActiveStyle: C2ChoiceStyle(
                                            color: primary_color,
                                            borderWidth: 2,
                                            labelStyle: TextStyle(fontSize: 18),
                                            borderOpacity: 0.5),
                                        choiceStyle: C2ChoiceStyle(
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            labelStyle:
                                                TextStyle(fontSize: 18)),
                                        wrapped: true,
                                        alignment: WrapAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        scrollPhysics: ClampingScrollPhysics(),
                                        runSpacing: 5,
                                        spacing: 5,
                                      ),
                                      // Divider(color: Colors.white.withOpacity(0.5),thickness: 1,),
                                      Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 15, 10),
                                          alignment: Alignment.center,
                                          child: Text(
                                            state.errorText ?? "",
                                            style: TextStyle(
                                                color: state.hasError
                                                    ? Color.fromRGBO(
                                                        207, 102, 121, 1)
                                                    : null,
                                                fontSize: 18),
                                          )),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    onDone: () {},
                    freeze: false,
                    showNextButton: true,
                    skipFlex: 0,
                    nextFlex: 0,
                    animationDuration: 500,
                    curve: Curves.easeOutCirc,
                    skip: const Text('Skip'),
                    next: Icon(
                      Icons.arrow_forward,
                      size: 40,
                      color: Colors.white,
                    ),
                    done: FloatingActionButton.extended(
                      backgroundColor: animation.value,
                      heroTag: "2",
                      label: Text(
                        "Erstellen",
                        style: TextStyle(color: animation2.value),
                      ),
                      onPressed: _isDisabled
                          ? () {
                              _sendAnalyticsEvent(
                                  "Create View - Erstellen Button");
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.error,
                                                color: Color.fromRGBO(
                                                    207, 102, 121, 1),
                                                size: 40,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: new Text(
                                                  "Bitte wähle mindestens einen Streaming Anbieter aus um zu starten!",
                                                  overflow: TextOverflow.clip,
                                                  style:
                                                      TextStyle(fontSize: 22),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          : () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child:
                                                  new CircularProgressIndicator(
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                        Color>(blue_ceenes),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: new Text(
                                                  "Filme werden ausgesucht. Das kann einen Moment dauern...",
                                                  overflow: TextOverflow.clip,
                                                  style:
                                                      TextStyle(fontSize: 22),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                              this.session = new Session(valuePart,
                                  getGenreIds(valueGenre), valueProvider2,
                                  releaseDateGte:
                                      this._currentRangeValues.start.toInt() -
                                          1,
                                  releaseDateSme:
                                      this._currentRangeValues.end.toInt() + 1);

                              await MovieHandler.getMoviesNew2(this.session)
                                  .then((movies) {
                                print(movies);
                                if (movies.length == 0) {
                                  print("length i 0");
                                  this.movies = "";
                                  return;
                                }

                                this.movies = json.encode(
                                    movies); //movie result als json string erstellen
                              }).whenComplete(() {
                                if (movies.length > 0) {
                                  createRecord();
                                }
                              }).whenComplete(() {
                                Navigator.pop(context); //dialog beenden
                                if (movies.length > 0) {
                                  _sendAnalyticsEvent(
                                      "Create View - Enough movies found");
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return AdminLogin(this.session, this.movies,
                                        analytics: this.analytics,
                                        observer: this.observer);
                                  }));
                                } else {
                                  _sendAnalyticsEvent(
                                      "Create View - No movies found");
                                  showDialog(
                                      child: Dialog(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.sentiment_dissatisfied,
                                                  size: 50,
                                                  color: error_ceenes,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Zu deiner Auswahl wurden nicht genug Filme gefunden. "
                                                  "Bitte wähle mehr oder andere Genres aus oder füge andere Streaming-Anbieter hinzu.\n\n"
                                                  "Beachte: Manche Anbieter haben bestimmte Genres nicht im Angebot. ",
                                                  overflow: TextOverflow.clip,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      context: context);
                                }
                              });
                            },
                    ),
                    dotsDecorator: DotsDecorator(
                      activeColor: blue_ceenes,
                      size: Size(10.0, 10.0),
                      color: Colors.grey,
                      activeSize: Size(22.0, 10.0),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                  )),
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
                          _sendAnalyticsEvent("Create View - Back Button");
                          Navigator.pop(context);
                        },
                        splashRadius: 20,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 8, left: 8, bottom: 8, right: 12),
                        child: Hero(
                          child: Image.asset(
                            "assets/ceenes_logo_yellow4x.png",
                            height: 40,
                          ),
                          tag: 44,
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
