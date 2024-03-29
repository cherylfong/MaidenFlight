import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:intl/intl.dart';


void main() => runApp(MyApp());

class Saves {

  DateTime _time;

  DateTime get time => _time;

  set setTime(DateTime value) {
    _time = value;
  }

  WordPair _word;

  WordPair get word => _word;

  set setWord(WordPair value) {
    _word = value;
  }

  Saves(this._time, this._word);

}

class MyApp extends StatelessWidget {
  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {

    final wordPair = WordPair.random();

    return MaterialApp(
//      title: 'My Flutter App',
      theme: ThemeData(
//        // This is the theme of your application.
//        //
//        // Try running your application with "flutter run". You'll see the
//        // application has a blue toolbar. Then, without quitting the app, try
//        // changing the primarySwatch below to Colors.green and then invoke
//        // "hot reload" (press "r" in the console where you ran "flutter run",
//        // or simply save your changes to "hot reload" in a Flutter IDE).
//        // Notice that the counter didn't reset back to zero; the application
//        // is not restarted.
        primarySwatch: Colors.teal,
//      ),
//      home: MyHomePage(title: 'My First Flutter App!'),
      ),

      title: 'Random Word Pair Generator',
      home: RandomWords(),
    );

  }
}


// creates a state class for RandomWordsState to inherit
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

// creates a widget displaying random words
class RandomWordsState extends State<RandomWords> {

  final List<WordPair> _suggestions = <WordPair>[];

  // to save wordpairs in a set
  final Set<WordPair> _saved = Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);
  final formatter = new DateFormat.yMd().add_jms();

  Set<Saves> _savingSet = Set<Saves>();

  @override
  Widget build(BuildContext context) {

//    final WordPair wordPair = WordPair.random();
//    return Text(wordPair.asPascalCase);

    return Scaffold (
      appBar: AppBar(
        title: Text('Random Word Pair Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );

  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        // The itemBuilder callback is called once per suggested
        // word pairing, and places each suggestion into a ListTile
        // row. For even rows, the function adds a ListTile row for
        // the word pairing. For odd rows, the function adds a
        // Divider widget to visually separate the entries. Note that
        // the divider may be difficult to see on smaller devices.
        itemBuilder: (BuildContext _context, int i) {
          // Add a one-pixel-high divider widget before each row
          // in the ListView.
          if (i.isOdd) {
            return Divider();
          }

          // The syntax "i ~/ 2" divides i by 2 and returns an
          // integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          // This calculates the actual number of word pairings
          // in the ListView,minus the divider widgets.
          final int index = i ~/ 2;
          // If you've reached the end of the available word
          // pairings...
          if (index >= _suggestions.length) {
            // ...then generate 10 more and add them to the
            // suggestions list.
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        }
    );
  }

  Widget _buildRow(WordPair pair) {
//    final bool alreadySaved = _saved.contains(pair);
    bool alreadySaved = false;

    Saves s = new Saves(null,null);

    if (getItemInSavingSet(pair) != null){
      print("Word in Set");
      s = getItemInSavingSet(pair);
      alreadySaved = true;
    }

    DateTime timeNow = DateTime.now();

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.yellow : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
//            _saved.remove(pair);
            print("INFO: Removed");
            var j = _savingSet.remove(s);
            if (j){
              print("remove done");
            }
          } else {
//            _saved.add(pair);
          print("INFO: SAVED");
          print(pair);
          s.setWord = pair;
          s.setTime = timeNow;
          _savingSet.add(s);
          }
        });
      },
    );

  }

// ORIGINAL TUTORIAL FUNCTION
//
//  void _pushSaved() {
//    Navigator.of(context).push(
//      MaterialPageRoute<void>(
//        builder: (BuildContext context) {
//          final Iterable<ListTile> tiles = _saved.map(
//                (WordPair pair) {
//              return ListTile(
//                title: Text(
//                  pair.asPascalCase,
//                  style: _biggerFont,
//                ),
//                trailing: Text("Sample Time",
//                  style: _biggerFont,
//                ),
//              );
//            },
//          );
//          final List<Widget> divided = ListTile
//              .divideTiles(
//            context: context,
//            tiles: tiles,
//          )
//              .toList();
//
//          return Scaffold(
//            appBar: AppBar(
//              title: Text('My Saves'),
//            ),
//            body: ListView(children: divided),
//          );
//        },
//      ),
//    );
//  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _savingSet.map(
                (Saves s) {
              return ListTile(
                leading: Icon(Icons.crop_square
                ),
                title: Text(
                  s._word.asPascalCase,
                  style: _biggerFont,
                ),
                subtitle: Text(
//                  s._time.toString(),
                  formatter.format(s._time),
//                  style: _biggerFont,
                ),

              );
            },
          );
          final List<Widget> divided = ListTile
              .divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('My Saves'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  // return the instance in the Set with the matching WordPair
  Saves getItemInSavingSet(WordPair w){

    print("START COMPARE");
    for(var s in _savingSet){

      print( "compare " + w.toString() + " : " + s._word.toString());
      if( w == s._word ){
        print("START COMPARE");
        return s;
      }
    }
    print("START COMPARE");
      return null;

  }

}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
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
              'You have clicked the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
