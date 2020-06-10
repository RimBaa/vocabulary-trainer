import 'package:flutter/material.dart';
import 'package:vocabulary/global_vars.dart';
import 'vocable.dart';
import 'learn.dart';
//import 'language.dart';
import 'section.dart';

createDrawer(context) {
  const List<String> settings = [
    "languages",
    "vocabulary",
    "sections",
    "learn"
  ];

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 100.0,
          child: DrawerHeader(
            child: Text("vocabulary trainer",
                style: TextStyle(fontSize: fontSize, color: Colors.white)),
            decoration: BoxDecoration(color: Colors.blue),
          ),
        ),
        // ListTile(
        //   contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        //   title: Text(settings[0], style: TextStyle(fontSize: fontSize)),
        //   onTap: () {
        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (context) => ListLang()));
        //   },
        // ),
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          title: Text(settings[1], style: TextStyle(fontSize: fontSize)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ListVocab()));
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          title: Text(settings[2], style: TextStyle(fontSize: fontSize)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Sections()));
          },
        ),
       
      ],
    ),
  );
}
