import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Review extends StatefulWidget {
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          child: FloatingActionButton(
        onPressed: () {},
        child: Text("Review anzeigen"),
      )),
    );
  }
}
