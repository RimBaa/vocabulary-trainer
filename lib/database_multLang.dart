// //database methods
// Future<void> insertVocable(VocableTable vocable, String table) async {
//   Database db;
//   if (table == 'firstLang') {
//     db = await database;
//   } else {
//     db = await databaseLearn;
//   }
//   await db.insert(table, vocable.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace);
// }

// Future<List<VocableTable>> vocable(String table) async {
//   Database db;
//   if (table == 'firstLang') {
//     db = await database;
//   } else {
//     db = await databaseLearn;
//   }

//   final List<Map<String, dynamic>> maps = await db.query(table);
//   dbSize = maps.length;
//   return List.generate(maps.length, (i) {
//     return VocableTable(
//         id: maps[i]['id'], word: maps[i]['word'], section: maps[i]['section']);
//   });
// }

// Future<void> updateVocableTable(VocableTable vocable, String table) async {
//   Database db;
//   if (table == 'firstLang') {
//     db = await database;
//   } else {
//     db = await databaseLearn;
//   }
//   await db
//       .update(table, vocable.toMap(), where: "id = ?", whereArgs: [vocable.id]);
// }

// Future<void> deleteVocableTable(int id, String table) async {
//   Database db;
//   if (table == 'firstLang') {
//     db = await database;
//   } else {
//     db = await databaseLearn;
//   }

//   await db.delete(table, where: "id = ?", whereArgs: [id]);
// }

// // getDatabase() async{
// // final datab = openDatabase(join(await getDatabasesPath(), 'firstLang.db'),
// //           onCreate: (db, version){
// //             return db.execute(
// //               "CREATE TABLE firstLang(id INTEGER PRIMARY KEY, word TEXT, section INTEGER)"
// //             );
// //           },
// //           version: 1
// //          );
// //   database = datab;

// //   for(int i= 0; i< languages.length ; i++){
// //     String name = languages[i];
// //     listTables[i] = openDatabase(join(await getDatabasesPath(), languages[i]+'.db'),
// //           onCreate: (db, version){
// //             return db.execute(
// //               "CREATE TABLE $name(id INTEGER PRIMARY KEY, word TEXT, section INTEGER)"
// //             );
// //           },
// //           version: 1
// //          );

// //   }
// // }

// getDatabase() async {
//   database = openDatabase(join(await getDatabasesPath(), 'firstLang.db'),
//       onCreate: (db, version) {
//     return db.execute(
//         "CREATE TABLE firstLang(id INTEGER PRIMARY KEY, word TEXT, section INTEGER)");
//   }, version: 1);
//   //database = datab;
//   String databasename = currentlanguage + '.db';

//   if (currentlanguage != '0') {
//     databaseLearn = openDatabase(join(await getDatabasesPath(), databasename),
//         onCreate: (db, version) {
//       return db.execute(
//           "CREATE TABLE $currentlanguage(id INTEGER PRIMARY KEY, word TEXT, section INTEGER)");
//     }, version: 1);
//   }

//   // databaseLearn = databaselearn;
// }

// getCurrentDatabase() async {
//   if (currentlanguage != '0') {
//     String databasename = currentlanguage + '.db';
//     databaseLearn = openDatabase(join(await getDatabasesPath(), databasename),
//         onCreate: (db, version) {
//       return db.execute(
//           "CREATE TABLE $currentlanguage(id INTEGER PRIMARY KEY, word TEXT, section INTEGER)");
//     }, version: 1);
//   }
// }

// class VocableTable {
//   final int id;
//   final String word;
//   final int section;

//   VocableTable({this.id, this.word, this.section});

//   Map<String, dynamic> toMap() {
//     return {'id': id, 'word': word, 'section': section};
//   }

//   @override
//   String toString() {
//     return '[$id, $word, $section]';
//   }
// }
