import 'dart:convert';
import 'dart:math';

import 'package:ceenes_prototype/util/movie_handler.dart';
import 'package:ceenes_prototype/widgets/review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../util/api.dart';
import '../util/movie.dart';
import 'package:tmdb_api/tmdb_api.dart';

String movies;
int sessionId;

class Swipe_View extends StatefulWidget {
  Swipe_View(String _movies, int _sessionId) {
    movies = _movies;
    sessionId = _sessionId;
    //_movies is the json form of the movie map
  }
  @override
  _Swipe_ViewState createState() => _Swipe_ViewState();
}

class _Swipe_ViewState extends State<Swipe_View> {
  List movies_dec;
  List<String> movies_rating;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  uploadRanking(List<String> movies_rating) async {
    await firestore
        .collection("sessions")
        .document(sessionId.toString())
        .collection("votes")
        .document(Random().nextInt(1000).toString())
        .setData({"rating": movies_rating.toString()});
  }

  @override
  void initState() {
    movies_dec = jsonDecode(movies);
    print(movies_dec);
  }

  @override
  Widget build(BuildContext context) {
    CardController controller;
    return Container(
      color: Color.fromRGBO(228, 228, 228, 0.4),
      child: Stack(children: [
        TinderSwapCard(
          swipeUp: true,
          swipeDown: true,
          orientation: AmassOrientation.TOP,
          totalNum: movies_dec.length,
          stackNum: 5,
          swipeEdge: 4.0,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          minWidth: MediaQuery.of(context).size.width * 0.8,
          minHeight: MediaQuery.of(context).size.height * 0.8,
          cardBuilder: (context, index) => Card(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.all(5),
                    child: Text(movies_dec[index]["title"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ))),
                Container(
                    padding: const EdgeInsets.all(5),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          "http://image.tmdb.org/t/p/original/" +
                              movies_dec[index]["poster_path"],
                          height: 400,
                        ))),
                Text(
                    "Rating: " +
                        movies_dec[index]["vote_average"].toString() +
                        "/10",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                Container(
                    padding: const EdgeInsets.all(20),
                    child: Text(movies_dec[index]["overview"])),
              ],
            ),
          )),
          cardController: controller,
          swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
            /// Get swiping card's alignment
            if (align.x < 0) {
            } else if (align.x > 0) {}
          },
          swipeCompleteCallback:
              (CardSwipeOrientation orientation, int index) async {
            if (orientation == CardSwipeOrientation.LEFT) {
              setState(() {
                movies_rating.add("0");
              });
            } else if (orientation == CardSwipeOrientation.RIGHT) {
              setState(() {
                movies_rating.add("1");
              });
            }
            if (movies_dec.length - 1 == index) {
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
                          child: new Text("Ranking berechnen..."),
                        ),
                      ],
                    ),
                  );
                },
              );
              //TODO prüfen ob der code richtig ist
              await uploadRanking(movies_rating).whenComplete(() {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return Review();
                }));
              });
            }
          },
        ),
      ]),
    );
  }
}
