import 'package:ceenes_prototype/util/session.dart';
import 'dart:math';
import 'api.dart';
import 'movie.dart';

class MovieHandler {
  static Future<List> getMovies(Session session) async {
    List movies = [];
    List moviesWithProviders = [];
    int v = 1;
    //print(session.provider);
    bool noProvider = false;

    List<int> pagesused = [];

    int getrandomnumbers() {
      while (true) {
        int x = Random().nextInt(150);
        if (!pagesused.contains(x)) {
          pagesused.add(x);
          return x;
        }
      }
    }

    while (moviesWithProviders.length < 15) {
      await tmdb.v3.discover
          .getMovies(
        page: getrandomnumbers(),
        language: 'de',
        withGenres: session.connectGenres(),
        includeAdult: false,
      )
          .then((result) async {
        List tempMovies = result.values.toList()[1];
        for( Map x in tempMovies ){
          await tmdb.v3.movies.getDetails(x["id"]).then((result){
            movies.add(result);
          });
        }
        if (session.provider.isNotEmpty) {
          for (int i = 0; i < movies.length; i++) {
            if (moviesWithProviders.length == 15) {
              return moviesWithProviders;
            }
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
                      moviesWithProviders.add(result);
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
