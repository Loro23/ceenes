import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:circular_reveal_animation/circular_reveal_animation.dart';

class ResultView extends StatefulWidget {
  @override
  _ResultViewState createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  bool _visible = false;
  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 0), () {
      setState(() {
        _visible = true;
      });
    });
    return Material(
        child: Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                "Euer Ergebnis:",
                style: TextStyle(fontSize: 40),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedOpacity(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        width: 200,
                        height: 400,
                      ),
                      Text(
                        "Musterfilm",
                        style: TextStyle(fontSize: 40),
                      ),
                      Text("Votes: 3 von 4"),
                      Text("Bewertung: 7 von 10"),
                      Text("mit Musterperson 1, Musterperson 2"),
                      Text("Regie: Musterperson 5"),
                      Text("Streambar bei: Netflix, Amazon Prime Video"),
                    ],
                  ),
                  opacity: _visible ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                ),
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: RaisedButton(
                  onPressed: () {},
                  color: Colors.grey[700],
                  child: Text("Zeig mir alles"),
                ),
              ))
        ],
      ),
    ));
  }
}

/*
class ResultView extends StatefulWidget {
  @override
  _ResultViewState createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  bool _visible = false;

  
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AnimatedOpacity(
              child: Container(
                color: Colors.white,
                width: 200,
                height: 200,
              ),
              opacity: _visible ? 1.0 : 0.0,
              duration: Duration(seconds: 2),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  _visible = true;
                });
              },
              color: Colors.blueGrey,
              child: Text("hallo"),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.grey[700],
                    height: 50,
                    child: Center(
                        child: Text(
                      "3",
                      style: TextStyle(fontSize: 30),
                    )),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.blueGrey[600],
                    height: 120,
                    child: Center(
                        child: Text(
                      "1",
                      style: TextStyle(fontSize: 30),
                    )),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.blueGrey[400],
                    height: 80,
                    child: Center(
                        child: Text(
                      "2",
                      style: TextStyle(fontSize: 30),
                    )),
                  ),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}


 */
