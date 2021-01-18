import 'dart:math';

class Session {
  int sessionId;
  int numPats;
  int releaseDateGte;
  int releaseDateSme;

  List<String> genres;

  List<String> provider;

  Session(String numPats, List<String> genres, List<String> provider,{int releaseDateGte, int releaseDateSme}) {
    // print("ins session:" + provider.toString());
    this.numPats = int.parse(numPats);
    this.genres = genres;
    this.releaseDateSme = releaseDateSme;
    this.releaseDateGte = releaseDateGte;

    

    this.provider = provider;
    var rng = new Random();
    this.sessionId = rng.nextInt(1000000);
  }
  String connectProvider(List<String> _provider) {
    //print("connect");
    String _finalProviders = "";
    for (int i = 0; i < _provider.length; i++) {
      if (_provider[i] == "0") {
        return "";
      }
      if (i == _provider.length - 1) {
        _finalProviders = _finalProviders + _provider[i];
      } else {
        _finalProviders = _finalProviders + _provider[i] + "|";
      }
    }
    //print("connected");
    //print(_finalGenres);

    return _finalProviders;
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

  Session.fromJson(Map<String, dynamic> json)
      : sessionId = json["sessionId"],
        numPats = json["numPats"],
        genres = json["genres"],
        provider = json["provider"];

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'numPats': numPats,
        'genres': genres,
        'provider': provider
      };
}
