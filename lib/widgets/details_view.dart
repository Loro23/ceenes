import 'dart:convert';

import 'package:ceenes_prototype/util/actor.dart';
import 'package:ceenes_prototype/util/api.dart';
import 'package:ceenes_prototype/util/colors.dart';
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
  List<Widget> actorImg = [];
  String genres = "";
  @override
  void initState() {
    super.initState();
    for (Map x in details["watch/providers"]["results"]["DE"]["flatrate"]) {
      providerimg.add(Container(
        padding: const EdgeInsets.all(5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.network(
            "http://image.tmdb.org/t/p/w500/" + x["logo_path"],
          ),
        ),
        height: 50,
      ));
    }
    for (Map x in details["genres"]) {
      genres = genres + x["name"] + ", ";
    }
    genres = genres.substring(0, genres.length - 2);
  }

  Map<String, dynamic> _cast = Map();
  List cast = [];

  List<Actor> actors = [];

  List<Widget> actorWidgets = [];

  _setCast() async {
    _cast = await tmdb.v3.movies.getCredits(details["id"]);
    cast = _cast.values.toList()[1];
    for (int i = 0; i < cast.length; i++) {
      print(cast[i]);
      actors.add(new Actor(
          cast[i]["name"], cast[i]["profile_path"], cast[i]["popularity"]));
    }
    actors.sort((a, b) => a.pop.compareTo(b.pop));
    actors = actors.reversed.toList();

    for (Actor actor in actors){
      if (actor.profil_path == null) continue;
      actorWidgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.grey[800],
          child: Container(
            width: 80,
            height: 200,
            child: Column(
              children: [
                Image.network(
                  "https://image.tmdb.org/t/p/original/" +
                      actor.profil_path,
                  height: 80,
                ),
                Expanded(child: Text(actor.name, style: TextStyle(fontSize: 10), overflow: TextOverflow.clip,))
              ],
            ),
          ),
        ),
      ));
    }
    return actorWidgets.getRange(0, 10).toList();
  }

  @override
  Widget build(
    BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        color: backgroundcolor_dark,
        //height: MediaQuery.of(context).size.height * .60,
        child: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: 8,
                        right: 8,
                        left: 20,
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            "http://image.tmdb.org/t/p/w500/" +
                                details["poster_path"],
                            height: 120,
                          )),
                    ),
                    Flexible(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(8),
                                child: RichText(
                                  overflow: TextOverflow.clip,
                                  text: TextSpan(
                                    text: details["title"] + " ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Color.fromRGBO(238, 238, 238, 1),
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "(" +
                                              details["release_date"]
                                                  .toString()
                                                  .substring(0, 4) +
                                              ")",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  202, 202, 202, 0.9))),
                                    ],
                                  ),
                                )),
                            Card(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        details["vote_average"].toString() +
                                            "/10",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromRGBO(238, 238, 238, 1),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.yellow[300],
                                      size: 15.0,
                                      semanticLabel: 'Star with rating',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: providerimg,
                            ),
                          ]),
                    ),
                    SizedBox(width: 30),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(genres,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(238, 238, 238, 1),
                      )),
                ),
                Container(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 20, right: 20),
                    child: Text(details["overview"],
                        style: TextStyle(fontSize: 16))),
                Container(
                  height: 120,
                  child: FutureBuilder(
                    future: _setCast(),
                    builder: (context, AsyncSnapshot snapshot){
                      if(snapshot.hasData){
                        return Container(
                          //color: Colors.blue,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data,
                          ),
                        );
                      } else return CircularProgressIndicator();
                    },
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.all(10),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black,
              child: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
