import 'package:ceenes_prototype/util/session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'create_view.dart';

Session b;

class AdminLogin extends StatefulWidget {
  AdminLogin(int numPats, int numMov, List<String> genres){
    b = new Session(numPats, numMov, genres);
  }


  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {

  _AdminLoginState(){
 
  }
  @override
  Widget build(BuildContext context) {
    return Material(
          child: Container(
        child: Column(
          children: [
            Text("Deine Gruppe wurde erstellt!"),
            Text("wenn ihr swipen wollt müsst ihr lediglich den Code auf der Find Group Seite angeben und ihr könnt swipen"),
            Text(b.sessionId.toString()),
            Text(b.genres.toString()),
          ],),
      ),
    );
  }
}