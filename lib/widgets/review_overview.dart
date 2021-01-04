import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

LinkedHashMap<Map<String, dynamic>, int> _sortedMap;
List _movies_dec;

class ReviewOverview extends StatefulWidget {
  @override
  _ReviewOverviewState createState() => _ReviewOverviewState();

  ReviewOverview(LinkedHashMap sortedMap, List movies_dec) {
    _sortedMap = sortedMap;
    _movies_dec = movies_dec;
  }
}

class _ReviewOverviewState extends State<ReviewOverview> {
  // ignore: missing_return
  String getCorrectPosterpath(int id) {
    for (int i = 0; i < _movies_dec.length; i++) {
      if (_movies_dec[i]["id"] == id) {
        return _movies_dec[i]["poster_path"];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(
      children: [
        _getReviewView(),
        //Stack für header
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.transparent
                ])),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                        top: 8, left: 8, bottom: 8, right: 12),
                    child: Image.asset(
                      "assets/ceenes_logo_yellow4x.png",
                      height: 40,
                    )),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget _getReviewView() {
    if (_sortedMap == null) {
      return Center(
          child: Text("Warte, bis deine Freunde fertig geswiped haben!"));
    }
    return Column(
      children: [
        Container(
          child: Text("Hier ist euer Ergebnis"),
          color: Colors.transparent,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _sortedMap.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Card(
                  child: InkWell(
                    onTap: () {
                      //print("tapped");
                    },
                    child: Row(
                      children: [
                        Image.network(
                          "http://image.tmdb.org/t/p/w92/" +
                              getCorrectPosterpath(_sortedMap.entries
                                  .elementAt(index)
                                  .key["id"]),
                          height: 120,
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            _sortedMap.entries.elementAt(index).key["title"],
                            overflow: TextOverflow.clip,
                          ),
                        )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _sortedMap.entries
                                .elementAt(index)
                                .value
                                .toString(), //voting
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
