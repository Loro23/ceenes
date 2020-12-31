import 'dart:async';

import 'package:ceenes_prototype/util/content.dart';
import 'package:ceenes_prototype/util/create_view_utils.dart';
import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/admin/admin_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:smart_select/smart_select.dart';
import 'package:smart_select/smart_select.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:smart_select/smart_select.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:ceenes_prototype/util/movie.dart';
import 'package:ceenes_prototype/util/movie_handler.dart';
import 'dart:convert';

class Create_View extends StatefulWidget {
  @override
  Create_ViewState createState() => Create_ViewState();
}

class Create_ViewState extends State<Create_View>
    with SingleTickerProviderStateMixin {
  Color dark_0 = Color.fromRGBO(21, 21, 21, 1);
  Color dark_1 = Color.fromRGBO(37, 37, 37, 1);
  Color white_0 = Color.fromRGBO(238, 238, 238, 1);

  String movies;
  Session session;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final mycontroller = TextEditingController();

  AnimationController _controller;
  Animation<Color> animation;

  List<String> valueGenre = [];
  List<String> valueProvider2 = [
    'Netflix',
    "Amazon Prime Video",
    "Joyn",
    "Disney Plus",
    "Sky Ticket",];

  final introKey = GlobalKey<IntroductionScreenState>();
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final formKey = GlobalKey<FormState>();
  List<String> formValue = [];

  bool _isDisabled = false;

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

      firestore
          .collection("sessions")
          .document(session.sessionId.toString())
          .collection("votes")
          .document("dummy_doc")
          .setData({});
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    animation = ColorTween(
      begin: Colors.blueAccent,
      end: Colors.grey,
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  String valuePart = "3";

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          height: MediaQuery.of(context).size.height,
          child: IntroductionScreen(
            key: introKey,
            pages: [
              PageViewModel(
                titleWidget: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
                  child: Text(
                    "Wie viele Personen seid ihr?",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                bodyWidget: ChipsChoice<String>.single(
                  value: valuePart,
                  onChanged: (val) => setState(() {
                    valuePart = val;
                    //print(valueProvider2);
                  }),
                  choiceItems: C2Choice.listFrom<String, String>(
                    source: optionsPart,
                    value: (i, v) => v,
                    label: (i, v) => v,
                    tooltip: (i, v) => v,
                  ),
                  choiceActiveStyle: C2ChoiceStyle(
                      color: Colors.blueAccent,
                      borderWidth: 2,
                      labelStyle: TextStyle(fontSize: 25),
                      borderOpacity: 0.5),
                  choiceStyle: C2ChoiceStyle(
                      color: Colors.white.withOpacity(0.8),
                      labelStyle: TextStyle(fontSize: 25)),
                  wrapped: true,
                  alignment: WrapAlignment.center,
                ),
              ),
              PageViewModel(
                titleWidget: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
                  child: Text(
                    "Streaming-Anbieter",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                bodyWidget: ChipsChoice<String>.multiple(
                  value: valueProvider2,
                  onChanged: (val) => setState(() {
                    valueProvider2 = val;
                    //print(valueProvider2);
                  }),
                  choiceItems: C2Choice.listFrom<String, String>(
                    source: optionsProvider2,
                    value: (i, v) => v,
                    label: (i, v) => v,
                    tooltip: (i, v) => v,
                  ),
                  choiceActiveStyle: C2ChoiceStyle(
                      color: Colors.blueAccent,
                      borderWidth: 2,
                      labelStyle: TextStyle(fontSize: 25),
                      borderOpacity: 0.5),
                  choiceStyle: C2ChoiceStyle(
                      color: Colors.white.withOpacity(0.8),
                      labelStyle: TextStyle(fontSize: 25)),
                  wrapped: true,
                  alignment: WrapAlignment.center,
                ),
              ),
              PageViewModel(
                titleWidget: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
                  child: Text(
                    "Genres",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                bodyWidget: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      FormField<List<String>>(
                        autovalidate: true,
                        initialValue: formValue,
                        onSaved: (val) => setState(() => formValue = val),
                        validator: (List value) {
                          if (value.length == 1 || value.length == 2) {
                            //print("mindestens 3 oder keins wählen");
                            return "Du kannst entweder keins oder mindestens 3 Genres auswählen";
                          }
                          return null;
                        },
                        builder: (state) {
                          return Column(
                            children: [
                              ChipsChoice<String>.multiple(
                                value: state.value,
                                onChanged: (val) {
                                  state.didChange(val);
                                  if (formKey.currentState.validate()) {
                                    // If the form is valid, save the value.
                                    formKey.currentState.save();
                                    valueGenre = val;
                                    setState(() {
                                      _isDisabled = false;
                                    });
                                    _controller.reverse();
                                  } else {
                                    _controller.forward();
                                    setState(() {
                                      _isDisabled = true;
                                    });
                                  }
                                },
                                choiceItems: C2Choice.listFrom<String, String>(
                                  source: optionsGenre2,
                                  value: (i, v) => v,
                                  label: (i, v) => v,
                                  tooltip: (i, v) => v,
                                ),
                                choiceActiveStyle: C2ChoiceStyle(
                                    color: Colors.lightBlueAccent,
                                    borderWidth: 2,
                                    labelStyle: TextStyle(fontSize: 18),
                                    borderOpacity: 0.5),
                                choiceStyle: C2ChoiceStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    labelStyle: TextStyle(fontSize: 18)),
                                wrapped: true,
                                alignment: WrapAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                              ),
                              // Divider(color: Colors.white.withOpacity(0.5),thickness: 1,),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? "",
                                    style: TextStyle(
                                        color: state.hasError
                                            ? Color.fromRGBO(207, 102, 121, 1)
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
            //showSkipButton: true,
            showNextButton: true,
            skipFlex: 0,
            nextFlex: 0,
            animationDuration: 300,
            curve: Curves.easeOutCirc,
            skip: const Text('Skip'),
            next: FloatingActionButton.extended(
              heroTag: "2",
              label: Icon(Icons.arrow_forward),
            ),
            done: FloatingActionButton.extended(
              heroTag: "2",
              label: Text(
                "Weiter",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _isDisabled
                  ? null
                  : () async {
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
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Text(
                                      "Filme werden geladen. Das kann ein paar Sekunden dauern",
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                      this.session = new Session(
                          valuePart, getGenreIds(valueGenre), valueProvider2);

                      await MovieHandler.getMovies(this.session, this)
                          .then((movies) {
                            this.movies = json.encode(
                                movies); //movie result als json string erstellen
                          })
                          .whenComplete(() => createRecord())
                          .whenComplete(() {
                            Navigator.pop(context); //dialog beenden
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return AdminLogin(this.session, this.movies);
                            }));
                          });
                    },
              backgroundColor: animation.value,
            ),
            dotsDecorator: const DotsDecorator(
              size: Size(10.0, 10.0),
              color: Color(0xFFBDBDBD),
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          )),
    );
  }
}
