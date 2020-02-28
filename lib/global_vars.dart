import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

SharedPreferences prefs;
String currentlanguage = "0";
const fontSize = 18.0;
List<String>languages;
final String keylanguageList = "languagesList";
final String keylanguage = "currentLanguage";
 ListView chooseLang;
 var database;
 int dbSize;
 List listTables;