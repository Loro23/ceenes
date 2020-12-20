import 'dart:math';

class Session {
  int sessionId;
  int numPats;
  int numMov;
  List<String> genres;
  String finalGenres;

  Session(int numPats, int numMov, List<String> genres) {
    this.numPats = numPats;
    this.numMov = numMov;
    this.genres = genres;
    var rng = new Random();
    this.sessionId = rng.nextInt(1000000);
    this.finalGenres = this.connect(genres);
  }

  String connect(List<String> genres) {
    String _finalGenres = "";
    for (int i = 0; i < genres.length; i++) {
      if (genres[i] == "0") {
        return _finalGenres = "";
      }
      if (i == genres.length - 1) {
        _finalGenres = _finalGenres + genres[i];
      } else {
        _finalGenres = _finalGenres + genres[i] + "|";
      }
    }
    return _finalGenres;
  }
}
