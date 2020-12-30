import 'package:flutter/material.dart';

Map details;

class Details_view extends StatefulWidget {
  Details_view(Map _details) {
    details = _details;
  }

  @override
  _Details_viewState createState() => _Details_viewState();
}

class _Details_viewState extends State<Details_view> {
  List<Widget> providerimg = [];
  String genres = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (Map x in details["watch/providers"]["results"]["DE"]["flatrate"]) {
      providerimg.add(Container(
        child: Image.network(
          "http://image.tmdb.org/t/p/w500/" + x["logo_path"],
        ),
        height: 50,
      ));
    }
    for (Map x in details["genres"]) {
      genres = genres + x["name"] + ", ";
    }
    genres = genres.substring(0, genres.length - 2);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      height: MediaQuery.of(context).size.height * .60,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        "http://image.tmdb.org/t/p/w500/" +
                            details["poster_path"],
                        height: 130,
                      )),
                ),
                IconButton(
                  icon: Icon(Icons.clear, color: Colors.white, size: 25),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
            Text(details["title"]),
            Text(details["overview"]),
            Row(
              children: providerimg,
            ),
            Text(details["release_date"].toString()),
            Text(details["vote_average"].toString()),
            Text(genres),
          ],
        ),
      ),
    );
  }
}
