import 'package:ceenes_prototype/util/movie_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:flutter/material.dart';
import '../util/api.dart';
import '../util/movie.dart';
import 'package:tmdb_api/tmdb_api.dart';

class Swipe_View extends StatefulWidget {
  @override
  _Swipe_ViewState createState() => _Swipe_ViewState();
}

class _Swipe_ViewState extends State<Swipe_View> {
  Future<List<Movie>> movies;

  @override
  void initState() {
    this.movies = MovieHandler.getTrendingMovies();
  }

  @override
  Widget build(BuildContext context) {
    CardController controller;
    return Container(
      color: Colors.green,
      child: TinderSwapCard(
        swipeUp: true,
        swipeDown: true,
        orientation: AmassOrientation.TOP,
        totalNum: 20,
        stackNum: 5,
        swipeEdge: 4.0,
        maxWidth: MediaQuery.of(context).size.width * 0.9,
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        minWidth: MediaQuery.of(context).size.width * 0.8,
        minHeight: MediaQuery.of(context).size.height * 0.8,
        cardBuilder: (context, index) => Card(
            child: FutureBuilder(
          future: movies,
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            Movie movie = snapshot.data[index];
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text(movie.title),
                  Image.network(
                    "http://image.tmdb.org/t/p/original/" + movie.poster_path,
                    height: 500,
                  ),
                  Text(movie.title),
                  Text(movie.overview),
                  Text(movie.vote_average.toString())
                ],
              ),
            );
          },
        )),
        cardController: controller,
        swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
          /// Get swiping card's alignment
          if (align.x < 0) {
            //Card is LEFT swiping
          } else if (align.x > 0) {
            //Card is RIGHT swiping
          }
        },
        swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
          /// Get orientation & index of swiped card!
        },
      ),
    );
  }
}
