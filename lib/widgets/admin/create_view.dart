import 'package:ceenes_prototype/util/content.dart';
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
  _Create_ViewState createState() => _Create_ViewState();
}

class _Create_ViewState extends State<Create_View> {
  String movies;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Session session;

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
          .collection("votes")
          .document("dummy_doc")
          .setData({});
    });
  }

  final introKey = GlobalKey<IntroductionScreenState>();

  Color dark_0 = Color.fromRGBO(21, 21, 21, 1);
  Color dark_1 = Color.fromRGBO(37, 37, 37, 1);
  Color white_0 = Color.fromRGBO(238, 238, 238, 1);
  List<String> valueGenre = [];

  final mycontroller = TextEditingController();

  List<String> optionsGenre2 = [
    "Action",
    "animiert",
    "Dokumentation",
    "Drama",
    "Familie",
    "Fantasie",
    "Geschichte",
    "Komödie",
    "Krieg",
    "Krimi",
    "Musik",
    "Mystisch",
    "Romantisch",
    "Sci-Fi",
    "Horror",
    "TV-Film",
    "Thriller",
    "Western",
    "Abenteuer"
  ];

  List<String> getGenreIds(List<String> genres) {
    List<String> genreIds = [];
    for (String genre in genres) {
      switch (genre) {
        case ("action"):
          genreIds.add("28");
          break;
        case ("animiert"):
          genreIds.add("16");
          break;
        case ("Dokumentation"):
          genreIds.add("99");
          break;
        case ("Drama"):
          genreIds.add("18");
          break;
        case ("Familie"):
          genreIds.add("10751");
          break;
        case ("Fantasie"):
          genreIds.add("14");
          break;
        case ("Geschichte"):
          genreIds.add("36");
          break;
        case ("Komödie"):
          genreIds.add("35");
          break;
        case ("Krieg"):
          genreIds.add("10752");
          break;
        case ("Krimi"):
          genreIds.add("80");
          break;
        case ("Mystisch"):
          genreIds.add("9648");
          break;
        case ("Romantisch"):
          genreIds.add("10749");
          break;
        case ("Sci-Fi"):
          genreIds.add("878");
          break;
        case ("Horror"):
          genreIds.add("27");
          break;
        case ("TV-Film"):
          genreIds.add("107770");
          break;
        case ("Thriller"):
          genreIds.add("53");
          break;
        case ("Western"):
          genreIds.add("37");
          break;
        case ("Abenteuer"):
          genreIds.add("12");
          break;
      }
    }
    return genreIds;
  }

  int tag2 = 0;
  String valueRuntime2 = "Egal";
  List<String> optionsRuntime2 = ["Egal", "30", "45", "60", "90", "90+"];
  int tag3 = 4;
  String valueVotes = "5";
  List<String> optionsVotes = ["1", "2", "3", "4", "5", "6", "7+"];

  List<String> valueProvider2 = [];
  List<String> optionsProvider2 = [
    'Netflix',
    "Amazon Prime Video",
    "Sky",
    "Joyn",
    "Joyn Plus",
    "Disney Plus",
    "Apple TV Plus",
    "Apple TV",
    "Sky Ticket",
    "Sky Go",
    "TV NOW"
  ];

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: IntroductionScreen(
            key: introKey,
            pages: [
              PageViewModel(
                titleWidget: Column(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, top: 25),
                    child: Text(
                      "Streaming-Anbieter",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, top: 25),
                    child: Text(
                      "Hier kannst du auswählen, welche Streaminganbieter ihr habt, damit nur Filme angezeigt werden, die ihr auch gucken könnt.",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ]),
                bodyWidget: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  alignment: Alignment.center,
                  child: ChipsChoice<String>.multiple(
                    value: valueProvider2,
                    onChanged: (val) => setState(() {
                      valueProvider2 = val;
                      print(valueProvider2);
                    }),
                    choiceItems: C2Choice.listFrom<String, String>(
                      source: optionsProvider2,
                      value: (i, v) => v,
                      label: (i, v) => v,
                      tooltip: (i, v) => v,
                    ),
                    runSpacing: 10,
                    choiceActiveStyle: C2ChoiceStyle(
                        color: Colors.lightBlueAccent,
                        borderWidth: 2,
                        labelStyle: TextStyle(fontSize: 20),
                        borderOpacity: 0.5),
                    choiceStyle: C2ChoiceStyle(
                        color: Colors.white.withOpacity(0.8),
                        labelStyle: TextStyle(fontSize: 20)),
                    wrapped: true,
                  ),
                ),
              ),
              PageViewModel(
                titleWidget: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 15),
                      child: Text(
                        "Genres",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 15),
                      child: Text(
                        "Hier kannst du auswählen, welche Genres die Filme haben sollen, die euch angezeigt werden.",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                bodyWidget: ChipsChoice<String>.multiple(
                  value: valueGenre,
                  onChanged: (val) => setState(() {
                    valueGenre = val;
                    print(valueGenre);
                  }),
                  choiceItems: C2Choice.listFrom<String, String>(
                    source: optionsGenre2,
                    value: (i, v) => v,
                    label: (i, v) => v,
                    tooltip: (i, v) => v,
                  ),
                  runSpacing: 6,
                  choiceActiveStyle: C2ChoiceStyle(
                      color: Colors.lightBlueAccent,
                      borderWidth: 2,
                      labelStyle: TextStyle(fontSize: 18),
                      borderOpacity: 0.5),
                  choiceStyle: C2ChoiceStyle(
                      color: Colors.white.withOpacity(0.8),
                      labelStyle: TextStyle(fontSize: 18)),
                  wrapped: true,
                ),
              ),
              PageViewModel(
                titleWidget: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 25),
                      child: Text(
                        "Bewertung",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 25),
                      child: Text(
                        "Hier kannst du auswählen, wie gut die Filme bewertet sein sollen. Es gibt maximal 10 Punkte",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                bodyWidget: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  alignment: Alignment.center,
                  child: ChipsChoice<int>.single(
                    alignment: WrapAlignment.start,
                    value: tag3,
                    onChanged: (val) => setState(() {
                      tag3 = val;
                      valueVotes = optionsVotes[tag3];
                      print(valueVotes);
                    }),
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: optionsVotes,
                      value: (i, v) => i,
                      label: (i, v) => v,
                    ),
                    runSpacing: 10,
                    choiceActiveStyle: C2ChoiceStyle(
                        color: Colors.lightBlueAccent,
                        borderWidth: 2,
                        labelStyle: TextStyle(fontSize: 40),
                        borderOpacity: 0.5),
                    choiceStyle: C2ChoiceStyle(
                        color: Colors.white.withOpacity(0.8),
                        labelStyle: TextStyle(fontSize: 40)),
                    wrapped: true,
                  ),
                ),
              ),

              /*
              PageViewModel(
                titleWidget: Column(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, top: 25),
                    child: Text(
                      "Laufzeit",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, top: 25),
                    child: Text(
                      "Wie viele Minuten soll der Film maximal gehen?",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ]),
                bodyWidget: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  alignment: Alignment.center,
                  child: ChipsChoice<int>.single(
                    value: tag2,
                    onChanged: (val) => setState(() {
                      tag2 = val;
                      valueRuntime2 = optionsRuntime2[val];
                      print(valueRuntime2);
                    }),
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: optionsRuntime2,
                      value: (i, v) => i,
                      label: (i, v) => v,
                    ),
                    runSpacing: 10,
                    choiceActiveStyle: C2ChoiceStyle(
                        color: Colors.lightBlueAccent,
                        borderWidth: 2,
                        labelStyle: TextStyle(fontSize: 40),
                        borderOpacity: 0.5),
                    choiceStyle: C2ChoiceStyle(
                        color: Colors.white.withOpacity(0.8),
                        labelStyle: TextStyle(fontSize: 40)),
                    wrapped: true,
                  ),
                ),
              ),
              */
            ],
            onDone: () {},
            showSkipButton: true,
            showNextButton: true,
            skipFlex: 0,
            nextFlex: 0,
            animationDuration: 500,
            curve: Curves.easeInOutCubic,
            skip: const Text('Skip'),
            next: Hero(
                tag: "0",
                child: const Icon(
                  Icons.arrow_forward,
                  size: 40,
                )),
            done: FloatingActionButton.extended(
              heroTag: "2",
              label: Text(
                "Weiter",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
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
                            child: new Text("Session erstellen..."),
                          ),
                        ],
                      ),
                    );
                  },
                );
                this.session = new Session(getGenreIds(valueGenre),
                    valueRuntime2, valueVotes, valueProvider2);

                await MovieHandler.getMovies(this.session)
                    .then((movies) {
                      this.movies = json.encode(
                          movies); //movie result als json string erstellen
                    })
                    .whenComplete(() => createRecord())
                    .whenComplete(() {
                      Navigator.pop(context); //dialog beenden
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return AdminLogin(this.session, this.movies);
                      }));
                    });
              },
              backgroundColor: Colors.pinkAccent,
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
