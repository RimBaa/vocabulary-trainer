import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabulary/learn/learn.dart';
import 'package:vocabulary/vocabulary/database.dart';
import 'package:vocabulary/vocabulary/vocable.dart';
import 'global_vars.dart';

void main() {
  runApp(new VocabularyApp());
}

class VocabularyApp extends StatefulWidget {
  @override
  VocabularyState createState() {
    return new VocabularyState();
  }
}

class VocabularyState extends State<VocabularyApp> {
  @override
  void initState() {
    chosenSectionList = [true, true, true, true, true];
    sectionNum = [1, 2, 3, 4, 5];
    super.initState();
    getDB().whenComplete(() {
      setState(() {});
    });
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
    return MaterialApp(debugShowCheckedModeBanner: false,
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
      resizeToAvoidBottomPadding: false,
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

//handle screen switch
  _setScreen(int index, context) {
    if (index == 0) {
      return ListVocab();
    } else {
      rebuildScreen = true;
      return Learn();
    }
  }
}
