import 'package:flutter/material.dart';
import 'package:vocabulary/global_vars.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//import 'language.dart';

// page with list of vocables
class ListVocab extends StatefulWidget {
  @override
  ListVocabState createState() => ListVocabState();
}

class ListVocabState extends State<ListVocab> {
  bool deleteBool = false;

  void initState() {
    super.initState();
    deleteBool = false;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("vocabulary",
            style: TextStyle(fontSize: fontSize, color: Colors.white)),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          selectPopupMenu(context, deleteBool),
        ],
      ),
      body: voclist(context),
      bottomNavigationBar: BottomAppBar(
        child: _addRowDel(deleteBool),
      ),
    );
  }

  selectPopupMenu(BuildContext context, bool delete) {
    if (delete == false) {
      return PopupMenuButton(onSelected: (value) async {
        print(value);
        if (value == 'add') {
          await addVocable(context);
          await getVocableList();
          deleteBool = false;
        } else {
          deleteBool = true;
        }
        setState(() {});
      }, itemBuilder: (BuildContext context) {
        return VocSettings.editVoc.map((String val) {
          return PopupMenuItem(value: val, child: Text(val));
        }).toList();
      });
    } else {
      return PopupMenuButton(onSelected: (value) async {
        if (value == 'select all') {
          select2del = List.filled(vocableList.length, true);
        }
        setState(() {});
      }, itemBuilder: (BuildContext context) {
        return [PopupMenuItem(value: 'select all', child: Text('select all'))];
      });
    }
  }

// create vocable list
  Widget voclist(context) {
    return FutureBuilder(
        future: getVocableList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return new ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: vocableList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      child: Container(
                        height: 70,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: withOrWithoutCheckbox(deleteBool, index)),
                      ),
                      onTap: () async {
                        print(index);
                        await editVoc(context, index);
                        await getVocableList();
                        setState(() {});
                      },
                    ),
                  );
                });
          } else {
            return CircularProgressIndicator();
          }
        });
  }

// adding checkbox for deleting vocables if delete has been pressed
  withOrWithoutCheckbox(bool delete, int index) {
    if (delete == false) {
      return (<Widget>[
        Text(vocableList[index]['word'], style: TextStyle(fontSize: 18)),
        Text(vocableList[index]['translation'], style: TextStyle(fontSize: 18))
      ]);
    } else {
      if (select2del.length != vocableList.length) {
        select2del = List.filled(vocableList.length, false);
      }
      if (select2del.length > 0) {
        return (<Widget>[
          Text(vocableList[index]['word'], style: TextStyle(fontSize: 18)),
          Text(vocableList[index]['translation'],
              style: TextStyle(fontSize: 18)),
          Container(
              width: 20,
              child: IconButton(
                icon: getCheckbox(index),
                onPressed: () {
                  select2del[index] = !select2del[index];
                  setState(() {});
                },
              ))
        ]);
      } else
        return <Widget>[];
    }
  }

// return either filled or blank checkbox
  getCheckbox(index) {
    if (select2del[index] == true)
      return Icon(Icons.check_box);
    else
      return Icon(Icons.check_box_outline_blank);
  }

//bottom Navigator: cancel and delete options for deleting vocables
  _addRowDel(delete) {
    if (delete == true) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
              onPressed: () {
                deleteBool = false;
                select2del = [];
                setState(() {});
              },
              child: Text("cancel")),
          RaisedButton(
              onPressed: () async {
                for (var i = 0; i < select2del.length; i++) {
                  if (select2del[i] == true) {
                    await deleteVocableTable(vocableList[i]['id']);
                  }
                }
                deleteBool = false;
                select2del = [];
                //    await getVocableList();
                setState(() {});
              },
              child: Text("delete"))
        ],
      );
    } else
      return Row();
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
                onPressed: () async {
                  Navigator.of(context).pop(word);
                  await addVoc2Table(word, translation);
                },
              )
            ],
          );
        });
  }

  Future<String> editVoc(BuildContext context, int index) async {
    String word = vocableList[index]['word'];
    String translation = vocableList[index]['translation'];

    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit a vocable'),
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                  controller: new TextEditingController(
                      text: vocableList[index]['word']),
                  autofocus: true,
                  decoration: new InputDecoration(labelText: 'word'),
                  onChanged: (value) {
                    word = value;
                  },
                )),
                new Expanded(
                    child: new TextField(
                  controller: new TextEditingController(
                      text: vocableList[index]['translation']),
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
                onPressed: () async {
                  Navigator.of(context).pop(word);
                  await updateVocableTable(VocableTable(
                      id: vocableList[index]['id'],
                      word: word,
                      translation: translation,
                      section: vocableList[index]['section']));
                  // await getVocableList();
                },
              )
            ],
          );
        });
  }

//adding vocable to the databases
  addVoc2Table(vocab, transl) async {
    int index = 0;
    int largestId;
    bool indexChosen = false;
    await getVocableListId();
    print(idList);

    //finding id that isn't already used
    if (idList.length > 0) {
      largestId = idList[idList.length - 1];

      for (int i = 0; i < largestId; i++) {
        if (!idList.contains(i)) {
          index = i;
          indexChosen = true;
          break;
        }
      }
      if (indexChosen == false) {
        index = largestId + 1;
      }
      print(largestId);
    }

    var voc =
        VocableTable(id: index, word: vocab, translation: transl, section: 1);

    await insertVocable(voc);
  }

  //get vocable list of current language
  getVocableList() async {
    Database db = await database;

    vocableList = await db.query(dbName);
    print(await vocable());
  }

//get ids of vocable list of current language
  getVocableListId() async {
    Database db = await database;
    idList = [];
    vocableList = await db.query(dbName);
    // print(await vocable());

    for (int i = 0; i < vocableList.length; i++) {
      idList.add(vocableList[i]['id']);
    }
    return idList;
  }
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
        id: maps[i]['id'],
        word: maps[i]['word'],
        translation: maps[i]['translation'],
        section: maps[i]['section']);
  });
}

Future<void> updateVocableTable(VocableTable vocable) async {
  Database db;

  db = await database;

  await db.update(dbName, vocable.toMap(),
      where: "id = ?", whereArgs: [vocable.id]);
}

Future<void> deleteVocableTable(int id) async {
  Database db;
  db = await database;

  await db.delete(dbName, where: "id = ?", whereArgs: [id]);
}

getDatabase() async {
  String databasename = dbName + '.db';
  database = openDatabase(join(await getDatabasesPath(), databasename),
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
    return {
      'id': id,
      'word': word,
      'translation': translation,
      'section': section
    };
  }

  @override
  String toString() {
    return '[$id, $word, $translation, $section]';
  }
}

//settings for popup menu vocable list
class VocSettings {
  static String del = "delete";
  static String add = "add";

  static List<String> editVoc = <String>[add, del];
}
