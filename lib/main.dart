import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:vocabulary/section.dart';
import 'global_vars.dart';
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
    super.initState();
    getDB().whenComplete((){setState(() {
      
    });});
  }

  getDB() async {
    prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language') ?? 'English';
    languageCode = prefs.getString('languageCode') ?? 'en';
    print(languageCode);
    ListVocabState vocObj = new ListVocabState();
    getDatabase().whenComplete(() {
      vocObj.getVocableList().whenComplete(() {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'vocabulary trainer',
      theme: ThemeData(
        primarySwatch: Colors.amber,
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
  int indexScreen;
  
  initState() {
    super.initState();
    indexScreen = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _setScreen(indexScreen, context),
      //drawer: createDrawer(context),
      bottomNavigationBar: bottomNaviBar(context),
    );
  }

  bottomNaviBar(context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.amberAccent[700],
      unselectedItemColor: Colors.amberAccent[300],
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home), title: Text('vocabulary')),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.table_chart), title: Text('sections')),
        BottomNavigationBarItem(icon: Icon(Icons.school), title: Text('learn'))
      ],
      backgroundColor: Colors.amberAccent[100],
      onTap: (value) {
        setState(() {
          indexScreen = value;
        });
      },
      currentIndex: indexScreen,
    );
  }

  _setScreen(int index, context) {
    if (index == 0) {
      return ListVocab();
      // } else if (index == 1) {
      //   return Sections();
    } else {
      print('IIIIIIIIII');
      rebuildScreen = true;
      return Learn();
    }
  }
}
