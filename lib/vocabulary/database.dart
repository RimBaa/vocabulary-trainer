import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vocabulary/global_vars.dart';

//database methods
Future<void> insertVocable(VocableTable vocable) async {
  Database db;

  db = await database;

  await db.insert(languageCode, vocable.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore);
}

Future<List<VocableTable>> vocable() async {
  Database db;

  db = await database;

  final List<Map<String, dynamic>> maps = await db.query(languageCode);
  dbSize = maps.length;
  return List.generate(maps.length, (i) {
    return VocableTable(
        id: maps[i]['id'],
        word: maps[i]['word'],
        wordNote: maps[i]['wordNote'],
        translation: maps[i]['translation'],
        translationNote: maps[i]['translationNote'],
        section: maps[i]['section']);
  });
}

Future<void> updateVocableTable(VocableTable vocable) async {
  Database db;

  db = await database;

  await db.update(languageCode, vocable.toMap(),
      where: "id = ?", whereArgs: [vocable.id]);
}

Future<void> deleteVocableTable(int id) async {
  Database db;
  db = await database;

  await db.delete(languageCode, where: "id = ?", whereArgs: [id]);
}

getDatabase() async {
  String databasename = languageCode + '.db';

  database = openDatabase(join(await getDatabasesPath(), databasename),
      onCreate: (db, version) {
    return db.execute(
        "CREATE TABLE $languageCode(id INTEGER PRIMARY KEY, word TEXT, wordNote TEXT, translation TEXT, translationNote TEXT, section INTEGER)");
  }, version: 1);
}

class VocableTable {
  final int id;
  final String word;
  final String translation;
  final String wordNote;
  final String translationNote;
  final int section;

  VocableTable(
      {this.id,
      this.word,
      this.wordNote,
      this.translation,
      this.translationNote,
      this.section});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'wordnote': wordNote,
      'translation': translation,
      'translationnote': translationNote,
      'section': section
    };
  }

  @override
  String toString() {
    return '[$id, $word, $wordNote, $translation, $translationNote, $section]';
  }
}

//settings for popup menu vocable list
class VocSettings {
  static String del = "delete";
  static String export = "export";
  static String import = "import";
  // static String add = "add";

  static List<String> editVoc = <String>[del, export, import];
}
