import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

SharedPreferences prefs;

const fontSize = 18.0;

 ListView chooseLang;
 var database;
 int dbSize;
 List listTables;
List vocableList;
String dbName = 'vocTable';
List select2del = [];