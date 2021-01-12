import 'dart:convert';
import 'package:ceenes_prototype/util/create_view_utils.dart';
import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/admin/create_view.dart';
import 'dart:math';
import 'api.dart';
import 'package:http/http.dart' as http;

class MovieHandler {
  static String _createRequestMoviesAllProvider(
      Session session, String providerString, String page) {
    // print(session.connectGenres());
    String request = "https://api.themoviedb.org/3/discover/movie?api_key=" +
        apiKey +
        "&with_ott_providers=" +
        providerString +
        "&with_genres=" +
        session.connectGenres() +
        "&ott_region=DE" +
        "&page=" +
        page +
        "&vote_average.gte=4" +
        "&vote_count.gte=1000" +
        "&include_adult=false";

    return request;
  }

  static Future<String> _getRandomPage2(Session session) async {
    List<String> providerIds = getProviderIds(session.provider);
    String providerIdsString = session.connectProvider(providerIds);

    String request = "https://api.themoviedb.org/3/discover/movie?api_key=" +
        apiKey +
        "&with_ott_providers=" +
        providerIdsString +
        "&with_genres=" +
        session.connectGenres() +
        "&ott_region=DE" +
        "&vote_average.gte=4" +
        "&vote_count.gte=1000" +
        "&include_adult=false";

    final response = await http.get(request);
    print(response.body);
    int total_pages = jsonDecode(response.body)["total_pages"];
    int total_results = jsonDecode(response.body)["total_results"];
    print("total results: " + total_results.toString());
    print("total: " + jsonDecode(response.body)["total_pages"].toString());
    //if (total_pages <= 1) return "0";
    if (total_results < 15) return "0";

    int random_page = 0;
    while (random_page == 0) {
      random_page = Random().nextInt(total_pages + 1);
    }
    print("random: " + random_page.toString());
    return random_page.toString();
  }

  static Future<List> getMoviesNew2(Session session) async {
    List moviesNeu = [];

    List moviesDetails = [];

    List<String> providerIds = getProviderIds(session.provider);
    String providerIdsString = session.connectProvider(providerIds);

    String random_page = await _getRandomPage2(session);
    if (random_page == "0") {
      print("mache garnichts");
      //mache garnichts
    } else {
      final response = await http.get(_createRequestMoviesAllProvider(
          session, providerIdsString, random_page));
      moviesNeu.addAll(jsonDecode(response.body)[
          "results"]); //füge die filme der egsamtasuwahl für diese Session
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
          print(_result["title"]);

          if (_result["poster_path"] != null &&
              _result["overview"] != null &&
              _result["title"] != null &&
              _result["genres"] != null &&
              _result["vote_average"] != null &&
              _result["release_date"] != null) {
            moviesDetails.add(_result);
          }
        }
      });
    }

    return moviesDetails;
  }
}

/*
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
        "&vote_average.gte=4" +
        "&vote_count.gte=1000" +
        "&include_adult=false";

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
        "&vote_average.gte=4" +
        "&vote_count.gte=1000" +
        "&include_adult=false";

    final response = await http.get(request);
    int total_pages = jsonDecode(response.body)["total_pages"];
    print("total: " + jsonDecode(response.body)["total_pages"].toString());
    if (total_pages <= 1) return "0";
    int random_page = 0;
    while (random_page == 0) {
      random_page = Random().nextInt(total_pages);
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
          print(_result["title"]);

          if (_result["poster_path"] != null &&
              _result["overview"] != null &&
              _result["title"] != null &&
              _result["genres"] != null &&
              _result["vote_average"] != null &&
              _result["release_date"] != null) {
            print(1);
            moviesDetails.add(_result);
          }
        }
      });
    }

    return moviesDetails;
  }
  */
