import 'package:flutter/material.dart';
import 'global_vars.dart';

class Sections extends StatefulWidget {
  @override
  _Sections createState() => _Sections();
}

class _Sections extends State<Sections> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sections",
            style: TextStyle(fontSize: fontSize, color: Colors.white)),
        backgroundColor: Colors.amber,
      ),
      body: sections(context),
    );
  }

  Widget sections(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
            title: Text('Section 1'),
            onTap: () {
              sectionList(1);
            }),
        ListTile(
            title: Text('Section 2'),
            onTap: () {
              sectionList(2);
            }),
        ListTile(
            title: Text('Section 3'),
            onTap: () {
              sectionList(3);
            })
      ],
    );
  }

  sectionList(int sectionNum) {
   Navigator.push(
                context, MaterialPageRoute(builder: (context) => SectionList(sectionNum)));
  }
}

class SectionList extends StatelessWidget{

SectionList(int sectionNum);

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text("sections",
            style: TextStyle(fontSize: fontSize, color: Colors.white)),
        backgroundColor: Colors.amber,
      ),
      body: sectionList(context),
    );
  }

Widget sectionList(context){
  return Column();
}

}
