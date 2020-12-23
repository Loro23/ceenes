import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Content extends StatefulWidget {
  final String title;
  final Widget child;

  Content({
    Key key,
    @required this.title,
    @required this.child,
  }) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content>
    with AutomaticKeepAliveClientMixin<Content> {
  final Color dark_0 = Color.fromRGBO(21, 21, 21, 1);
  final Color dark_1 = Color.fromRGBO(37, 37, 37, 1);
  final Color white_0 = Color.fromRGBO(238, 238, 238, 1);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
      color: dark_1,
      elevation: 0,
      margin: const EdgeInsets.all(5),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            color: Colors.black26,
            child: Text(
              widget.title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
