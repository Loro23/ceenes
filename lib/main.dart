import 'package:flutter/material.dart';
import 'api.dart';
import 'movie.dart';
import 'package:tmdb_api/tmdb_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List movies = [];
 _getTrendingMovies()async{
    Map result = await tmdb.v3.discover.getMovies(page: 1, language: 'de',withOrginalLanguage: 'de', );
    List resulties = result.values.toList();
    for (int i = 0; i <20; i++){
      int id = resulties[1][i]['id'];
      String title = resulties[1][i]['title'];
      String original_title = resulties[1][i]['original_title'];
      String overview = resulties[1][i]['overview'];
      List genre_ids = resulties[1][i]['genre_ids'];
      String poster_path = resulties[1][i]['poster_path'];
      double popularity = resulties[1][i]['popularity'];
      double vote_average = resulties[1][i]['vote_average'];
      double vote_count = resulties[1][i]['vote_count'];

      Movie movie = Movie(id, title, original_title, overview, genre_ids,
      poster_path, popularity, vote_average, vote_count );
      movies.add(movie);
      print(movie.title);

      Map result = await tmdb.v3.movies.getDetails(movie.id, appendToResponse: "watch/providers");
      print(result);
      print('');



    }


  }

  @override
  Widget build(BuildContext context) {
   _getTrendingMovies();

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
