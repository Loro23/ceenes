import 'package:ceenes_prototype/util/content.dart';
import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/admin/admin_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:smart_select/smart_select.dart';
import 'package:chips_choice/chips_choice.dart';

GlobalKey key = new GlobalKey();

class Create_View extends StatefulWidget {
  @override
  _Create_ViewState createState() => _Create_ViewState();
}

class _Create_ViewState extends State<Create_View> {
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

  List<S2Choice<String>> optionsGenre = [
    S2Choice<String>(value: '28', title: 'Action'),
    S2Choice<String>(value: '16', title: 'animiert'),
    S2Choice<String>(value: '99', title: 'Dokumentation'),
    S2Choice<String>(value: '18', title: 'Drama'),
    S2Choice<String>(value: '10751', title: 'Familie'),
    S2Choice<String>(value: '14', title: 'Fantasie'),
    S2Choice<String>(value: '36', title: 'Geschichte'),
    S2Choice<String>(value: '35', title: 'Komödie'),
    S2Choice<String>(value: '10752', title: 'Krieg'),
    S2Choice<String>(value: '80', title: 'Krimi'),
    S2Choice<String>(value: '10402', title: 'Musik'),
    S2Choice<String>(value: '9648', title: 'Mystisch'),
    S2Choice<String>(value: '10749', title: 'Romantisch'),
    S2Choice<String>(value: '878', title: 'Sci-Fi'),
    S2Choice<String>(value: '27', title: 'Horror'),
    S2Choice<String>(value: '107770', title: 'TV-Film'),
    S2Choice<String>(value: '53', title: 'Thriller'),
    S2Choice<String>(value: '37', title: 'Western'),
    S2Choice<String>(value: '12', title: 'Abenteuer'),
  ];

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
  List<String> optionsProvider2 = ['Netflix', "Prime Video", "Sky", "Joyn"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: dark_0,
        child: SingleChildScrollView(
          //padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Gruppe erstellen',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                  'Hier kannst du festlegen, was du für Filme vorgeschlagen bekommen möchtest.',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Content(
                title: "Anzahl Filme",
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
                  runSpacing: 4,
                  choiceActiveStyle: C2ChoiceStyle(
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ),
              Content(
                title: 'Mindestbewertung (von 10)',
                child: ChipsChoice<int>.single(
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
                  runSpacing: 4,
                  choiceActiveStyle: C2ChoiceStyle(
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ),
              Content(
                title: 'Optional: Wähle Genres aus',
                child: SmartSelect<String>.multiple(
                  value: valueGenre,
                  title: "Genres",
                  choiceItems: optionsGenre,
                  placeholder: "Wählen",
                  modalTitle: "Wähle die Genres, die ihr haben wollt. ",
                  onChange: (state) => setState(() {
                    valueGenre = state.value;
                    print(valueGenre);
                  }),
                  modalType: S2ModalType.bottomSheet,
                  choiceType: S2ChoiceType.chips,
                  choiceStyle:
                      S2ChoiceStyle(runSpacing: 4, activeColor: Colors.green),
                ),
              ),
              Content(
                title: "Wie viele Leute seid ihr?",
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
                  runSpacing: 4,
                  choiceActiveStyle: C2ChoiceStyle(
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ),
              /*
              Container(
                child: Text(
                    "Optional: Wie viele Minuten soll der Film maximal dauern?"),
                color: Colors.blueGrey[100],
                width: double.maxFinite,
                padding: const EdgeInsets.all(8.0),
              ),
              Container(
                width: double.maxFinite,
                color: Colors.blueGrey[50],
                child: ChipsChoice<int>.single(
                  value: tag2,
                  onChanged: (val) => setState(() {tag2 = val;  valueRuntime2 = optionsRuntime2[val]; print(valueRuntime2);}),
                  choiceItems: C2Choice.listFrom<int, String>(
                    source: optionsRuntime2,
                    value: (i, v) => i,
                    label: (i, v) => v,
                  ),
                  runSpacing: 4,
                  spacing: 4,
                ),
              ),

              Container(
                child: Text(
                  'Optional: Welche Streaminganbieter habt ihr?',
                ),
                color: Colors.blueGrey[100],
                width: double.maxFinite,
                padding: const EdgeInsets.all(8.0),
              ),
              Container(
                width: double.maxFinite,
                color: Colors.blueGrey[50],
                child: ChipsChoice<String>.multiple(
                  value: valueProvider2,
                  onChanged: (val) => setState(() { valueProvider2 = val; print(valueProvider2);}),
                  choiceItems: C2Choice.listFrom<String, String>(
                    source: optionsProvider2,
                    value: (i, v) => v,
                    label: (i, v) => v,
                    tooltip: (i, v) => v,
                  ),
                  choiceStyle: C2ChoiceStyle(),
                  wrapped: true,

                  runSpacing: 4,
                ),
              ),

               */
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
