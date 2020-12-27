import 'package:ceenes_prototype/util/session.dart';

import 'api.dart';
import 'movie.dart';

class MovieHandler {
  static Future<List> getMovies(Session session) async {
    List movies = [];
    List moviesWithProviders = [];
    int v = 1;
    //print(session.provider);
    bool noProvider = false;

    while (moviesWithProviders.length < 20) {
      await tmdb.v3.discover
          .getMovies(
        page: v,
        language: 'en',
        voteAverageGreaterThan: session.getVotes(),
        withGenres: session.connectGenres(),
      )
          .then((result) async {
        movies = result.values.toList()[1];
        if (session.provider.isNotEmpty) {
          for (int i = 0; i < movies.length; i++) {
            await tmdb.v3.movies
                .getDetails(movies[i]["id"],
                    appendToResponse: "watch/providers", language: "de-DE")
                .then((result) {
              try {
                List _res =
                    result["watch/providers"]["results"]["DE"]["flatrate"];
                if (_res != null) {
                  List<String> providersForThisMovie = [];
                  for (int j = 0; j < _res.length; j++) {
                    providersForThisMovie.add(_res[j]["provider_name"]);
                  }

                  for (String provider in providersForThisMovie) {
                    if (session.provider.contains(provider)) {
                      moviesWithProviders.add(movies[i]);
                      break;
                    }
                  }
                }
              } catch (e) {}
            });
          }
        }
      }).whenComplete(() {
        v += 1;
      });
      if (session.provider.isEmpty) {
        noProvider = true;
        break;
      }
    }

    if (noProvider) {
      return movies;
    }
    return moviesWithProviders;
  }
}
