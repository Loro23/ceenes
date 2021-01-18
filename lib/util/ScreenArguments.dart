import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class ScreenArguments {

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  ScreenArguments({this.observer, this.analytics});
}