import 'package:ceenes_prototype/util/colors.dart';
import 'package:ceenes_prototype/widgets/admin/admin_login.dart';
import 'package:ceenes_prototype/widgets/admin/create_view.dart';
import 'package:ceenes_prototype/widgets/login_view.dart';
import 'package:ceenes_prototype/widgets/start_view.dart';
import 'package:ceenes_prototype/widgets/swipe_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'util/api.dart';
import 'util/movie.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  bool _initialized = false;

  bool _error = false;

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      print('error');
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Material(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            color: Colors.black,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.pinkAccent,
                      size: 25,
                    ),
                    onPressed: () {
                      html.window.location.reload();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    FirebaseAnalytics analytics = FirebaseAnalytics();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      theme: ThemeData(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Color.fromRGBO(25, 25, 25, 1),
          secondaryHeaderColor: Color.fromRGBO(25, 25, 25, 1),
          backgroundColor: Color.fromRGBO(25, 25, 25, 1),
          primaryColorDark: Color.fromRGBO(25, 25, 25, 1),
          dialogBackgroundColor: Color.fromRGBO(25, 25, 25, 1),
          bottomAppBarColor: Color.fromRGBO(25, 25, 25, 1),
          accentColor: Color.fromRGBO(25, 25, 25, 1),
          colorScheme: ColorScheme.dark(),
          cardColor: backgroundcolor_dark),
      title: 'Ceenes - Findet den perfekten Film',
      home: MyHomePage(
          title: 'Ceenes Homepage', analytics: analytics, observer: observer),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.analytics, this.observer})
      : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _MyHomePageState createState() =>
      _MyHomePageState(this.analytics, this.observer);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this.analytics, this.observer);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    return StartView(analytics: this.analytics, observer: this.observer);
  }
}
