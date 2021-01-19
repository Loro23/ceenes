import 'package:ceenes_prototype/util/actor.dart';
import 'package:ceenes_prototype/util/api.dart';
import 'package:ceenes_prototype/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

Map details;
String _overviewEn = "";

class Details_view extends StatefulWidget {
  Details_view(Map _details, String overviewEn) {
    details = _details;
    _overviewEn = overviewEn;
  }

  @override
  _Details_viewState createState() => _Details_viewState();
}

class _Details_viewState extends State<Details_view> {
  List<Widget> providerimg = [];
  List<Widget> actorImg = [];
  String genres = "";
  String overview = details["overview"];

  @override
  void initState() {
    super.initState();
    for (Map x in details["watch/providers"]["results"]["DE"]["flatrate"]) {
      providerimg.add(Container(
        padding: const EdgeInsets.all(5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.network(
            "https://image.tmdb.org/t/p/w500/" + x["logo_path"],
          ),
        ),
        height: 50,
      ));
    }
    for (Map x in details["genres"]) {
      genres = genres + x["name"] + ", ";
    }
    genres = genres.substring(0, genres.length - 2);
    if (overview == "") {
      overview = _overviewEn;
    }
  }

  Map<String, dynamic> _cast = Map();
  List cast = [];

  List<Actor> actors = [];

  List<Widget> actorWidgets = [];

  _setCast() async {
    _cast = await tmdb.v3.movies.getCredits(
      details["id"],
    );
    cast = _cast.values.toList()[1];
    for (int i = 0; i < cast.length; i++) {
      print(cast[i]);
      actors.add(new Actor(cast[i]["name"], cast[i]["profile_path"],
          cast[i]["character"], cast[i]["popularity"]));
    }
    actors.sort((a, b) => a.pop.compareTo(b.pop));
    actors = actors.reversed.toList();

    for (Actor actor in actors) {
      if (actor.profil_path == null) continue;
      actorWidgets.add(Padding(
        padding: const EdgeInsets.only(left: 5, top: 2),
        child: Container(
          width: 100,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 10,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipOval(
                    child: FadeInImage.memoryNetwork(
                      fit: BoxFit.cover,
                      placeholder: kTransparentImage,
                      image: "https://image.tmdb.org/t/p/w185/" +
                          actor.profil_path,
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Center(
                      child: Text(
                        actor.name + " als " + actor.character,
                        style: TextStyle(fontSize: 10),
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ));
    }
    return actorWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        color: backgroundcolor_dark,
        //height: MediaQuery.of(context).size.height * .60,
        child: Stack(children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: FadeInImage.memoryNetwork(
                          width: 90,
                          placeholderCacheWidth: 90,
                          imageCacheWidth: 90,
                          placeholder: kTransparentImage,
                          image: "https://image.tmdb.org/t/p/w500/" +
                              details["poster_path"],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 2, bottom: 5),
                                child: Container(
                                    child: RichText(
                                  overflow: TextOverflow.clip,
                                  text: TextSpan(
                                    text: details["title"] + " ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
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
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Card(
                                    color: Colors.grey[800],
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              details["vote_average"]
                                                      .toString() +
                                                  "/10 ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    238, 238, 238, 1),
                                              )),
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow[300],
                                            size: 16.0,
                                            semanticLabel: 'Star with rating',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Card(
                                    color: Colors.grey[800],
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        details["runtime"].toString() + "min ",
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Wrap(
                                children: providerimg,
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(width: 40),
                  ],
                ),
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
                  child: Text(overview, style: TextStyle(fontSize: 16))),
              Container(
                height: 150,
                child: FutureBuilder(
                  future: _setCast(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        //color: Colors.blue,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data,
                        ),
                      );
                    } else
                      return CircularProgressIndicator();
                  },
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
          Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.all(8),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black54.withOpacity(0.5),
              child: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 23,
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
