import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vocabulary/global_vars.dart';
import 'package:vocabulary/learn/enterAnswer.dart';
import 'package:vocabulary/learn/lettersOrder.dart';
import 'package:vocabulary/learn/multiChoice.dart';
import 'package:vocabulary/learn/start_endScreen.dart';
import 'package:vocabulary/vocabulary/vocable.dart';
import 'dart:math';

//begin learning
class Learn extends StatefulWidget {
  @override
  LearnState createState() => LearnState();
}

class LearnState extends State<Learn> {
  bool answered = false;
  List<int> questionList = [];
  List<int> multChoiceList = [];
  List<String> lettersList = [];
  int questionId;
  int wordOrtransl;
  List<Color> dynColor = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white
  ];
  List<int> correctCounter;
  //bool newSession = true;
  String answerMode;
  String questionMode;
  bool newSession = true;
  double progressvalue;
  int progresscounter;
  int vocablenumber;
  double addprogress;
  int counter;
  //List<bool> chosenSectionList;
  ListVocabState vocListObj = new ListVocabState();

  @override
  void initState() {
    super.initState();
    rebuildScreen = false;
    counter = -1;

    showSettings = true;
    progressvalue = 0.0;
    progresscounter = 0;

    vocListObj.getvocableLearnList().whenComplete(() {
      setState(() {
        print("init");
      });
    });
  }

  void callbackSettings() {
    setState(() {
      progressvalue = 0.0;
      newSession = true;
      progresscounter = 0;
      showSettings = true;
      correctCounter = [];
      questionList = [];
      Navigator.pop(context);
    });
  }

  //setstate from other class
  void callback() {
    setState(() {
      progressvalue = 0.0;
      newSession = true;
      showSettings = true;
      progresscounter = 0;
      correctCounter = [];
      questionList = [];
    });
  }

  void callbackSet() {
    setState(() {
      if (newSession == false) {
        print(progressvalue);
        progressvalue += addprogress;
        print(progressvalue);
      }
   
      newSession = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (rebuildScreen && !newSession) {
      rebuildScreen = false;
      callback();
    }
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
          title: Text(language, style: TextStyle(fontSize: fontSize)),
          backgroundColor: Colors.amber,
          actions: _actionWidgets()),
      body: getlearnoption(context),
    );
  }

