import 'package:ceenes_prototype/util/content.dart';
import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/admin/admin_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:smart_select/smart_select.dart';
import 'package:smart_select/smart_select.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:smart_select/smart_select.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:introduction_screen/introduction_screen.dart';

GlobalKey key = new GlobalKey();

class Create_View extends StatefulWidget {
  @override
  _Create_ViewState createState() => _Create_ViewState();
}

class _Create_ViewState extends State<Create_View> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Color dark_0 = Color.fromRGBO(21, 21, 21, 1);
  Color dark_1 = Color.fromRGBO(37, 37, 37, 1);
  Color white_0 = Color.fromRGBO(238, 238, 238, 1);
  String valueNumber = "20";
  List<String> valueGenre = [];
  String numParticipants = "2";

  final mycontroller = TextEditingController();

  List<S2Choice<String>> optionsNumber = [
    S2Choice<String>(value: '20', title: '20'),
    S2Choice<String>(value: '40', title: '40'),
    S2Choice<String>(value: '60', title: '60'),
  ];

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

  int tag = 0;
  String valueNumber2 = "20";
  List<String> optionsNumber2 = ["20", "40", "60"];

  int tag1 = 0;
  String numParticipants2 = "2";
  List<String> optionsPatNumber2 = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "8",
    "10",
    "11",
    "12"
  ];
  int tag2 = 0;
  String valueRuntime2 = "Egal";
  List<String> optionsRuntime2 = ["Egal", "30", "45", "60", "90", "90+"];
  int tag3 = 4;
  String valueVotes = "5";
  List<String> optionsVotes = ["1", "2", "3", "4", "5", "6", "7+"];

  List<String> valueProvider2 = [];
  List<String> optionsProvider2 = [
    'Netflix',
    "Prime Video",
    "Sky",
    "Joyn",
    "Disney+"
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
      /*
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return AdminLogin(
                  int.parse(numParticipants),
                  int.parse(valueNumber),
                  valueGenre,
                  valueRuntime2,
                  valueVotes);
            }));
          },
          label: Text("Weiter")),

       */
      body: Container(
          //padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
          height: MediaQuery.of(context).size.height,
          //color: Colors.blue,
          child: IntroductionScreen(
            key: introKey,
            pages: [
              PageViewModel(
                titleWidget: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 25),
                      child: Text(
                        "Anzahl Filme",
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
                        "Hier kannst du auswählen, wie viele Filme ihr swipen wollt",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                bodyWidget: Container(
                  //color: Colors.blue[],
                  height: MediaQuery.of(context).size.height * 0.5,
                  alignment: Alignment.center,
                  child: ChipsChoice<int>.single(
                    value: tag,
                    onChanged: (val) => setState(() {
                      tag = val;
                      valueNumber = optionsNumber2[tag];
                      print(valueNumber);
                    }),
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: optionsNumber2,
                      value: (i, v) => i,
                      label: (i, v) => v,
                    ),
                    runSpacing: 10,
                    choiceActiveStyle: C2ChoiceStyle(
                        color: Colors.lightBlueAccent,

                        //borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  //color: Colors.blue,
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

                        //borderRadius: BorderRadius.all(Radius.circular(10)),
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

                      //borderRadius: BorderRadius.all(Radius.circular(10)),
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
                titleWidget: Column(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, top: 25),
                    child: Text(
                      "Wie viele Leute seid ihr",
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
                      "Hier kannst du auswählen, mit wie vielen Personen ihr insgesamt swipen wollt.",
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
                    value: tag1,
                    onChanged: (val) => setState(() {
                      tag1 = val;
                      numParticipants = optionsPatNumber2[val];
                      print(numParticipants);
                    }),
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: optionsPatNumber2,
                      value: (i, v) => i,
                      label: (i, v) => v,
                    ),
                    runSpacing: 10,
                    choiceActiveStyle: C2ChoiceStyle(
                        color: Colors.lightBlueAccent,

                        //borderRadius: BorderRadius.all(Radius.circular(10)),
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

                        //borderRadius: BorderRadius.all(Radius.circular(10)),
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

                        //borderRadius: BorderRadius.all(Radius.circular(10)),
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
            ],
            onDone: () {},

            //showSkipButton: true,
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
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return AdminLogin(
                      int.parse(numParticipants),
                      int.parse(valueNumber),
                      getGenreIds(valueGenre),
                      valueRuntime2,
                      valueVotes);
                }));
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
