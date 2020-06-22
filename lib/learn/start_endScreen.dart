import 'package:flutter/material.dart';
import 'package:vocabulary/global_vars.dart';

class StartLearning extends StatefulWidget {
  final Function callback;

  StartLearning(this.callback);

  @override
  StartLearningState createState() => StartLearningState();
}

class StartLearningState extends State<StartLearning> {
  int iconCounter;

  @override
  void initState() {
    iconCounter = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: RaisedButton(
              padding: EdgeInsets.all(26),
              color: Colors.amber[400],
              child: Text('start learning', style: TextStyle(fontSize: 25)),
              onPressed: () {
                showSettings = false;
                widget.callback();
              }),
        ));
  }
}

class EndLearn extends StatefulWidget {
  final Function callback;
  final List<int> counterAns;

  EndLearn(this.callback, this.counterAns);

  @override
  EndLearnState createState() => EndLearnState();
}

class EndLearnState extends State<EndLearn> {
  @override
  Widget build(BuildContext context) {
    int correctAns = widget.counterAns[0];
    int wrongAns = widget.counterAns[1];

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: Column(children: <Widget>[
              Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.3),
                  child: Text(
                    'correct answers: $correctAns',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )),
              Container(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Text('wrongs answers: $wrongAns',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
              RaisedButton(
                  padding: EdgeInsets.all(10),
                  color: Colors.amber[400],
                  child: Text('Done',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  onPressed: () {
                    widget.callback();
                  })
            ])));
  }
}