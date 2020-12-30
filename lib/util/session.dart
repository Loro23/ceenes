import 'dart:math';

class Session {
  int sessionId;
  int numPats;
  int numMov;
  String runtime;
  String votes;
  List<String> genres;
  String finalGenres;
  List<String> provider;

  Session(List<String> genres, String runtime, String votes,
      List<String> provider) {
    this.genres = genres;
    this.runtime = runtime;
    this.votes = votes;
    this.provider = provider;
    var rng = new Random();
    this.sessionId = rng.nextInt(1000000);
  }

  int getRuntime() {
    print("getRuntime");

    if (this.runtime == "Egal") {
      return 1000000;
    }
    print("getRuntime");

    return int.parse(this.runtime);
  }

  int getVotes() {
    if (this.votes == "7+") {
      return 7;
    }

    return int.parse(this.votes);
  }

  String getProvider() {
    return null;
    //TODO provider austesten
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
