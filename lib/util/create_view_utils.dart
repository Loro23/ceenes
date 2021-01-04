List<String> optionsGenre2 = [
  "Action",
  "Animation",
  "Dokumentarfilm",
  "Drama",
  "Familie",
  "Fantasy",
  "Historie",
  "Komödie",
  "Kriegsfilm",
  "Krimi",
  "Musik",
  "Mystery",
  "Liebesfilm",
  "Science Fiction",
  "Horror",
  "TV-Film",
  "Thriller",
  "Western",
  "Abenteuer"
];

List<String> optionsProvider2 = [
  'Netflix',
  "Amazon Prime Video",
  "Joyn Plus",
  "Disney Plus",
  "Sky Ticket",
  "Sky Go"
];

/*
provider ids
https://api.themoviedb.org/3/discover/movie?api_key=###&with_ott_providers=8&ott_region=CA
*/

List<String> optionsPart = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];

List<String> getProviderIds(List<String> provider) {
  print("in : " + provider.toString());
  List<String> providerIds = [];
  for (String prov in provider) {
    switch (prov) {
      case ("Netflix"):
        providerIds.add("8");
        break;
      case ("Amazon Prime Video"):
        providerIds.add("9");
        break;
      case ("Sky Ticket"):
        providerIds.add("30");
        break;
      case ("Sky Go"):
        providerIds.add("29");
        break;
      case ("Joyn Plus"):
        providerIds.add("421");
        break;
      case ("Disney Plus"):
        providerIds.add("337");
    }
  }
  return providerIds;
}

List<String> getGenreIds(List<String> genres) {
  List<String> genreIds = [];
  for (String genre in genres) {
    switch (genre) {
      case ("Action"):
        genreIds.add("28");
        break;
      case ("Animation"):
        genreIds.add("16");
        break;
      case ("Dokumentarfilm"):
        genreIds.add("99");
        break;
      case ("Drama"):
        genreIds.add("18");
        break;
      case ("Familie"):
        genreIds.add("10751");
        break;
      case ("Fantasy"):
        genreIds.add("14");
        break;
      case ("Historie"):
        genreIds.add("36");
        break;
      case ("Komödie"):
        genreIds.add("35");
        break;
      case ("Kriegsfilm"):
        genreIds.add("10752");
        break;
      case ("Krimi"):
        genreIds.add("80");
        break;
      case ("Mystery"):
        genreIds.add("9648");
        break;
      case ("Liebesfilm"):
        genreIds.add("10749");
        break;
      case ("Science Fiction"):
        genreIds.add("878");
        break;
      case ("Horror"):
        genreIds.add("27");
        break;
      case ("TV-Film"):
        genreIds.add("10770");
        break;
      case ("Thriller"):
        genreIds.add("53");
        break;
      case ("Western"):
        genreIds.add("37");
        break;
      case ("Abenteuer"):
        genreIds.add("12");
        break;
      case ("Musik"):
        genreIds.add("10402");
        break;
    }
  }
  return genreIds;
}
