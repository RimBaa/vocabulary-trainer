import 'package:flutter/material.dart';
import 'package:vocabulary/global_vars.dart';
import 'package:vocabulary/vocabulary/database.dart';
import 'package:vocabulary/vocabulary/vocable.dart';

class StartLearning extends StatefulWidget {
  final Function callback;

  StartLearning(this.callback);

  @override
  StartLearningState createState() => StartLearningState();
}

class StartLearningState extends State<StartLearning> {
  int iconCounter;
  ListVocabState vocListObj = new ListVocabState();

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
  final List<int> correctCounter;
  final List<int> questionList;
  final int counter;

  EndLearn(this.callback, this.counterAns, this.correctCounter,
      this.questionList, this.counter);

  @override
  EndLearnState createState() => EndLearnState();
}

class EndLearnState extends State<EndLearn> {
  ListVocabState vocListObj = new ListVocabState();

  @override
  Widget build(BuildContext context) {
    int correctAns = widget.counterAns[0];
    int wrongAns = widget.counterAns[1];

    print(widget.correctCounter);
    print(widget.questionList);
    print(widget.counter);

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
                    updateSections();
                  })
            ])));
  }

    // //update sections 
    // if a question has been answered correctly 3 times, it will be added to the next higher section
    // if a question has been aswered correctly only once, it will be put to a lower section
  updateSections() async {
    for (int count = 0; count < widget.questionList.length; count++) {
      if (vocableLearnList[widget.questionList[count]]['section'] < 5 &&
          widget.correctCounter[count] == 3) {
        await updateVocableTable(VocableTable(
            id: vocableLearnList[widget.questionList[count]]['id'],
            wordNote: vocableLearnList[widget.questionList[count]]['wordNote'],
            translationNote: vocableLearnList[widget.questionList[count]]
                ['translationNote'],
            section:
                vocableLearnList[widget.questionList[count]]['section'] + 1,
            translation: vocableLearnList[widget.questionList[count]]
                ['translation'],
            word: vocableLearnList[widget.questionList[count]]['word']));
      }
      if (widget.correctCounter[count] < 2 &&
          vocableLearnList[widget.questionList[count]]['section'] > 1) {
        await updateVocableTable(VocableTable(
            id: vocableLearnList[widget.questionList[count]]['id'],
            wordNote: vocableLearnList[widget.questionList[count]]['wordNote'],
            translationNote: vocableLearnList[widget.questionList[count]]
                ['translationNote'],
            section:
                vocableLearnList[widget.questionList[count]]['section'] - 1,
            translation: vocableLearnList[widget.questionList[count]]
                ['translation'],
            word: vocableLearnList[widget.questionList[count]]['word']));
      }
    }
    await vocListObj.getvocableLearnList();
    widget.callback();
  }
}
