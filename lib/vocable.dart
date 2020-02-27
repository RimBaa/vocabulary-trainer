import 'package:flutter/material.dart';
import 'package:vocabulary/global_vars.dart';

Future<String> addVocable(BuildContext context) async {
  String lang = '';
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
                  lang = value;
                },
              )),
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(labelText: 'translation'),
                onChanged: (value) {
                  lang = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(lang);
              },
            )
          ],
        );
      });
}

class ListVocab extends StatefulWidget{
  @override
  _ListVocab createState() => _ListVocab();
}

class _ListVocab extends State<ListVocab>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("list of vocabulary", style: TextStyle(fontSize: fontSize, color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
    );
  }
}