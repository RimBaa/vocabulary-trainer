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
addVoc2Table(vocab, transl) async {
  int index = 0;

  await getVocableList();
  print(vocableList.length);
  index = vocableList.length;


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

  var voc = VocableTable(id: index, word: vocab, translation: transl,section: 1);


  await insertVocable(voc);

}

//get vocable list of current language
getVocableList() async {
  Database db = await database;

  vocableList = await db.query(dbName);
  print(await vocable());

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
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
                child: Row(children: <Widget>[
                  Expanded(
                 child: Column(
                   children: <Widget>[
                //     Container(
                //         margin: EdgeInsets.symmetric(vertical: 18.5),
                //         child: 
                        // Row(

                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: <Widget>[
                        //    Column(
                        //      children: <Widget>[Text(vocableList[index]['word'],
                        //              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),],),
                        //    Column(children: <Widget>[Text(vocableList[index]['word'],
                        //              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),],)
                        //   ],
                        // )
                        // ListTile(
                        //     subtitle: Text("section: " +
                        //         (vocableList[index]['section']).toString()),
                        //     title: Row(
                        //      mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //       children: <Widget>[
                        //         Column(
                        //           crossAxisAlignment:CrossAxisAlignment.start,
                        //       children: <Widget>[
                        //         Text(vocableList[index]['word'],
                        //             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        //       ],
                        //         ),
                        //          Column(
                        //           crossAxisAlignment:CrossAxisAlignment.start,
                        //       children: <Widget>[
                        //         Text(vocableList[index]['translation'],
                        //             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        //       ],
                        //         )
                                
                          
                        //       ],
                        //     ))
                                 Text(vocableList[index]['word'],
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                    Text("section: " + vocableList[index]['section'].toString(),
                                    style: TextStyle(fontSize: 12, color: Colors.grey) )
                   ],
                   crossAxisAlignment: CrossAxisAlignment.start )
                  ),
                  Expanded(child: 
                                 Text(vocableList[index]['translation'],
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),)
                   ]
                             )
                  
                  ,
                 );
              
            });
      });
}

//database methods
Future<void> insertVocable(VocableTable vocable) async {
  Database db;

    db = await database;

  await db.insert(dbName, vocable.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore);
}

Future<List<VocableTable>> vocable() async {
  Database db;

    db = await database;
  

  final List<Map<String, dynamic>> maps = await db.query(dbName);
  dbSize = maps.length;
  return List.generate(maps.length, (i) {
    return VocableTable(
        id: maps[i]['id'], word: maps[i]['word'], translation: maps[i]['translation'], section: maps[i]['section']);
  });
}

Future<void> updateVocableTable(VocableTable vocable) async {
  Database db;

    db = await database;

  await db
      .update(dbName, vocable.toMap(), where: "id = ?", whereArgs: [vocable.id]);
}

Future<void> deleteVocableTable(int id) async {
  Database db;
    db = await database;


  await db.delete(dbName, where: "id = ?", whereArgs: [id]);
}


getDatabase() async {

    String databasename = dbName+'.db';
    database= openDatabase(join(await getDatabasesPath(), databasename),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $dbName(id INTEGER PRIMARY KEY, word TEXT, translation TEXT, section INTEGER)");
    }, version: 1);
}

class VocableTable {
  final int id;
  final String word;
  final String translation;
  final int section;

  VocableTable({this.id, this.word, this.translation, this.section});

  Map<String, dynamic> toMap() {
    return {'id': id, 'word': word, 'translation': translation, 'section': section};
  }

  @override
  String toString() {
    return '[$id, $word, $translation, $section]';
  }
}
