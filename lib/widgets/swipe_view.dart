import 'dart:convert';
import 'dart:html';
import 'dart:math';

import 'package:ceenes_prototype/util/colors.dart';
import 'package:ceenes_prototype/util/create_view_utils.dart';
import 'package:ceenes_prototype/widgets/details_view.dart';
import 'package:ceenes_prototype/widgets/review2.dart';
import 'package:ceenes_prototype/widgets/start_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../util/api.dart';

GlobalKey key = GlobalKey();
String _movies;
int _sessionId;

class Swipe_View extends StatefulWidget {
  Swipe_View(String movies, int sessionId, {this.analytics, this.observer}) {
    _movies = movies;
    _sessionId = sessionId;
  }
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _Swipe_ViewState createState() => _Swipe_ViewState(analytics, observer);
}

class _Swipe_ViewState extends State<Swipe_View> {
  _Swipe_ViewState(this.analytics, this.observer);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  List movies_dec;
  List<int> movies_rating = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  int counter = 0;
  CardController controller;

  int currentIndex;

  Color feedbackColor = Colors.transparent;

  Widget feedbackWidget = SizedBox();

  Future<void> _sendAnalyticsEvent(String what) async {
    if (!consent) return;
    await analytics.logEvent(
      name: what,
    );
  }

  String getGenres(int index) {
    String genreIds = "";
    for (int genreId in movies_dec[index]["genre_ids"]) {
      genreIds += genreId.toString();
    }
    // print(genreIds);
    return genreIds;
  }

  uploadRanking(List<int> movies_rating) async {
    await firestore
        .collection("sessions")
        .document(_sessionId.toString())
        .collection("votes")
        .document(Random().nextInt(1000).toString())
        .setData({"rating": json.encode(movies_rating)});
  }

