import 'dart:math';

class Session {
  int sessionId;
  int numPats;
  int numMov;
  String runtime;
  String votes;
  List<String> genres;
  String finalGenres;

  int getRuntime() {
    print("getRuntime");

    if (this.runtime == "Egal") {
      return 1000000;
    }
    print("getRuntime");

    return int.parse(this.runtime);
  }

  int getVotes() {
    print("getVotes");

    if (this.votes == "7+") {
      return 7;
    }
    print("getVotes");

    return int.parse(this.votes);
  }

  Session(int numPats, int numMov, List<String> genres, String runtime,
      String votes) {
    this.numPats = numPats;
    this.numMov = numMov;
    this.genres = genres;
    this.runtime = runtime;
    this.votes = votes;
    var rng = new Random();
    this.sessionId = rng.nextInt(1000000);
    this.finalGenres = this.connect(genres);
  }

  String connect(List<String> genres) {
    print("connect");
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
    print("connect");

    return _finalGenres;
  }
}
