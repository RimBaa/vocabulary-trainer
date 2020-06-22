import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;
const fontSize = 18.0;
var database;
int dbSize;
List vocableList;
List vocableLearnList;
List<int> sectionNum;
bool showSettings;
bool rebuildScreen;
List select2del = [];
List<int> idList = [];
String languageCode;
String language;


bool direction = true; // true -> ask translation, false -> aks word