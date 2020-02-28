import 'package:flutter/material.dart';
import 'package:vocabulary/global_vars.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
                addVoc2Table(word);
              },
            )
          ],
        );
      });
}

addVoc2Table(vocab) async{
  var voc = VocableTable(
    id: dbSize,
  word: vocab,
  section:1);

  await insertVocable(voc);
  print(await vocable());
}

class ListVocab extends StatefulWidget {
  @override
  _ListVocab createState() => _ListVocab();
}

class _ListVocab extends State<ListVocab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("vocabulary",
            style: TextStyle(fontSize: fontSize, color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
    );
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
    return 'VocableTable{id: $id, word: $word, section: $section';
  }
}

Future<void> insertVocable(VocableTable vocable) async{
  final Database db = await database;

  await db.insert(
    'vocable',
    vocable.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace
  );
}

Future<List<VocableTable>> vocable() async{
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('vocable');
  dbSize = maps.length;
  return List.generate(maps.length, (i){
    return VocableTable(
      id: maps[i]['id'],
      word: maps[i]['word'],
      section: maps[i]['section']
    );
  });
}

Future<void> updateVocableTable(VocableTable vocable) async{
  final db = await database;

  await db.update(
    'vocable',
    vocable.toMap(),
    where: "id = ?",
    whereArgs: [vocable.id]
  );
}

Future<void> deleteVocableTable(int id) async{
  final db = await database;

  await db.delete(
    'vocable',
    where: "id = ?",
    whereArgs: [id]
  );
}

getDatabase() async{
final datab = openDatabase(join(await getDatabasesPath(), 'firstLang.db'),
          onCreate: (db, version){
            return db.execute(
              "CREATE TABLE vocable(id INTEGER PRIMARY KEY, word TEXT, section INTEGER)"
            );
          },
          version: 1
         );
  database = datab; 

  for(int i= 0; i< languages.length ; i++){
    listTables[i] = openDatabase(join(await getDatabasesPath(), languages[i]+'.db'),
          onCreate: (db, version){
            return db.execute(
              "CREATE TABLE vocable(id INTEGER PRIMARY KEY, word TEXT, section INTEGER)"
            );
          },
          version: 1
         );

  }    
}