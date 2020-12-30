import 'dart:convert';
import 'dart:html';
import 'dart:math';

import 'package:ceenes_prototype/util/movie_handler.dart';
import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/details_view.dart';
import 'package:ceenes_prototype/widgets/review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../util/api.dart';
import '../util/movie.dart';
import 'package:tmdb_api/tmdb_api.dart';

GlobalKey key = GlobalKey();
String _movies;
int _sessionId;

class Swipe_View extends StatefulWidget {
  Swipe_View(String movies, int sessionId) {
    _movies = movies;
    _sessionId = sessionId;
    //_movies is the json form of the movie map
  }
  @override
  _Swipe_ViewState createState() => _Swipe_ViewState();
}

class _Swipe_ViewState extends State<Swipe_View> {
  List movies_dec;
  List<int> movies_rating = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  

  int counter = 0;
  CardController controller;

  String getGenres(int index) {
    String genres = "";
    for (Map genre in movies_dec[index]["genres"]){
      genres = genres + genre["name"] + ", ";
    }
    /*for (int genre in movies_dec[index]["genre_ids"]) {
      switch (genre) {
        case (28):
          genres = genres + "Action, ";
          break;
        case (16):
          genres = genres + "Animation, ";
          break;
        case (99):
          genres = genres + "Dokumentarfilm, ";
          break;
        case (18):
          genres = genres + "Drama, ";
          break;
        case (10751):
          genres = genres + "Familie, ";
          break;
        case (14):
          genres = genres + "Fantasy, ";
          break;
        case (36):
          genres = genres + "Historie, ";
          break;
        case (35):
          genres = genres + "Komödie, ";
          break;
        case (10752):
          genres = genres + "Kriegsfilm, ";
          break;
        case (80):
          genres = genres + "Krimi, ";
          break;
        case (9648):
          genres = genres + "Mystery, ";
          break;
        case (10749):
          genres = genres + "Liebesfilm, ";
          break;
        case (878):
          genres = genres + "Science Fiction, ";
          break;
        case (27):
          genres = genres + "Horror, ";
          break;
        case (10770):
          genres = genres + "TV-Film, ";
          break;
        case (53):
          genres = genres + "Thriller, ";
          break;
        case (37):
          genres = genres + "Western, ";
          break;
        case (12):
          genres = genres + "Abenteuer, ";
          break;
        case (10402):
          genres = genres + "Musik, ";
          break;
      }
    }*/
    if (genres == "") {
      return "keine Genres";
    }
    return genres.substring(0, genres.length - 2);
  }

  uploadRanking(List<int> movies_rating) async {
    await firestore
        .collection("sessions")
        .document(_sessionId.toString())
        .collection("votes")
        .document(Random().nextInt(1000).toString())
        .setData({"rating": json.encode(movies_rating)});
  }

  showDetails(context, Map moviedetails) async{
   
      showModalBottomSheet(context: context, builder: (BuildContext bc){
      return Details_view(moviedetails);
    });
    
  } 


  @override
  void initState() {
    movies_dec = jsonDecode(_movies);
    //print(movies_dec);
    controller = CardController();
  }

  @override
  Widget build(BuildContext context) {
    //print(session.sessionId.toString());

    //print(movies_dec);

    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        child: Container(
          constraints: BoxConstraints(maxWidth: 300),
          color: Color.fromRGBO(21, 21, 21, 1),
          child: Column(
            children: [
              Expanded(
                child: TinderSwapCard(
                  swipeUp: false,
                  swipeDown: false,
                  animDuration: 300,
                  orientation: AmassOrientation.TOP,
                  totalNum: movies_dec.length,
                  stackNum: 3,
                  swipeEdge: 4.0,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  minHeight: MediaQuery.of(context).size.height * 0.8,
                  cardBuilder: (context, index) => Card(
                      color: Color.fromRGBO(37, 37, 37, 1),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    "http://image.tmdb.org/t/p/w500/" +
                                        movies_dec[index]["poster_path"],
                                    height: 350,
                                  )),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 5,
                                          left: 20,
                                          right: 20,
                                          bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text(movies_dec[index]["title"],
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color.fromRGBO(
                                                238, 238, 238, 1),
                                          ))),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 20, top: 5, bottom: 5),
                                  child: IconButton(
                                    iconSize: 30,
                                    icon: Icon(Icons.info),
                                    tooltip: 'mehr Details',
                                    onPressed: () {showDetails(context, movies_dec[index]);},
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.only(
                                    left: 20, top: 5, bottom: 5, right: 20),
                                child: Text(
                                  movies_dec[index]["overview"],
                                  overflow: TextOverflow.visible,
                                  maxLines: 3,
                                  style: TextStyle(
                                    color: Color.fromRGBO(238, 238, 238, 1),
                                  ),
                                )),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      color: Color.fromRGBO(68, 68, 68, 1),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20, top: 5, bottom: 5),
                                    child: Text(getGenres(index),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromRGBO(238, 238, 238, 1),
                                        )),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Color.fromRGBO(68, 68, 68, 1),
                                        ),
                                        margin: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 5,
                                            bottom: 5),
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                movies_dec[index]
                                                            ["vote_average"]
                                                        .toString() +
                                                    "/10",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      238, 238, 238, 1),
                                                )),
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow[300],
                                              size: 15.0,
                                              semanticLabel:
                                                  'Text to announce in accessibility modes',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  cardController: controller,
                  swipeCompleteCallback:
                      (CardSwipeOrientation orientation, int index) async {
                    if (orientation == CardSwipeOrientation.LEFT) {
                      //print("left");
                      setState(() {
                        counter += 1;
                        movies_rating.add(0);
                      });
                      //print("counter: " + counter.toString());
                    } else if (orientation == CardSwipeOrientation.RIGHT) {
                      //print("right");

                      setState(() {
                        //print("in set state");
                        counter += 1;
                        movies_rating.add(1);
                      });
                      //print("counter: " + counter.toString());
                    }

                    if (counter == movies_dec.length) {
                      print("letzte karte" + index.toString());
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
                                  child: new Text("Upload Ergebnisse"),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                      await uploadRanking(movies_rating).whenComplete(() {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return Review(_sessionId, movies_dec);
                        }));
                      });
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: FloatingActionButton(
                      heroTag: 8,
                      backgroundColor: Colors.red,
                      onPressed: () {
                        controller.triggerLeft();
                      },
                      child: Icon(Icons.clear, color: Colors.white,),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: FloatingActionButton(
                      heroTag: 9,
                      backgroundColor: Colors.green,
                      onPressed: () {
                        controller.triggerRight();
                      },
                      child: Icon(Icons.favorite, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Text("Gruppe: " + _sessionId.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
