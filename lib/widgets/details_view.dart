import 'package:flutter/material.dart';

Map details;

class Details_view extends StatefulWidget {
  Details_view(Map _details){
    details = _details; 
  }

  @override
  _Details_viewState createState() => _Details_viewState();
}

class _Details_viewState extends State<Details_view> {
  List<Widget> providerimg = [];
  String genres ="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for( Map x in details["watch/providers"]["results"]["DE"]["flatrate"]){
      providerimg.add(
        Container(
          padding: const EdgeInsets.all(5),
          child:
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.network("http://image.tmdb.org/t/p/w500/" + x["logo_path"],
            ),
          ),
          height: 50,
        )
        );
    }
    for( Map x in details["genres"]){
      genres = genres + x["name"] + ", ";
    }
    genres = genres.substring(0, genres.length - 2);
    
  }
  @override
  Widget build(BuildContext context,) {
    return Container(
      height: MediaQuery.of(context).size.height * .60,
      child: Stack(
              children: [SingleChildScrollView(
          child: Column(children: [
           
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
               
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(details["title"],
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color.fromRGBO(
                              238, 238, 238, 1),
                        ))),

                      
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(5)),
                          color: Color.fromRGBO(68, 68, 68, 1),
                        ),
                        margin: const EdgeInsets.only(
                            top: 5,
                            left:10,
                            bottom: 5),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(details["vote_average"]
                                        .toString() +
                                    "/10",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(
                                      238, 238, 238, 1),
                                )),
                            Icon(
                              Icons.star,
                              color: Colors.yellow[300],
                              size: 15.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                          ],
                        ),
                      ),
                      Row(children: providerimg,),
                    ]
                  ),
                )
            ],),
          
          Text(details["release_date"].toString()),
          Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(5)),
              color: Color.fromRGBO(68, 68, 68, 1),
            ),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(
                left: 20, right: 20, top: 5, bottom: 5),
            child: Text(genres,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      Color.fromRGBO(238, 238, 238, 1),
                )),
          ),
          Text(details["overview"]),
          ],),),
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
          ]
      ), 
      
    );
  }
}