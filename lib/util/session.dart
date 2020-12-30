import 'dart:math';

class Session {
  int sessionId;
  int numPats;

  List<String> genres;
  String finalGenres;
  List<String> provider;

  Session(List<String> genres, List<String> provider) {
    this.genres = genres;

    this.provider = provider;
    var rng = new Random();
    this.sessionId = rng.nextInt(1000000);
  }

  String connectGenres() {
    //print("connect");
    String _finalGenres = "";
    for (int i = 0; i < this.genres.length; i++) {
      if (this.genres[i] == "0") {
        return _finalGenres = "";
      }
      if (i == this.genres.length - 1) {
        _finalGenres = _finalGenres + this.genres[i];
      } else {
        _finalGenres = _finalGenres + this.genres[i] + "|";
      }
    }
    //print("connected");
    //print(_finalGenres);

    return _finalGenres;
  }
}
