import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vocabulary/global_vars.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:csv/csv.dart';
//import 'package:flutter_share/flutter_share.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vocabulary/vocabulary/database.dart';

//import 'language.dart';

// page with list of vocables
class ListVocab extends StatefulWidget {
  @override
  ListVocabState createState() => ListVocabState();
}

class ListVocabState extends State<ListVocab> {
  bool deleteBool = false;

  List<List<String>> languagesList = [
    ['English', 'en'],
    ['French', 'fr'],
    ['Korean', 'ko'],
    ['Portuguese', 'pt'],
    ['Spanish', 'es']
  ];

  void initState() {
    super.initState();
    // language = 'Korean';
    // languageCode = 'ko';
    deleteBool = false;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Title(
            color: Colors.amber,
            child: Row(children: [
              Text(language, style: TextStyle(fontSize: fontSize)),
              IconButton(
                  icon: Icon(Icons.language),
                  onPressed: () {
                    _showLanguages(context);
                  })
            ])),
        backgroundColor: Colors.amber,
        actions: <Widget>[
          selectPopupMenu(context, deleteBool),
        ],
      ),
      body: Column(children: [
        editScreen(context),
        new Expanded(child: voclist(context))
      ]),
      // body: voclist(context),
      bottomNavigationBar: BottomAppBar(
        child: _addRowDel(deleteBool),
      ),
      floatingActionButton: addButton(context, deleteBool),
    );
  }

// choose a language to learn
  _showLanguages(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.amber[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text('Choose a language'),
              content: SingleChildScrollView(
                  child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ListView.builder(
                            itemCount: languagesList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(languagesList[index][0]),
                                onTap: () {
                                  language = languagesList[index][0];
                                  languageCode = languagesList[index][1];

                                  getDatabase().whenComplete(() {
                                    getVocableList().whenComplete(() {
                                      setState(() {
                                        prefs.setString('language', language);
                                        prefs.setString(
                                            'languageCode', languageCode);
                                        Navigator.pop(context);
                                      });
                                    });
                                  });
                                },
                              );
                            }))
                  ])));
        });
  }

// flatbutton to add a vocable
  addButton(BuildContext context, bool delete) {
    if (delete == false) {
      return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.amber,
          onPressed: () async {
            await addVocable(context).whenComplete(() async {
              await getVocableList();
            });
            setState(() {});
          });
    } else {
      return Container();
    }
  }

