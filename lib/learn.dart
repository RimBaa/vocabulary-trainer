import 'package:flutter/material.dart';
import 'global_vars.dart';

class Learn extends StatefulWidget{
  @override
  _Learn createState() => _Learn();
}

class _Learn extends State<Learn>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("learning options", style: TextStyle(fontSize: fontSize, color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
    );
  }
}