import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

SharedPreferences prefs;

const fontSize = 18.0;

 ListView chooseLang;
 var database;
 int dbSize;
 List listTables;
List vocableList;
String dbName = 'vocTable';
List select2del = [];
List<int> idList = [];
bool direction = true; // true -> ask translation, false -> aks word  
String languageCode;
String language;