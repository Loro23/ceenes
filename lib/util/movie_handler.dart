import 'package:ceenes_prototype/util/session.dart';

import 'api.dart';
import 'movie.dart';

class MovieHandler {
  static Future<List> getMovies(Session session) async {
    print("getmovies");
    List movies = [];
    double number = session.numMov / 20;

    for (int i = 0; i < number; i++)
      await tmdb.v3.discover
          .getMovies(
        page: i + 1,
        language: 'en',
        voteAverageGreaterThan: session.getVotes(),
        withGenres: session.finalGenres,
        //withRuntimeLessThan: 50,
      )
          .then((result) {
        movies = movies + result.values.toList()[1];
      });
    print("getmovies");

    return movies;
  }
}
