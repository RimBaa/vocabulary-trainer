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
List<int> idLearnList = [];
String languageCode;
String language;
List<bool> chosenSectionList;


bool direction = true; // true -> ask translation, false -> aks word