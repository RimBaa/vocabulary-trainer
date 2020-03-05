import 'package:flutter/material.dart';
import 'package:vocabulary/global_vars.dart';
import 'package:vocabulary/vocable.dart';


//adding a new language
Future<String> addlanguage(BuildContext context) async {
  String lang = '';
  return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter a new language'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(labelText: 'language'),
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
                currentlanguage = lang;
              },
            )
          ],
        );
      });
}

//change current lang. in SharedPrefs.
setCurrentLanguage(language) async {
  await prefs.setString(keylanguage, language);
  getDatabase();
}

//adapt list of languages in SharedPrefs.
setLanguageList() async {
  await prefs.setStringList(keylanguageList, languages);
}

removeLanguage(language) {
  if (language == currentlanguage) {}

  languages.remove(language);
  setLanguageList();
}

changeCurrentLanguage(language) {
  currentlanguage = language;
  setCurrentLanguage(language);
  getCurrentDatabase().whenComplete(
    getVocableList()
  );
  
  
}

class ListLang extends StatefulWidget{
  @override
  _ListLang createState() => _ListLang();
}

class _ListLang extends State<ListLang>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("list of languages", style: TextStyle(fontSize: fontSize, color: Colors.white)),
        backgroundColor: Colors.blue,
        actions: <Widget>[
           Container(padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),child: Text(currentlanguage, textAlign: TextAlign.left, style:TextStyle(fontSize: fontSize))),
        ],
      ),
      body: listofLang(context),
    );
  }

Widget listofLang(context){
  return new ListView.builder(itemCount: languages.length,
  itemBuilder: (BuildContext context, index){
    return Container(
       decoration: BoxDecoration(
                border: Border(bottom: BorderSide()),
              ),
      child: ListTile(
      title: Text(languages[index], style: TextStyle(fontSize: fontSize)),
      onTap: (){
        changeCurrentLanguage(languages[index]);
        setState(() {    
        });
      },
    ));

  });
  
}

}