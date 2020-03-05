import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vocabulary/drawer.dart';
import 'global_vars.dart';
import 'language.dart';
import 'vocable.dart';
import 'package:path/path.dart';

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
    _getLanguages().whenComplete(() {
      setState(() {});
      getDatabase();
    });
    super.initState();
  }

  _getLanguages() async {
    prefs = await SharedPreferences.getInstance();
    languages = prefs.getStringList(keylanguageList) ?? [];
    currentlanguage = prefs.getString(keylanguage) ?? '0';
    print(currentlanguage);
    print(languages);
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
          Container(padding: EdgeInsets.symmetric(vertical: 15.0),child: Text(currentlanguage, textAlign: TextAlign.center, style:TextStyle(fontSize: fontSize))),
          PopupMenuButton(
            onSelected: (choice){
            setState(() {
              changeCurrentLanguage(choice);
              
            });},
            itemBuilder: (BuildContext context){
            return languages.map((String choice){
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice)
              );
            }).toList();
          })
        ],
      ),
      body: _homeScreen(context),
      drawer: createDrawer(context),
    );
  }

  Widget _homeScreen(context) {
    //no language to learn available
    if (currentlanguage == '0' || currentlanguage == null) {
      return new Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            RaisedButton(
              onPressed: () async {
                await addlanguage(context);
                print("$currentlanguage");
                if (currentlanguage != '0' && currentlanguage != null) {
                  setState(() {
                    languages.add(currentlanguage);
                    setCurrentLanguage(currentlanguage);
                    setLanguageList();
                  });
                }
              },
              child: const Text("add a new language",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              color: Colors.blue,
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            )
          ]));
    }

    // there already exist languages to learn
    else {
      return new Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
            RaisedButton(
              onPressed: () async {
                await addlanguage(context);
                print("$currentlanguage");
                if (currentlanguage != '0' && currentlanguage != null) {
                  setState(() {
                    if (!languages.contains(currentlanguage)) {
                      languages.add(currentlanguage);
                      setLanguageList();
                    }
                    setCurrentLanguage(currentlanguage);
                  });
                }
              },
              child: const Text("add a new  language",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              color: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
            ),
            RaisedButton(
              onPressed: () async {
                await addVocable(context);
              },
              child: const Text("add a vocable",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              color: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 70.0),
            ),
            RaisedButton(
              onPressed: () async {},
              child: const Text("start learning",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              color: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 70.0),
            )
          ]));
    }
  }
}
