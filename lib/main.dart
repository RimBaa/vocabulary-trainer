import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:sqflite/sqflite.dart';
import 'package:vocabulary/drawer.dart';
//import 'global_vars.dart';
//import 'language.dart';
import 'vocable.dart';
//import 'package:path/path.dart';
import 'learn.dart';

void main() {
  //SharedPreferences.setMockInitialValues({});
  runApp(new VocabularyApp());
}

// Future<Null> main() async {
//   runApp(new VocabularyApp());
// }

class VocabularyApp extends StatefulWidget {
  @override
  VocabularyState createState() {
    return new VocabularyState();
  }
}

class VocabularyState extends State<VocabularyApp> {
  @override
  void initState() {
    getDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'vocabulary trainer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "vocabulary trainer"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//home screen
class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.title),
        actions: <Widget>[
          Container(padding: EdgeInsets.symmetric(vertical: 15.0)),
        ],
      ),
      body: _homeScreen(context),
      drawer: createDrawer(context),
    );
  }

  Widget _homeScreen(context) {
    return new Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
          RaisedButton(
            onPressed: () async {
              ListVocabState mainScreenObj = new ListVocabState();
               
              mainScreenObj.addVocable(context);
            },
            //   child: const Text("add a new  language",
            //       style: TextStyle(fontSize: 20, color: Colors.white)),
            //   color: Colors.blue,
            //   padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
            // ),
            // RaisedButton(
            //   onPressed: () async {
            //     await addVocable(context);
            //   },
            child: const Text("add a vocable",
                style: TextStyle(fontSize: 20, color: Colors.white)),
            color: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 70.0),
          ),
          RaisedButton(
            onPressed: () async {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Learn()));
            },
            child: const Text("start learning",
                style: TextStyle(fontSize: 20, color: Colors.white)),
            color: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 70.0),
          )
        ]));
  }
}
