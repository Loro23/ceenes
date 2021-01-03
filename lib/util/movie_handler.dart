import 'dart:convert';

import 'package:ceenes_prototype/util/create_view_utils.dart';
import 'package:ceenes_prototype/util/session.dart';
import 'package:ceenes_prototype/widgets/admin/create_view.dart';
import 'dart:math';
import 'api.dart';
import 'movie.dart';
import 'package:http/http.dart' as http;

class MovieHandler {

  static String _createRequestMoviesByProvider(Session session, String providerId){
    print(session.connectGenres());
    String request = "https://api.themoviedb.org/3/discover/movie?api_key=" + apiKey
        + "&with_ott_providers=" + providerId
        + "&with_genres=" + session.connectGenres()
        + "&ott_region=DE"
    ;
    return request;
  }

  static Future<List> getMoviesNew(Session session) async{
    List moviesNeu = [];

    List moviesDetails = [];

    List<String> provider = getProviderIds(session.provider);
    print(provider);

    for (String prov in provider){ //converts the providers names into their ids
      final response = await http.get(_createRequestMoviesByProvider(session, prov));
      moviesNeu.addAll(jsonDecode(response.body)["results"]); //füge die filme der egsamtasuwahl für diese Session
    }

    List<int> usedIndex = [];
    while (moviesDetails.length < 15) {

      int index = Random().nextInt(moviesNeu.length);

      await tmdb.v3.movies.getDetails(moviesNeu[index]["id"],appendToResponse: "watch/providers", language: "de-DE").then((_result) {
        if (!usedIndex.contains(index)) {
          usedIndex.add(index);
          moviesDetails.add(_result);
          print(_result["title"]);
        }
      });
    }

    print(moviesDetails.length);
    return moviesDetails;
  }
}