//   }
  List<Widget> _actionWidgets() {
    if (showSettings == true) {
      return [
        RaisedButton(
            color: Colors.amber,
            child: Icon(
              Icons.settings,
            ),
            onPressed: () {
              _settings(context);
            })
      ];
    } else
      return [];
  }

  Future _settings(BuildContext context) {
    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              actions: <Widget>[
                RaisedButton(
                    child: Text('Ok'),
                    onPressed: () {
                      callbackSettings();
                    })
              ],
              title: Title(
                  color: Colors.amber,
                  child:
                      Text('Settings', style: TextStyle(color: Colors.black))),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(children: <Widget>[
                        Text('section 1'),
                        Container(
                            padding: EdgeInsets.only(left: 50.0),
                            child: Checkbox(
                                value: chosenSectionList[0],
                                onChanged: (value) {
                                  chosenSectionList[0] = !chosenSectionList[0];

                                  if (chosenSectionList[0] == true) {
                                    if (!sectionNum.contains(1)) {
                                      sectionNum.add(1);
                                    }
                                  } else {
                                    if (sectionNum.contains(1)) {
                                      sectionNum.remove(1);
                                    }
                                  }
                                  vocListObj
                                      .getvocableLearnList()
                                      .whenComplete(() {
                                    setState(() {});
                                  });
                                }))
                      ]),
                      Row(children: <Widget>[
                        Text('section 2'),
                        Container(
                            padding: EdgeInsets.only(left: 50.0),
                            child: Checkbox(
                                value: chosenSectionList[1],
                                onChanged: (value) {
                                  chosenSectionList[1] = !chosenSectionList[1];
                                  if (chosenSectionList[1] == true) {
                                    if (!sectionNum.contains(2)) {
                                      sectionNum.add(2);
                                    }
                                  } else {
                                    if (sectionNum.contains(2)) {
                                      sectionNum.remove(2);
                                    }
                                  }
                                  vocListObj
                                      .getvocableLearnList()
                                      .whenComplete(() {
                                    setState(() {});
                                  });
                                }))
                      ]),
                      Row(children: <Widget>[
                        Text('section 3'),
                        Container(
                            padding: EdgeInsets.only(left: 50.0),
                            child: Checkbox(
                                value: chosenSectionList[2],
                                onChanged: (value) {
                                  chosenSectionList[2] = !chosenSectionList[2];
                                  if (chosenSectionList[2] == true) {
                                    if (!sectionNum.contains(3)) {
                                      sectionNum.add(3);
                                    }
                                  } else {
                                    if (sectionNum.contains(3)) {
                                      sectionNum.remove(3);
                                    }
                                  }
                                  vocListObj
                                      .getvocableLearnList()
                                      .whenComplete(() {
                                    setState(() {});
                                  });
                                }))
                      ]),
                      Row(children: <Widget>[
                        Text('section 4'),
                        Container(
                            padding: EdgeInsets.only(left: 50.0),
                            child: Checkbox(
                                value: chosenSectionList[3],
                                onChanged: (value) {
                                  chosenSectionList[3] = !chosenSectionList[3];
                                  if (chosenSectionList[2] == true) {
                                    if (!sectionNum.contains(4)) {
                                      sectionNum.add(4);
                                    }
                                  } else {
                                    if (sectionNum.contains(4)) {
                                      sectionNum.remove(4);
                                    }
                                  }
                                  vocListObj
                                      .getvocableLearnList()
                                      .whenComplete(() {
                                    setState(() {});
                                  });
                                }))
                      ]),
                      Row(children: <Widget>[
                        Text('section 5'),
                        Container(
                            padding: EdgeInsets.only(left: 50.0),
                            child: Checkbox(
                                value: chosenSectionList[4],
                                onChanged: (value) {
                                  chosenSectionList[4] = !chosenSectionList[4];
                                  if (chosenSectionList[4] == true) {
                                    if (!sectionNum.contains(5)) {
                                      sectionNum.add(5);
                                    }
                                  } else {
                                    if (sectionNum.contains(5)) {
                                      sectionNum.remove(5);
                                    }
                                  }
                                  vocListObj
                                      .getvocableLearnList()
                                      .whenComplete(() {
                                    setState(() {});
                                  });
                                }))
                      ])
                    ],
                  )
                ],
              ),
            );
          });
        });
  }

  Widget getlearnoption(BuildContext context) {
    if (vocableLearnList != null) {
      if (vocableLearnList.length > 9) {
        vocablenumber = 10;
      } else {
        vocablenumber = vocableLearnList.length;
      }
      addprogress = 1 / (3 * vocablenumber);
      print('vocablenumber $vocablenumber');
      print(vocableLearnList);
      if (vocableLearnList.length <= 3) {
        showSettings = true;
        return new Center(
            child: Text(
          "There are not enough vocables to start learning. At least 4 vocables are needed.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15.0),
        ));
      } else {
        Random rnd = new Random();
        vocListObj.getVocableLearnListId();

        while (questionList.length < vocablenumber) {
          int question = rnd.nextInt(vocableLearnList.length);
          if (!questionList.contains(question)) {
            questionList.add(question);
          }
        }
        questionId = questionList[0];

        print(questionId);
        print(questionList);
        wordOrtransl = rnd.nextInt(2);

        if (wordOrtransl == 0) {
          answerMode = 'word';
          questionMode = 'translation';
        } else {
          answerMode = 'translation';
          questionMode = 'word';
        }

        return learn(context);
      }
    } else {
      return new Container();
    }
  }

// each vocable will be learned with the 3 learning options
  learn(BuildContext context) {
    print(counter);
    print(newSession);
    if (newSession == true) {
      counter = -1;
      correctCounter = List.filled(vocablenumber, 0);
      showSettings = true;
      return new StartLearning(callbackSet);
    } else {
      progresscounter += 1;
      showSettings = false;
      print('progresscounter $progresscounter');
      if (progresscounter <= vocablenumber) {
        counter += 1;
        print('$questionList, $counter');
        return new MultChoiceCl(questionList[counter], counter, answerMode,
            questionMode, callbackSet, correctCounter, progressvalue);
      } else if (progresscounter <= vocablenumber * 2) {
        if (counter == vocablenumber - 1) {
          counter = -1;
        }
        counter += 1;
        return new LettersOrder(questionList[counter], counter, 'translation',
            'word', callbackSet, correctCounter, progressvalue);
      } else if (progresscounter <= vocablenumber * 3) {
        if (counter == vocablenumber - 1) {
          counter = -1;
        }
        counter += 1;
        return new EnterAnswerCl(questionList[counter], counter, 'translation',
            'word', callbackSet, correctCounter, progressvalue);
      } else {
        List<int> overviewAns = countCorrectAns();
        return new EndLearn(callback, overviewAns, correctCounter, questionList,counter);
      }
    }
  }

  List<int> countCorrectAns() {
    int counterPos = 0;
    int counterWrong = 0;

    for (var i = 0; i < correctCounter.length; i++) {
      counterPos += correctCounter[i];
    }
    print(counterPos);

    counterWrong = vocablenumber * 3 - counterPos;
    return [counterPos, counterWrong];
  }
}
