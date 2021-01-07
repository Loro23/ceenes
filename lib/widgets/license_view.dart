import 'package:ceenes_prototype/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class LicenceCredits_View extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundcolor_dark,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
      child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.only(left:30, right: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 50,),

                    Text("Lizensen und Credits", style: TextStyle(fontSize: 25),),
                    SizedBox(height: 30,),
                    Text(
                        "We thank the Flutter community and their developers for providing the great widgets we use in our app. "),
                    SizedBox(height: 10,),

                    FlatButton(
                        onPressed: () {
                          showLicensePage(context: context, useRootNavigator: true);
                        },
                        child: Text("Click here to show licences correlated with Flutter")),
                    Padding(
                      padding: const EdgeInsets.only(top:25, bottom: 25),
                      child: Divider(
                        thickness: 1,


                        color: Colors.white70,
                      ),
                    ),
                    Text(
                        "Regarding the below named resources: Copyright and credits belong completely to the authors and creators. These ressources are neither created nor manipulated by us."),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: SelectableLinkify(
                        text:
                            "\"Tired Water Sticker\", https://media.giphy.com/media/bZEdZgtpBxKOOkmBqQ/source.gif\, by Fede Cook & Richard Perez. "
                            "Fede Cook can be found on dribble: https://dribbble.com/fedecook\.",
                        enableInteractiveSelection: true,
                        showCursor: false,
                        onOpen: (link) async {
                          if (await canLaunch(link.url)) {
                            await launch(link.url);
                          } else {
                            throw 'Could not launch $link';
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10,),

                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: SelectableLinkify(
                        text:
                            "\"Happy Water Sticker\", https://media.giphy.com/media/5neXTAObM9DDND6VQA/source.gif\, by Fede Cook & Richard Perez. "
                            "Fede Cook can be found on dribble: https://dribbble.com/fedecook\.",
                        showCursor: false,
                        onOpen: (link) async {
                          if (await canLaunch(link.url)) {
                            await launch(link.url);
                          } else {
                            throw 'Could not launch $link';
                          }
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top:25, bottom: 25),
                      child: Divider(
thickness: 1,                  color: Colors.white70,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SelectableLinkify(
                                text: "We are using the TMDB database and API which provides all the information shown for movies by our application (e.g. poster, overview, rating). Every content belonging to a movie is provided by tmdb and not by us. "
                                    "Check out tmdb: https://www.themoviedb.org/",
                                onOpen: (link) async {
                                  if (await canLaunch(link.url)) {
                                    await launch(link.url);
                                  } else {
                                    throw 'Could not launch $link';
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/tmdb-logo.png",
                            height: 40,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
      ),
    ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        splashRadius: 20,
                      ),
                    ),
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
}
