import 'package:ceenes_prototype/util/session.dart';

import 'api.dart';
import 'movie.dart';

class MovieHandler {
  static Future<List> getMovies(Session session) async {
    List movies = [];

    await tmdb.v3.discover
        .getMovies(
      page: 1,
      language: 'en',
      voteAverageGreaterThan: 5,
    )
        .then((result) {
      movies = result.values.toList()[1];
    });

    return movies;
  }
}
