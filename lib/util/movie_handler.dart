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
        "&with_genres=" +
        session.connectGenres() +
        "&page=" +
        page +
        "&vote_average.gte=4" +
        "&vote_count.gte=160" +
        "&include_adult=false" +
        "&language=de-DE" +
        "&with_watch_providers=" +
        providerString +
        "&watch_region=DE"+
        "&primary_release_date.lte=" + session.releaseDateSme.toString()+"-01-01"+
        "&primary_release_date.Gte=" + session.releaseDateSme.toString()+"-01-01";
    // print(request);

    return request;
  }

  static Future<int> _getTotalPages(Session session) async {
    List<String> providerIds = getProviderIds(session.provider);
    String providerIdsString = session.connectProvider(providerIds);
    // print(session.genres);

    String request = "https://api.themoviedb.org/3/discover/movie?api_key=" +
        apiKey +
        "&with_watch_providers=" +
        providerIdsString +
        "&with_genres=" +
        session.connectGenres() +
        "&watch_region=DE" +
        "&vote_average.gte=4" +
        "&vote_count.gte=160" +
        "&include_adult=false" +
        "&language=de-DE" +
        "&primary_release_date.lte=" + session.releaseDateSme.toString()+"-01-01"+
        "&primary_release_date.Gte=" + session.releaseDateSme.toString()+"-01-01";

    // print(request);
    final response = await http.get(request);
    // print(response.body);
    int total_pages = jsonDecode(response.body)["total_pages"];
    int total_results = jsonDecode(response.body)["total_results"];
    // print("total results: " + total_results.toString());
    // print("total pages: " + total_pages.toString());
    if (total_results < 15) return 0;
    return total_pages;
  }

  //return a random page greater 0 and smaller
  static getRandomPage(int totalPages) {
    int randomPage = 0;

    while (randomPage == 0) {
      randomPage = Random().nextInt(totalPages);
    }
    return randomPage;
  }

  static Future<List> getMoviesNew2(Session session) async {
    List moviesNeu = [];

    List<String> providerIds = getProviderIds(session.provider);
    String providerIdsString = session.connectProvider(providerIds);

    int totalPages = await _getTotalPages(session);
    int randomPage = 0;
    if (totalPages <= 1) {
      // print("mache garnichts");
      return [];
    } else {
      randomPage = getRandomPage(totalPages);
      //print("random page: " +randomPage.toString());
      final response = await http.get(_createRequestMoviesAllProvider(
          session, providerIdsString, randomPage.toString()));
      moviesNeu.addAll(jsonDecode(response.body)["results"]);
    }
    moviesNeu.shuffle();

    //print("moviesNeu length: " + moviesNeu.length.toString());

    List moviesResults = [];

    for (dynamic movie in moviesNeu) {
      if (movie["poster_path"] != null &&
          movie["overview"] != null &&
          movie["title"] != null &&
          movie["genre_ids"] != null &&
          movie["vote_average"] != null &&
          movie["release_date"] != null) {
        // print(movie["name"]);
        moviesResults.add(movie);
      }
    }
    // print("results length: " + moviesResults.length.toString());
    if (moviesResults.length <= 20) return moviesResults;

    return moviesResults.sublist(0, 15).toList();
  }
}
