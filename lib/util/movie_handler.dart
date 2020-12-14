import 'package:ceenes_prototype/util/session.dart';

import 'api.dart';
import 'movie.dart';

class MovieHandler {
  static List<Movie> movies = [];


  static Future<List<Movie>> getMovies(Session session) async {
    Map result;


      result = await tmdb.v3.discover.getMovies(
        page: 1,
        language: 'de',
        voteAverageGreaterThan: 4,

      );

    
    Map resulte = await tmdb.v3.movies.getTopRated();
    //print(resulte);



    List resulties = result.values.toList();

    for (int i = 0; i < 20; i++) {
      int id = resulties[1][i]['id'];
      String title = resulties[1][i]['title'];
      String original_title = resulties[1][i]['original_title'];
      String overview = resulties[1][i]['overview'];
      List genre_ids = resulties[1][i]['genre_ids'];
      String poster_path = resulties[1][i]['poster_path'];
      double popularity = resulties[1][i]['popularity'];
      double vote_average = resulties[1][i]['vote_average'];
      double vote_count = resulties[1][i]['vote_count'];

      Movie movie = Movie(id, title, original_title, overview, genre_ids,
          poster_path, popularity, vote_average, vote_count);
      movies.add(movie);
    }
    return movies;
  }
}