  showDetails(context, Map moviedetails, String overviewEn) async {
    showBarModalBottomSheet(
        backgroundColor: backgroundcolor_dark,
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Wrap(
              children: [Details_view(moviedetails, overviewEn)],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _sendAnalyticsEvent("Swipe View - Init State");
    movies_dec = jsonDecode(_movies);
    //  print(movies_dec);
    controller = CardController();
    for (Map x in movies_dec) {
      if (x["overview"] == "") {
        tmdb.v3.movies.getDetails(x["id"], language: "en-US").then((_result) {
          if (_result == null) {
            x["overview"] = "";
          }
          x["overview"] = _result["overview"];
        });
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => new Dialog(
          child: Padding(
            padding: const EdgeInsets.only(top:20, left: 8, right: 8, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                new Text("So funktioniert's:",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                SizedBox(height: 10),
                new Text("Swipe nach rechts: Film gefällt dir",style: TextStyle(fontSize: 17),textAlign: TextAlign.center,),
                SizedBox(height: 10),
                new Text("Swipe nach links: Film gefällt dir nicht",style: TextStyle( fontSize: 17), textAlign: TextAlign.center,),
                SizedBox(height: 10),
                Center(
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width*0.8,
                    child: new FlatButton(
                      color: yellow_ceenes,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Text("Los geht's", style: TextStyle(color: Colors.black, fontSize: 18),),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

        ),
      );
    });
  }

  double getHeightPoster() {
    double height = MediaQuery.of(context).size.height;
    if (height <= 700) {
      return height * 0.49;
    }
    if (height > 700 && height < 850) {
      return height * 0.58;
    } else
      return height * 0.62;
  }

  double getMaxWidth() {
    double maxWidth;
    if (MediaQuery.of(context).size.width > 600) {
      maxWidth = 550;
      return maxWidth;
    }
    maxWidth = MediaQuery.of(context).size.width * 0.9;
    // print(maxWidth);
    return maxWidth;
  }

  double getMinWidth() {
    double minWidth;
    if (MediaQuery.of(context).size.width > 600) {
      minWidth = 500;
      return minWidth;
    }
    minWidth = MediaQuery.of(context).size.width * 0.8;
    //print(minWidth);
    return minWidth;
  }

  List<Widget> genresChips = [];

  List<Widget> getGenresChipsForMovie(int index) {
    genresChips = [];
    List<String> genres = getGenreStrings(movies_dec[index]["genre_ids"]);

    for (String genre in genres) {
      genresChips.add(Padding(
        padding: const EdgeInsets.only(left: 2, top: 2),
        child: Card(
          color: Colors.grey[800].withOpacity(0.6),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(genre),
          ),
        ),
      ));
    }
    // print(genresFinal);

    return genresChips;
  }

  String getGenresForMovie(int index) {
    List<String> genres = getGenreStrings(movies_dec[index]["genre_ids"]);
    //   print(genres);
    String genresFinal = "";
    for (String genre in genres) {
      // print(genre);
      genresFinal += genre + ", ";
    }
    // print(genresFinal);
    genresFinal = genresFinal.substring(0, genresFinal.length - 2);
    return genresFinal;
  }

  @override
  Widget build(BuildContext context) {
    //print(session.sessionId.toString());
    // print(MediaQuery.of(context).size);
    //print(movies_dec[0]);
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
                      child: Container(
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5, bottom: 20, left: 10, right: 10),
                                    child: FloatingActionButton(
                                      heroTag: 8,
                                      backgroundColor: Colors.grey[800],
                                      onPressed: () {
                                        controller.triggerLeft();
                                      },
                                      child: Container(
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                            shape: BoxShape.circle
                                        ),

                                        child: Icon(
                                          Icons.clear_rounded,
                                          color: Colors.grey[800],
                                          size: 32,

                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5, bottom: 20, left: 10, right: 10),
                                    child: FloatingActionButton(
                                      heroTag: 9,
                                      backgroundColor: Colors.grey[800],
                                      onPressed: () {
                                        controller.triggerRight();
                                      },
                                      child: Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                          color: primary_color,
                                          shape: BoxShape.circle
                                      ),

                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.grey[800],
                                        size: 27,

                                      ),
                                    ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: TinderSwapCard(
                                swipeUp: false,
                                swipeDown: false,
                                animDuration: 300,
                                orientation: AmassOrientation.TOP,
                                totalNum: movies_dec.length,
                                stackNum: 3,
                                swipeEdge: 4,
                                maxWidth: getMaxWidth(),
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.9,
                                minWidth: getMinWidth(),
                                minHeight:
                                    MediaQuery.of(context).size.height * 0.8,
                                cardBuilder: (context, index) {
                                  currentIndex = index;
                                  return Container(
                                    margin: EdgeInsets.only(top: 35, bottom: 40),
                                    decoration: BoxDecoration(
                                      boxShadow: [BoxShadow(color: Colors.black87, blurRadius: 17)]
                                    ),
                                    child: Stack(
                                      children: [
                                        Card(
                                          color: Colors.transparent,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            child: Container(

                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image:NetworkImage(
                                                      "http://image.tmdb.org/t/p/w500/" +
                                                          movies_dec[index]
                                                          ["poster_path"],
                                                    ),
                                                    fit: BoxFit.cover
                                                  )
                                                ),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Expanded(child: SizedBox(),
                                                      /*
                                                      child: Image.network(
                                                        "http://image.tmdb.org/t/p/w500/" +
                                                            movies_dec[index]
                                                                ["poster_path"],
                                                        height: getHeightPoster(),
                                                      ),
                                                      */
                                                    ),
                                                    //------------------------------------------------------------------
                                                    Container(

                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(

                                                          colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                                                          begin: Alignment.bottomCenter,
                                                          end: Alignment.topCenter,
                                                          stops: [0.7, 1]

                                                        )
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 70,
                                                          ),
                                                          Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Expanded(
                                                                child: Container(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 5,
                                                                        left: 20,
                                                                        bottom: 5),
                                                                    alignment: Alignment
                                                                        .centerLeft,
                                                                    child: RichText(
                                                                      overflow:
                                                                      TextOverflow.clip,
                                                                      text: TextSpan(
                                                                        text: movies_dec[
                                                                        index]
                                                                        ["title"] +
                                                                            " ",
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                          fontSize: 17,
                                                                          color: Color
                                                                              .fromRGBO(
                                                                              238,
                                                                              238,
                                                                              238,
                                                                              1),
                                                                        ),
                                                                        children: <
                                                                            TextSpan>[
                                                                          TextSpan(
                                                                              text: "(" +
                                                                                  movies_dec[index]
                                                                                  [
                                                                                  "release_date"]
                                                                                      .toString()
                                                                                      .substring(
                                                                                      0,
                                                                                      4) +
                                                                                  ")",
                                                                              style: TextStyle(
                                                                                  color: Color.fromRGBO(
                                                                                      202,
                                                                                      202,
                                                                                      202,
                                                                                      0.9)))
                                                                        ],
                                                                      ),
                                                                    )),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Container(
                                                                margin:
                                                                const EdgeInsets.only(
                                                                    right: 20),
                                                                child: Icon(Icons.info),
                                                              ),
                                                            ],
                                                          ),


                                                          Container(
                                                              alignment: Alignment.topLeft,
                                                              padding:
                                                              const EdgeInsets.only(
                                                                  left: 20,
                                                                  top: 5,
                                                                  bottom: 5,
                                                                  right: 20),
                                                              child: Text(
                                                                movies_dec[index]
                                                                ["overview"],
                                                                overflow:
                                                                TextOverflow.ellipsis,
                                                                maxLines: 3,
                                                                style: TextStyle(
                                                                  color: Color.fromRGBO(
                                                                      238, 238, 238, 1),
                                                                ),
                                                              )),
                                                          Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Column(
                                                              mainAxisSize:
                                                              MainAxisSize.min,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            left: 10,
                                                                            bottom: 8),
                                                                        child: Wrap(
                                                                          children:
                                                                          getGenresChipsForMovie(
                                                                              index),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top: 5.5,
                                                                          right: 20),
                                                                      child: Container(
                                                                        decoration:
                                                                        BoxDecoration(
                                                                          borderRadius:
                                                                          BorderRadius
                                                                              .all(Radius
                                                                              .circular(
                                                                              5)),
                                                                          color: Colors.grey[800].withOpacity(0.7)
                                                                        ),
                                                                        child: Row(
                                                                          mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                          children: [
                                                                            Padding(
                                                                              padding:
                                                                              const EdgeInsets
                                                                                  .all(8),
                                                                              child: Text(
                                                                                  movies_dec[index]["vote_average"]
                                                                                      .toString() +
                                                                                      "/10",
                                                                                  style:
                                                                                  TextStyle(
                                                                                    fontWeight:
                                                                                    FontWeight.bold,
                                                                                    color: Color.fromRGBO(
                                                                                        238,
                                                                                        238,
                                                                                        238,
                                                                                        1),
                                                                                  )),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets
                                                                                  .only(
                                                                                  right: 8),
                                                                              child: Icon(
                                                                                Icons.star,
                                                                                color: Colors
                                                                                    .yellow,
                                                                                size: 20.0,
                                                                                semanticLabel:
                                                                                'Stern',
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    )


                                                  ],
                                                ),
                                              ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                child: Center(
                                                    child: CircularProgressIndicator(
                                                        valueColor:
                                                            new AlwaysStoppedAnimation<
                                                                    Color>(
                                                                blue_ceenes))));
                                            _sendAnalyticsEvent(
                                                "Swipe View - More Details Button");
                                            Map movieDetails =
                                                await tmdb.v3.movies.getDetails(
                                                    movies_dec[index]["id"],
                                                    appendToResponse:
                                                        "watch/providers",
                                                    language: "de-DE");

                                            var rep = await http.get(
                                                "https://api.themoviedb.org/3/movie/" +
                                                    movies_dec[index]['id']
                                                        .toString() +
                                                    "?api_key=" +
                                                    apiKey +
                                                    "&language=en-US");

                                            String overview =
                                                jsonDecode(rep.body)["overview"];
                                            Navigator.pop(context);
                                            showDetails(
                                                context, movieDetails, overview);
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                },
                                cardController: controller,
                                swipeUpdateCallback:
                                    (DragUpdateDetails details, Alignment align) {
                                  if (align.x < -0.2) {
                                    setState(() {
                                      feedbackWidget = Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 50, left: 15),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                            child: Container(
                                              color: Colors.grey[800],
                                              child: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: Icon(
                                                  Icons.clear,
                                                  color: Colors.red,
                                                  size: 50,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  } else if (align.x > 0.2) {
                                    //Card is RIGHT swiping
                                    setState(() {
                                      feedbackWidget = Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 50, right: 15),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                            child: Container(
                                              color: Colors.grey[800],
                                              child: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: Icon(Icons.favorite,
                                                    color: Colors.yellow,
                                                    size: 50),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  } else {
                                    setState(() {
                                      feedbackWidget = SizedBox();
                                    });
                                  }
                                },
                                swipeCompleteCallback:
                                    (CardSwipeOrientation orientation,
                                        int index) async {
                                  if (orientation == CardSwipeOrientation.LEFT) {
                                    _sendAnalyticsEvent(
                                        "Swipe View - Swipe left");
                                    setState(() {
                                      counter += 1;
                                      movies_rating.add(0);
                                    });
                                  } else if (orientation ==
                                      CardSwipeOrientation.RIGHT) {
                                    _sendAnalyticsEvent(
                                        "Swipe View - Swipe right");
                                    setState(() {
                                      counter += 1;
                                      movies_rating.add(1);
                                    });
                                  }

                                  setState(() {
                                    feedbackWidget = SizedBox();
                                  });

                                  if (counter == movies_dec.length) {
                                    //  print("letzte karte" + index.toString());
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: new Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child:
                                                    new CircularProgressIndicator(
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<
                                                          Color>(blue_ceenes),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: new Text(
                                                  "Laden...",
                                                  style: TextStyle(fontSize: 25),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                    await uploadRanking(movies_rating)
                                        .whenComplete(() {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return Review2(_sessionId, movies_dec,
                                            analytics: this.analytics,
                                            observer: this.observer);
                                      }));
                                    });
                                  }
                                },
                              ),
                            ),
                            feedbackWidget
                          ],
                        ),
                      ),
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
                              _sendAnalyticsEvent("Swipe View - Close Button");
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
                                            onPressed: () {
                                              _sendAnalyticsEvent(
                                                  "Swipe View - Close Button - bestätigt");
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          StartView(
                                                            firstCall: false,
                                                          )),
                                                  (Route<dynamic> route) =>
                                                      false);
                                            },
                                            color: primary_color,
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
                                            onPressed: () {
                                              _sendAnalyticsEvent(
                                                  "Swipe View - Close Button - abgebrochen");
                                              Navigator.pop(c, false);
                                            },
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