// delete multiple files, export or import a database
  selectPopupMenu(BuildContext context, bool delete) {
    if (delete == false) {
      return PopupMenuButton(onSelected: (value) async {
        print(value);
        // if (value == 'add') {
        //   await addVocable(context);
        //   await getVocableList();
        //   deleteBool = false;
        // }

        if (value == 'delete') {
          deleteBool = true;
        } else if (value == 'export') {
          deleteBool = false;
          exportData(context);
        } else if (value == 'import') {
          deleteBool = false;
          importData();
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

// export database and save it in the Download file
  exportData(BuildContext context) {
    if (vocableList != null) {
      var data = <List>[];
      var keys = <String>[];
      var keyIndexMap = <String, int>{};

      int _addKey(String key) {
        var index = keys.length;
        keyIndexMap[key] = index;
        keys.add(key);
        for (var dataRow in data) {
          dataRow.add(null);
        }
        return index;
      }

//convert vocable list to csvList
      for (var map in vocableList) {
        var dataRow = List(keyIndexMap.length);
        map.forEach((key, value) {
          var keyIndex = keyIndexMap[key];
          if (keyIndex == null) {
            keyIndex = _addKey(key);
            dataRow = List.from(dataRow, growable: true)..add(value);
          } else {
            dataRow[keyIndex] = value;
          }
        });
        data.add(dataRow);
      }

      ListToCsvConverter converter = const ListToCsvConverter(fieldDelimiter: ';');
      String csvList = converter.convert(data);
      writeFile(csvList);
    }
  }

// save database in Download file
  writeFile(String csv) async {
    final dir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    final pathOfTheFileToWrite = dir + "/vocableData.csv";
    File file = File(pathOfTheFileToWrite);

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    file.writeAsString(csv);

    print(pathOfTheFileToWrite);

//share csv file 
    // await FlutterShare.shareFile(
    //   title: 'Export vocabulary',
    //   filePath: pathOfTheFileToWrite,
    // );
  }

// import a vocable list
  importData() async {
    List<List<dynamic>> dataList = [];

    File file = await FilePicker.getFile(
        allowedExtensions: ['csv'], type: FileType.custom);
    final csvInput = file.openRead();

// read csv file, transform to list
    csvInput.transform(utf8.decoder).transform(new LineSplitter()).listen(
        (String line) {
      List row = line.split(';');
      dataList.add(row);
    }, onDone: () {
      print('File is now closed.');
    }, onError: (e) {
      print(e.toString());
    });

// delete current database
    Database db = await database;
    await db.transaction((txn) async {
      var batch = txn.batch();
      batch.delete(languageCode);
      await batch.commit();
    });

    insertAll(dataList, db);
  }

// insert all lines of the csv file to the new database
  insertAll(List<List<dynamic>> data, Database db) async {
    for (var row in data) {
      print(row);
      await addVoc2Table(row[1], row[2], row[3], row[4]);
    }

    getVocableList().whenComplete(() {
      setState(() {});
    });
  }

// create vocable list
  Widget voclist(context) {
    SlidableController _slideControl;

    print(vocableList);
    if (vocableList != null) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: vocableList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return new Slidable(
                controller: _slideControl,
                secondaryActions: <Widget>[
                  IconSlideAction(
                      color: Colors.grey[350],
                      caption: 'Edit',
                      icon: Icons.edit,
                      onTap: () async {
                        await editVoc(context, index);
                        await getVocableList();
                        setState(() {});
                      }),
                  IconSlideAction(
                    color: Colors.red,
                    caption: 'Delete',
                    icon: Icons.delete,
                    onTap: () async {
                      await deleteVocableTable(vocableList[index]['id']);
                      await getVocableList();
                      setState(() {});
                    },
                  )
                ],
                actionPane: SlidableDrawerActionPane(),
                child: Card(
                  child: InkWell(
                    child: Container(
                      height: 110,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: withOrWithoutCheckbox(
                              deleteBool, index, context)),
                    ),
                    onTap: () {
                      print(index);
                      speakWord(vocableList[index]['translation']);
                      // setState(() async {
                      //   await editVoc(context, index);
                      //   await getVocableList();
                      // });
                    },
                  ),
                ));
          });
    }
    {
      return new Container();
    }
  }

//speak word to learn
  speakWord(String word) async {
    FlutterTts flutterTts = FlutterTts();
    flutterTts.setLanguage(languageCode);
    flutterTts.setPitch(1.0);
    await flutterTts.speak(word);
  }

  Widget editScreen(BuildContext context) {
    return Container();
  }

// adding checkbox for deleting vocables if delete has been pressed
  withOrWithoutCheckbox(bool delete, int index, BuildContext context) {
    if (delete == false) {
      return (<Widget>[
        Container(
            width: MediaQuery.of(context).size.width * 0.5 - 10,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(vocableList[index]['word'],
                  style: TextStyle(fontSize: 17),
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center),
              Text(vocableList[index]['wordNote'],
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey),textAlign: TextAlign.center)
            ])),
        Container(
            width: 10,
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: VerticalDivider(
              color: Colors.amber,
              thickness: 0.5,
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.5 - 10,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(vocableList[index]['translation'],
                  style: TextStyle(fontSize: 17),
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center),
              Text(vocableList[index]['translationNote'],
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                  textAlign: TextAlign.center)
            ]))
      ]);
    } else {
      if (select2del.length != vocableList.length) {
        select2del = List.filled(vocableList.length, false);
      }
      if (select2del.length > 0) {
        return (<Widget>[
          Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(vocableList[index]['word'],
                        style: TextStyle(fontSize: 17),
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center),
                    Text(vocableList[index]['wordNote'],
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                        textAlign: TextAlign.center)
                  ])),
          Container(
              width: 10,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: VerticalDivider(
                color: Colors.amber,
                thickness: 0.5,
              )),
          Container(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(vocableList[index]['translation'],
                        style: TextStyle(fontSize: 17),
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center),
                    Text(vocableList[index]['translationNote'],
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                        textAlign: TextAlign.center)
                  ])),
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

