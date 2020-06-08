import 'package:flutter/material.dart';
import 'global_vars.dart';

class Sections extends StatefulWidget{
  @override
  _Sections createState() => _Sections();
}

class _Sections extends State<Sections>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("sections", style: TextStyle(fontSize: fontSize, color: Colors.white)),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
