import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/admin/admin_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:smart_select/smart_select.dart';

GlobalKey key = new GlobalKey();


class Create_View extends StatefulWidget {
  @override
  _Create_ViewState createState() => _Create_ViewState();
}

class _Create_ViewState extends State<Create_View> {

  

  String valueNumber = "20";
  List<String> valueGenre =["0"];
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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Gruppe erstellen',style:TextStyle(fontSize: 30, fontWeight:FontWeight.bold)),
              SmartSelect<String>.single(
                 modalValidation:(value)=> value==null ?"select altleast one": null,
                 value: valueNumber,
                 title: "Filme",
                 choiceItems:optionsNumber,
                 onChange: (state) => setState(() => valueNumber = state.value),
                 modalType: S2ModalType.popupDialog,
              ),
              SmartSelect<String>.multiple(
                 modalValidation:(value)=> value==null ?"Alle": null,
                 value: valueGenre,
                 title: "Genres",
                 choiceItems:optionsGenre,
                 onChange: (state) => setState(() => valueGenre = state.value),
                 modalType: S2ModalType.popupDialog,
                 choiceType: S2ChoiceType.chips,
              ),
              SmartSelect<String>.single(
                 modalValidation:(value)=> value==null ?"select atleast one": null,
                 value: numParticipants,
                 title: "Freunde",
                 choiceItems:optionsPatNumber,
                 onChange: (state) => setState(() => numParticipants = state.value),
                 modalType: S2ModalType.popupDialog,
              ),
              
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder:(BuildContext context){return AdminLogin(int.parse(valueNumber),int.parse(numParticipants) , valueGenre);}));
                 
                },
                child: Text("Start")
              ),
            ],
          ),
        ),
      ),
    );
  }
}
