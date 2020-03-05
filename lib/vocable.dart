import 'package:flutter/material.dart';
import 'package:vocabulary/global_vars.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'language.dart';

// page with list of vocables
class ListVocab extends StatefulWidget {
  @override
  _ListVocab createState() => _ListVocab();
}

class _ListVocab extends State<ListVocab> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(currentlanguage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: fontSize))),
          PopupMenuButton(onSelected: (choice) {
            setState(() {
              changeCurrentLanguage(choice);
              getCurrentDatabase();
            });
          }, itemBuilder: (BuildContext context) {
            return languages.map((String choice) {
              return PopupMenuItem<String>(value: choice, child: Text(choice));
            }).toList();
          })
        ],
        title: Text("vocabulary",
            style: TextStyle(fontSize: fontSize, color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: _vocableList(context),
    );
  }
}

// adding vocables
Future<String> addVocable(BuildContext context) async {
  String word = '';
  String translation = '';

  return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter a new vocable'),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(labelText: 'word'),
                onChanged: (value) {
                  word = value;
                },
              )),
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(labelText: 'translation'),
                onChanged: (value) {
                  translation = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(word);
                addVoc2Table(word, translation);
                // addVoc2Table(translation, currentlanguage);
              },
            )
          ],
        );
      });
}

//adding vocable to the databases
addVoc2Table(vocab, translation) async {
  int index = 0;
  List idsList = [];

  if (translationList != null) {
    index = translationList.length + 1;
    
    Database dbTranslation = await database;
    Database dbLearn = await databaseLearn;
    List<Map<String, dynamic>> ids = await dbTranslation
        .rawQuery('SELECT id FROM firstLang WHERE word = ?', [translation]);
    ids.forEach((row) => idsList.add(row['id']));

    // List<Map<String, dynamic>> idsLearn = await dbLearn.rawQuery(
    //     'SELECT id FROM $currentlanguage WHERE id = ?', idsList);
    // idsLearn.forEach((row) => print(row));

//check if id of translation (idsList) exists in vocableList, if not take that id as index to insert vocable else index = translationList.length
    for (var i = 0; i < vocableList.length; i++) {
      

    }

  }

  // for the first entry where the size is null
  // if (dbSize != null) {
  //   dbSize = dbSize+1;
  // }

  // check if translation already in firstLang database
  // -> if yes get id of translation

  // for (var i = 0; i < translationList.length; i++) {
  //   if(translationList[i]['word']== translation ){
  //     for (var j = 0; i <= vocableList[j]['id'] ; j++) {
  //       if (vocableList[j]['id'] == i){

  //         break;
  //       }
  //       else if (vocableList.length-1 == j) {
  //         index = i;
  //         break;
  //       }
  //     }
  //     break;
  //   }
  // }

  var voc = VocableTable(id: index, word: vocab, section: 1);
  var transl = VocableTable(id: index, word: translation, section: 1);

  await insertVocable(transl, "firstLang");
  await insertVocable(voc, currentlanguage);
}

//get vocable list of current language
getVocableList() async {
  Database dbTrans = await database;
  translationList = await dbTrans.query('firstLang');
  Database dblearn = await databaseLearn;
  vocableList = await dblearn.query(currentlanguage);
  print(await vocable('firstLang'));
  print(await vocable(currentlanguage));
}

// create List of vocables
Widget _vocableList(context) {
  return FutureBuilder(
      future: getVocableList(),
      builder: (context, snapshot) {
        return new ListView.builder(
            itemCount: vocableList.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 18.5),
                        child: ListTile(
                            subtitle: Text("section: " +
                                (vocableList[index]['section']).toString()),
                            title: Row(
                              children: <Widget>[
                                Text(vocableList[index]['word'],
                                    style: TextStyle(fontSize: 20)),
                                Text(translationList[index]['word'],
                                    style: TextStyle(fontSize: 20))
                              ],
                            )))
                  ],
                ),
              );
            });
      });
}

//database methods
Future<void> insertVocable(VocableTable vocable, String table) async {
  Database db;
  if (table == 'firstLang') {
    db = await database;
  } else {
    db = await databaseLearn;
  }
  await db.insert(table, vocable.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<List<VocableTable>> vocable(String table) async {
  Database db;
  if (table == 'firstLang') {
    db = await database;
  } else {
    db = await databaseLearn;
  }

  final List<Map<String, dynamic>> maps = await db.query(table);
  dbSize = maps.length;
  return List.generate(maps.length, (i) {
    return VocableTable(
        id: maps[i]['id'], word: maps[i]['word'], section: maps[i]['section']);
  });
}

Future<void> updateVocableTable(VocableTable vocable, String table) async {
  Database db;
  if (table == 'firstLang') {
    db = await database;
  } else {
    db = await databaseLearn;
  }
  await db
      .update(table, vocable.toMap(), where: "id = ?", whereArgs: [vocable.id]);
}

Future<void> deleteVocableTable(int id, String table) async {
  Database db;
  if (table == 'firstLang') {
    db = await database;
  } else {
    db = await databaseLearn;
  }

  await db.delete(table, where: "id = ?", whereArgs: [id]);
}

// getDatabase() async{
// final datab = openDatabase(join(await getDatabasesPath(), 'firstLang.db'),
//           onCreate: (db, version){
//             return db.execute(
//               "CREATE TABLE firstLang(id INTEGER PRIMARY KEY, word TEXT, section INTEGER)"
//             );
//           },
//           version: 1
//          );
//   database = datab;

//   for(int i= 0; i< languages.length ; i++){
//     String name = languages[i];
//     listTables[i] = openDatabase(join(await getDatabasesPath(), languages[i]+'.db'),
//           onCreate: (db, version){
//             return db.execute(
//               "CREATE TABLE $name(id INTEGER PRIMARY KEY, word TEXT, section INTEGER)"
//             );
//           },
//           version: 1
//          );

//   }
// }

getDatabase() async {
  database = openDatabase(join(await getDatabasesPath(), 'firstLang.db'),
      onCreate: (db, version) {
    return db.execute(
        "CREATE TABLE firstLang(id INTEGER PRIMARY KEY, word TEXT, section INTEGER)");
  }, version: 1);
  //database = datab;
  String databasename = currentlanguage + '.db';

  if (currentlanguage != '0') {
    databaseLearn = openDatabase(join(await getDatabasesPath(), databasename),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $currentlanguage(id INTEGER PRIMARY KEY, word TEXT, section INTEGER)");
    }, version: 1);
  }

  // databaseLearn = databaselearn;
}

getCurrentDatabase() async {
  if (currentlanguage != '0') {
    String databasename = currentlanguage + '.db';
    databaseLearn = openDatabase(join(await getDatabasesPath(), databasename),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $currentlanguage(id INTEGER PRIMARY KEY, word TEXT, section INTEGER)");
    }, version: 1);
  }
}

class VocableTable {
  final int id;
  final String word;
  final int section;

  VocableTable({this.id, this.word, this.section});

  Map<String, dynamic> toMap() {
    return {'id': id, 'word': word, 'section': section};
  }

  @override
  String toString() {
    return '[$id, $word, $section]';
  }
}
