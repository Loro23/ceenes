import 'dart:convert';
import 'dart:html';
import 'dart:math';

import 'package:ceenes_prototype/util/colors.dart';
import 'package:ceenes_prototype/util/movie_handler.dart';
import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/details_view.dart';
import 'package:ceenes_prototype/widgets/review.dart';
import 'package:ceenes_prototype/widgets/start_view.dart';
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

  int currentIndex;

  String getGenres(int index) {
    String genres = "";
    for (Map genre in movies_dec[index]["genres"]) {
      genres = genres + genre["name"] + ", ";
    }
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

  showDetails(context, Map moviedetails) async {
    showModalBottomSheet(
      backgroundColor: backgroundcolor_dark,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Wrap(children: [Details_view(moviedetails)]);
        });
  }

  @override
  void initState() {

    movies_dec = jsonDecode(_movies);
    //print(movies_dec);
    controller = CardController();
    for (Map x in movies_dec){
      if(x["overview"]== ""){
        tmdb.v3.movies.getDetails(x["id"],language: "en-US").then((_result){
          x["overview"] = _result["overview"];
        });
      }
    }
  }

  double getHeightPoster(){
    return MediaQuery.of(context).size.height*0.535;
  }

  double getMaxWidth(){
    print("hier");
    double maxWidth;
    if (MediaQuery.of(context).size.width > 600){
      maxWidth= 550;
      return maxWidth;
    }
    maxWidth=  MediaQuery.of(context).size.width *0.9;
    print(maxWidth);
    return maxWidth;
  }
  double getMinWidth(){
    double minWidth;
    if (MediaQuery.of(context).size.width > 600){
      minWidth = 500;
      return minWidth;
    }
    minWidth =  MediaQuery.of(context).size.width *0.8;
    print(minWidth);
    return minWidth;
  }
  @override
  Widget build(BuildContext context) {
    //print(session.sessionId.toString());
    print(MediaQuery.of(context).size);
    //print(movies_dec);
    return Material(
      color: backgroundcolor_dark,
      child: WillPopScope(
        onWillPop: () async => false,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TinderSwapCard(
                          allowVerticalMovement: true,
                          swipeUp: false,
                          swipeDown: false,
                          animDuration: 300,
                          orientation: AmassOrientation.TOP,
                          totalNum: movies_dec.length,
                          stackNum: 3,
                          swipeEdge: 4,
                          maxWidth: getMaxWidth(),
                          maxHeight: MediaQuery.of(context).size.height * 0.9,
                          minWidth: getMinWidth(),
                          minHeight: MediaQuery.of(context).size.height * 0.8,
                          cardBuilder: (context, index) {
                            currentIndex = index;
                            return Card(
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
                                            height: getHeightPoster(),
                                          ),
                                        ),
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
                                                child: Text(
                                                    movies_dec[index]["title"],
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Color.fromRGBO(
                                                          238, 238, 238, 1),
                                                    ))),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 20, top: 5, bottom: 5),
                                            child: IconButton(
                                              iconSize: 30,
                                              icon: Icon(Icons.info),
                                              tooltip: 'mehr Details',
                                              onPressed: () {
                                                showDetails(
                                                    context, movies_dec[index]);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                          alignment: Alignment.topLeft,
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              top: 5,
                                              bottom: 5,
                                              right: 20),
                                          child: Text(
                                            movies_dec[index]["overview"],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(238, 238, 238, 1),
                                            ),
                                          )),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color:
                                                    Color.fromRGBO(68, 68, 68, 1),
                                              ),
                                              padding: const EdgeInsets.all(10),
                                              margin: const EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Text(getGenres(index),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromRGBO(
                                                        238, 238, 238, 1),
                                                  )),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color:
                                                    Color.fromRGBO(68, 68, 68, 1),
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
                                      ),
                                    ],
                                  ),
                                ));
                          },
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
                                          child: new CircularProgressIndicator(
                                            valueColor:
                                            new AlwaysStoppedAnimation<
                                                Color>(blue_ceenes),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: new Text("Laden...",                  style: TextStyle(fontSize: 25),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                              await uploadRanking(movies_rating).whenComplete(() {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return Review(_sessionId, movies_dec);
                                }));
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 5, bottom: 20, left: 10, right: 10),
                          child: FloatingActionButton(
                            heroTag: 8,
                            backgroundColor: Color.fromRGBO(92, 92, 92, 1),
                            onPressed: () {
                              controller.triggerLeft();
                            },
                            child: Icon(
                              Icons.clear,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 5, bottom: 20, left: 10, right: 10),
                          child: FloatingActionButton(
                            heroTag: 9,
                            backgroundColor: Color.fromRGBO(92, 92, 92, 1),
                            onPressed: () {
                              controller.triggerRight();
                            },
                            child: Icon(Icons.favorite, color: Colors.yellow),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //Stack für header
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent
                    ])),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (c) => AlertDialog(
                                        //title: Text('Warning'),
                                        content: Text(
                                            'Willst du wirklich abbrechen? Deine bisherigen Entscheidungen gehen verloren'),
                                        actions: [
                                          FlatButton(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Ja, abbrechen',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            StartView()),
                                                    (Route<dynamic> route) =>
                                                        false),
                                            color: Colors.amberAccent,
                                          ),
                                          FlatButton(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Zurück',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(c, false),
                                            color: Colors.black54,
                                          ),
                                        ],
                                      ));
                            },
                            splashRadius: 20,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Color.fromRGBO(68, 68, 68, 1)
                                  .withOpacity(0.5),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  _sessionId.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 8, left: 8, bottom: 8, right: 12),
                        child: Image.asset(
                          "assets/ceenes_logo_yellow4x.png",
                          height: 40,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
