import 'package:ceenes_prototype/widgets/login_view.dart';
import 'package:ceenes_prototype/widgets/start_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Router{
   Route<dynamic> generateRoute(RouteSettings settings) {
    if (settings.name.substring(0,6)== "/login/"){
       return MaterialPageRoute(builder: (_) => Login_view(sessionIdee: settings.name.substring(6)));
      // zeige swipe screen 
      // parse den substring(7) => loginview(substring(7))
      
    }
    if(settings.name.substring(0,7)== "/review/"){

    }
    return MaterialPageRoute(builder: (_) => StartView());
  }
}