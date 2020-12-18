import 'dart:core';

class Movie {
  String adult;
  String genres;
  String id;
  String original_language;
  String original_title;
  String overview;
  String popularity;
  String poster_path;
  String release_date;
  String title;
  String vote_average;
  String vote_count;

  String homepage = null;
  String imdb_id = null;
  String production_companies = null;
  String runtime = null;
  String spoken_languages = null;

  Movie(
    this.adult,
    this.genres,
    this.id,
    this.original_language,
    this.original_title,
    this.overview,
    this.popularity,
    this.poster_path,
    this.release_date,
    this.title,
    this.vote_average,
    this.vote_count, [
    this.homepage,
    this.imdb_id,
    this.production_companies,
    this.runtime,
    this.spoken_languages,
  ]);
}
