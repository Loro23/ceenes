import 'dart:core';

class Movie {
  var id;
  var title;
  var original_title;
  var rating;
  var overview;
  var genre_ids;
  var popularity;
  var poster_path;
  var vote_average;
  var vote_count;

  Movie(
      int id,
      String title,
      String original_title,
      String overview,
      List genre_ids,
      String poster_path,
      double popularity,
      double vote_average,
      double vote_count) {
    this.id = id;
    this.title = title;
    this.original_title = original_title;
    this.overview = overview;
    this.genre_ids = genre_ids;
    this.poster_path = poster_path;
    this.popularity = popularity;
    this.vote_average = vote_average;
    this.vote_count = vote_count;
  }
}
