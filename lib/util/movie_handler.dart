import 'dart:convert';
import 'package:ceenes_prototype/util/create_view_utils.dart';
import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/admin/create_view.dart';
import 'dart:math';
import 'api.dart';
import 'movie.dart';
import 'package:http/http.dart' as http;

class MovieHandler {
  static String _createRequestMoviesByProvider(
      Session session, String providerId, String page) {
    // print(session.connectGenres());
    String request = "https://api.themoviedb.org/3/discover/movie?api_key=" +
        apiKey +
        "&with_ott_providers=" +
        providerId +
        "&with_genres=" +
        session.connectGenres() +
        "&ott_region=DE" +
        "&page=" +
        page +
        "&vote_average.gte=5";

    return request;
  }

  static Future<String> _getRandomPage(
      Session session, String providerId) async {
    String request = "https://api.themoviedb.org/3/discover/movie?api_key=" +
        apiKey +
        "&with_ott_providers=" +
        providerId +
        "&with_genres=" +
        session.connectGenres() +
        "&ott_region=DE" +
        "&vote_average.gte=5";

    final response = await http.get(request);
    int total_pages = jsonDecode(response.body)["total_pages"];
    print("total: " + jsonDecode(response.body)["total_pages"].toString());
    if (total_pages == 1) return "0";
    int random_page = 0;
    while (random_page == 0) {
      random_page = Random().nextInt(total_pages - 1);
    }
    print("random: " + random_page.toString());
    return random_page.toString();
  }

  static Future<List> getMoviesNew(Session session) async {
    List moviesNeu = [];

    List moviesDetails = [];

    List<String> provider = getProviderIds(session.provider);
    // print(provider);

    for (String prov in provider) {
      String random_page = await _getRandomPage(session, prov);
      if (random_page == "0") {
        print("mache garnichts");
        //mache garnichts
      } else {
        //converts the providers names into their ids
        final response = await http
            .get(_createRequestMoviesByProvider(session, prov, random_page));
        moviesNeu.addAll(jsonDecode(response.body)[
            "results"]); //füge die filme der egsamtasuwahl für diese Session

      }
    }

    if (moviesNeu.length == 0) {
      return [];
    }
    List<int> usedIndex = [];
    //details rausholen
    while (moviesDetails.length < 15) {
      int index = Random().nextInt(moviesNeu.length);

      await tmdb.v3.movies
          .getDetails(moviesNeu[index]["id"],
              appendToResponse: "watch/providers", language: "de-DE")
          .then((_result) {
        if (!usedIndex.contains(index)) {
          usedIndex.add(index);
          moviesDetails.add(_result);
        }
      });
    }

    return moviesDetails;
  }
}