//cancel and delete options for deleting vocables at the bottom
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
                await getVocableList();
                setState(() {});
              },
              child: Text("delete"))
        ],
      );
    } else
      return Row();
  }

//dialog to add vocables
  Future<String> addVocable(BuildContext context) async {
    String word = '';
    String translation = '';
    String wordNote = '';
    String translationNote = '';

    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.amber[100],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text('Enter a new vocable'),
            content: SingleChildScrollView(
                child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(hintText: 'word'),
                  onChanged: (value) {
                    word = value;
                  },
                ),
                new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(hintText: 'note'),
                  onChanged: (value) {
                    wordNote = value;
                  },
                ),
                new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(hintText: 'translation'),
                  onChanged: (value) {
                    translation = value;
                  },
                ),
                new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(hintText: 'note'),
                  onChanged: (value) {
                    translationNote = value;
                  },
                )
              ],
            )),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () async {
                  await addVoc2Table(
                      word, wordNote, translation, translationNote);
                  Navigator.of(context).pop(word);
                },
              )
            ],
          );
        });
  }

// dialog to change existing vocables
  Future<String> editVoc(BuildContext context, int index) async {
    String word = vocableList[index]['word'];
    String translation = vocableList[index]['translation'];
    String wordNote = vocableList[index]['wordNote'];
    String translationNote = vocableList[index]['translationNote'];

    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.amber[100],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text('Edit a vocable'),
            content: SingleChildScrollView(
                child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new TextField(
                  controller: new TextEditingController(
                      text: vocableList[index]['word']),
                  autofocus: true,
                  decoration: new InputDecoration(hintText: 'word'),
                  onChanged: (value) {
                    word = value;
                  },
                ),
                new TextField(
                  controller: new TextEditingController(
                      text: vocableList[index]['wordNote']),
                  autofocus: true,
                  decoration: new InputDecoration(hintText: 'note'),
                  onChanged: (value) {
                    wordNote = value;
                  },
                ),
                new TextField(
                  controller: new TextEditingController(
                      text: vocableList[index]['translation']),
                  autofocus: true,
                  decoration: new InputDecoration(hintText: 'translation'),
                  onChanged: (value) {
                    translation = value;
                  },
                ),
                new TextField(
                  controller: new TextEditingController(
                      text: vocableList[index]['translationNote']),
                  autofocus: true,
                  decoration: new InputDecoration(hintText: 'note'),
                  onChanged: (value) {
                    translationNote = value;
                  },
                )
              ],
            )),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () async {
                  Navigator.of(context).pop(word);
                  await updateVocableTable(VocableTable(
                      id: vocableList[index]['id'],
                      word: word,
                      wordNote: wordNote,
                      translation: translation,
                      translationNote: translationNote,
                      section: vocableList[index]['section']));
                  // await getVocableList();
                },
              )
            ],
          );
        });
  }

//adding vocable to the databases
  addVoc2Table(vocab, vocabNote, transl, translNote) async {
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

    var voc = VocableTable(
        id: index,
        word: vocab,
        wordNote: vocabNote,
        translation: transl,
        translationNote: translNote,
        section: 1);

    await insertVocable(voc);
  }

  //get vocable list of current language
  getVocableList() async {
    Database db = await database;

    vocableList = await db.query(languageCode);
    print(await vocable());
  }

//get ids of vocable list of current language
  getVocableListId() async {
    Database db = await database;
    idList = [];
    vocableList = await db.query(languageCode);

    for (int i = 0; i < vocableList.length; i++) {
      idList.add(vocableList[i]['id']);
    }
    return idList;
  }

//get vocable list of chosen sections
  getvocableLearnList() async {
    Database db = await database;
    print(sectionNum);
    vocableLearnList = await db.query(languageCode,
        where: 'section IN (?,?,?,?,?)', whereArgs: sectionNum);

    print(vocableLearnList);
  }
}