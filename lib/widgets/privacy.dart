import 'package:ceenes_prototype/util/colors.dart';
import 'package:ceenes_prototype/util/privacy_policy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:flutter_html/style.dart';

// ignore: camel_case_types
class PrivacyPolicy extends StatelessWidget {
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
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 20),
                    child: Text(
                      "Datenschutzerklärung",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Html(
                      onLinkTap: (url) async {
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      data: privacy_policy,
                      style: {
                        "html": Style(
                          color: Colors.white,
                        )
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: MediaQuery.of(context).size.width,
              /*
              decoration: BoxDecoration(

                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent
                  ])),

                 */
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
      ),
    );
  }
}
