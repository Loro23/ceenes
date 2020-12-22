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
  String valueNumber = "20";
  List<String> valueGenre = ["0"];
  String numParticipants = "2";

  final mycontroller = TextEditingController();

  List<S2Choice<String>> optionsNumber = [
    S2Choice<String>(value: '20', title: '20'),
    S2Choice<String>(value: '40', title: '40'),
    S2Choice<String>(value: '60', title: '60'),
  ];

  List<S2Choice<String>> optionsGenre = [
    S2Choice<String>(value: '0', title: 'Alle'),
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

  List<S2Choice<String>> optionsPatNumber = [
    S2Choice<String>(value: '1', title: '1'),
    S2Choice<String>(value: '2', title: '2'),
    S2Choice<String>(value: '3', title: '3'),
    S2Choice<String>(value: '4', title: '4'),
    S2Choice<String>(value: '5', title: '5'),
    S2Choice<String>(value: '6', title: '6'),
    S2Choice<String>(value: '7', title: '7'),
    S2Choice<String>(value: '8', title: '8'),
    S2Choice<String>(value: '9', title: '9'),
    S2Choice<String>(value: '10', title: '10'),
    S2Choice<String>(value: '11', title: '11'),
    S2Choice<String>(value: '12', title: '12'),
  ];



  int tag = 0;
  String valueNumber2 = "20";
  List<String> optionsNumber2 = [
    "20","40", "60"
  ];
  List<String> valueGenre2 = ["0"];
  List<String> optionsGenre2 = ['Action', 'animiert','Dokumentation','Drama','Familie','Fantasie','Geschichte','Komödie','Krieg','Krimi','Musik','Mystisch','Romantisch',
    'Sci-Fi','Horror','TV-Film','Thriller','Western', 'Abenteuer',
  ];

  int tag1 = 0;
  String numParticipants2 = "2";
  List<String> optionsPatNumber2 = [
    "1", "2", "3","4","5", "6","7","8","8","10","11","12"
  ];
  int tag2 = 0;
  String runtime2 = "Egal";
  List<String> optionsRuntime2 = ["Egal", "30", "45", "60", "90","90+"];

  List<String> valueProvider2= ["0"];
  List<String> optionsProvider2= ['Netflix', "Prime Video", "Sky", "Joyn"
  ];





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return AdminLogin(int.parse(numParticipants),
                      int.parse(valueNumber), valueGenre);
                }));
          },
          label: Text("Weiter")),
      body: Material(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Gruppe erstellen',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                Text('Hier kannst du festlegen, was du für Filme vorgeschlagen bekommen möchtest.',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Content(
                  title: "Anzahl Filme",
                  child: ChipsChoice<int>.single(

                    value: tag,
                    onChanged: (val) => setState(() => tag = val),
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: optionsNumber2,
                      value: (i, v) => i,
                      label: (i, v) => v,
                    ),
                  ),
                ),
                Content(
                  title: 'Optional: Wähle Genres aus',
                  child: ChipsChoice<String>.multiple(
                    value: valueGenre2,
                    onChanged: (val) => setState(() => valueGenre2 = val),
                    choiceItems: C2Choice.listFrom<String, String>(
                      source: optionsGenre2,
                      value: (i, v) => v,
                      label: (i, v) => v,
                      tooltip: (i, v) => v,
                    ),
                    wrapped: true,
                    textDirection: TextDirection.ltr,
                    alignment: WrapAlignment.spaceEvenly,
                    runSpacing: 8,
                  ),
                ),
                Content(
                  title: "Wie viele Leute seid ihr?",
                  child: ChipsChoice<int>.single(

                    value: tag1,
                    onChanged: (val) => setState(() => tag1 = val),
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: optionsPatNumber2,
                      value: (i, v) => i,
                      label: (i, v) => v,
                    ),
                    //wrapped: true,
                    textDirection: TextDirection.ltr,
                    alignment: WrapAlignment.spaceEvenly,
                    runSpacing: 8,
                  ),
                ),
                Content(
                  title: "Optional: Wie viele Minuten soll der Film maximal dauern?",
                  child: ChipsChoice<int>.single(

                    value: tag2,
                    onChanged: (val) => setState(() => tag2 = val),
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: optionsRuntime2,
                      value: (i, v) => i,
                      label: (i, v) => v,
                    ),

                    //wrapped: true,
                    textDirection: TextDirection.ltr,
                    alignment: WrapAlignment.spaceAround,
                    runSpacing: 10,
                    spacing: 10,
                  ),
                ),
                Content(
                  title: 'Optional: Welche Streaminganbieter habt ihr?',
                  child: ChipsChoice<String>.multiple(
                    value: valueProvider2,
                    onChanged: (val) => setState(() => valueProvider2 = val),
                    choiceItems: C2Choice.listFrom<String, String>(
                      source: optionsProvider2,
                      value: (i, v) => v,
                      label: (i, v) => v,
                      tooltip: (i, v) => v,
                    ),
                    wrapped: true,
                    textDirection: TextDirection.ltr,
                    alignment: WrapAlignment.spaceEvenly,
                    runSpacing: 8,
                  ),
                ),





                SmartSelect<String>.single(
                  modalValidation: (value) =>
                      value == null ? "select altleast one" : null,
                  value: valueNumber,
                  title: "Filme",
                  choiceItems: optionsNumber,
                  onChange: (state) => setState(() => valueNumber = state.value),
                  modalType: S2ModalType.popupDialog,
                ),


                SmartSelect<String>.multiple(
                  modalValidation: (value) => value == null ? "Alle" : null,
                  value: valueGenre,
                  title: "Genres",
                  choiceItems: optionsGenre,
                  onChange: (state) => setState(() => valueGenre = state.value),
                  modalType: S2ModalType.popupDialog,
                  choiceType: S2ChoiceType.chips,
                ),





                SmartSelect<String>.single(
                  modalValidation: (value) =>
                      value == null ? "select atleast one" : null,
                  value: numParticipants,
                  title: "Freunde",
                  choiceItems: optionsPatNumber,
                  onChange: (state) =>
                      setState(() => numParticipants = state.value),
                  modalType: S2ModalType.fullPage,

                ),
                SizedBox(height: 50,)

              ],
            ),
          ),
        ),
      ),
    );
  }
}
