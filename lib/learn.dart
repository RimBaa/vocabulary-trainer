import 'dart:async';

import 'package:flutter/material.dart';
import 'global_vars.dart';
import 'dart:math';
import 'vocable.dart';

//begin learning
class Learn extends StatefulWidget {
  @override
  LearnState createState() => LearnState();
}

class LearnState extends State<Learn> {
  bool answered = false;
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
  bool newSession = true;
  String answerMode;
  String questionMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("learn",
            style: TextStyle(fontSize: fontSize, color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: showVoc(context),
    );
  }

// choose a word to ask
  Widget showVoc(BuildContext context) {
    if (answered == false) {
      ListVocabState vocListObj = new ListVocabState();

      return FutureBuilder(
          future: vocListObj.getVocableList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (vocableList.length == 0) {
                return new Container(
                    width: 150,
                    height: 150,
                    child: Text("There are no vocables to learn"));
              } else {
                if (newSession == true) {
                  correctCounter = List.filled(vocableList.length, 0);
                  newSession = false;
                }
                Random rnd = new Random();
                questionId = rnd.nextInt(vocableList.length);
                print(questionId);

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
              return CircularProgressIndicator();
            }
          });
    } else {
      return learn(context);
    }
  }

// one of three learn options
  learn(BuildContext context) {
    //multiple choice with 4 options
    if (vocableList[questionId]['section'] >= 2 && vocableList.length > 3) {
      return multipleChoice();
    } else if (vocableList[questionId]['section'] >= 1) {
    
              
          //       Navigator.of(context).push(MaterialPageRoute(
          // builder: (context) =>
          //     LettersOrder(questionId, questionMode, answerMode)));
      return letterOrder();
    } else if (vocableList[questionId]['section'] == 3) {
      return Column();
    }
  }

// create page body with multiple choice
// after 6 correct answers section will be updated till section 3
  Widget multipleChoice() {
    Timer timer;
    int section = 1;

    if (answered == false) {
      multChoiceList = [];
      dynColor = [Colors.white, Colors.white, Colors.white, Colors.white];
      int randNumb;
      Random rnd = new Random();
      multChoiceList.add(questionId);
      while (multChoiceList.length < 4) {
        randNumb = rnd.nextInt(vocableList.length);

        if (!multChoiceList.contains(randNumb)) {
          multChoiceList.add(randNumb);
        }
      }

      multChoiceList.shuffle();
      section = vocableList[questionId]['section'];
    } else {
      answered = false;
      timer = new Timer.periodic(
          Duration(seconds: 1),
          (Timer t) => setState(() {
                timer.cancel();
              }));
    }

    int idPosition = multChoiceList.indexOf(questionId);

    print(multChoiceList);
    print(vocableList);
    print(vocableList[questionId]);
    print(correctCounter);

    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(10),
            height: 100,
            child: Row(
              children: <Widget>[
                Text(vocableList[questionId][questionMode],
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              ],
            )),
        Container(
            height: 450,
            child: GridView.count(
              crossAxisCount: 2,
              children: <Widget>[
                Card(
                    color: dynColor[0],
                    child: InkWell(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              vocableList[multChoiceList[0]][answerMode],
                              style: TextStyle(fontSize: 20),
                            )
                          ]),
                      onTap: () async {
                        if (questionId == multChoiceList[0]) {
                          dynColor[0] = Colors.greenAccent;
                          if (section < 3 && correctCounter[questionId] == 5) {
                            correctCounter[questionId] = 0;
                            await updateVocableTable(VocableTable(
                                id: vocableList[questionId]['id'],
                                section: section + 1,
                                translation: vocableList[questionId]
                                    ['translation'],
                                word: vocableList[questionId]['word']));
                          } else {
                            correctCounter[questionId] =
                                correctCounter[questionId] + 1;
                          }
                        } else {
                          dynColor[0] = Colors.redAccent;
                          dynColor[idPosition] = Colors.greenAccent;
                        }
                        setState(() {
                          answered = true;
                        });
                      },
                    )),
                Card(
                    color: dynColor[1],
                    child: InkWell(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              vocableList[multChoiceList[1]][answerMode],
                              style: TextStyle(fontSize: 20),
                            )
                          ]),
                      onTap: () async {
                        if (questionId == multChoiceList[1]) {
                          dynColor[1] = Colors.greenAccent;
                          if (section < 3 && correctCounter[questionId] == 5) {
                            correctCounter[questionId] = 0;
                            await updateVocableTable(VocableTable(
                                id: vocableList[questionId]['id'],
                                section: section + 1,
                                translation: vocableList[questionId]
                                    ['translation'],
                                word: vocableList[questionId]['word']));
                          } else {
                            correctCounter[questionId] =
                                correctCounter[questionId] + 1;
                          }
                        } else {
                          dynColor[1] = Colors.redAccent;
                          dynColor[idPosition] = Colors.greenAccent;
                        }
                        setState(() {
                          answered = true;
                        });
                      },
                    )),
                Card(
                    color: dynColor[2],
                    child: InkWell(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              vocableList[multChoiceList[2]][answerMode],
                              style: TextStyle(fontSize: 20),
                            )
                          ]),
                      onTap: () async {
                        if (questionId == multChoiceList[2]) {
                          dynColor[2] = Colors.greenAccent;
                          if (section < 3 && correctCounter[questionId] == 5) {
                            correctCounter[questionId] = 0;
                            await updateVocableTable(VocableTable(
                                id: vocableList[questionId]['id'],
                                section: section + 1,
                                translation: vocableList[questionId]
                                    ['translation'],
                                word: vocableList[questionId]['word']));
                          } else {
                            correctCounter[questionId] =
                                correctCounter[questionId] + 1;
                          }
                        } else {
                          dynColor[2] = Colors.redAccent;
                          dynColor[idPosition] = Colors.greenAccent;
                        }
                        setState(() {
                          answered = true;
                        });
                      },
                    )),
                Card(
                    color: dynColor[3],
                    child: InkWell(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              vocableList[multChoiceList[3]][answerMode],
                              style: TextStyle(fontSize: 20),
                            )
                          ]),
                      onTap: () async {
                        if (questionId == multChoiceList[3]) {
                          dynColor[3] = Colors.greenAccent;
                          if (section < 3 && correctCounter[questionId] == 5) {
                            correctCounter[questionId] = 0;
                            await updateVocableTable(VocableTable(
                                id: vocableList[questionId]['id'],
                                section: section + 1,
                                translation: vocableList[questionId]
                                    ['translation'],
                                word: vocableList[questionId]['word']));
                          } else {
                            correctCounter[questionId] =
                                correctCounter[questionId] + 1;
                          }
                        } else {
                          dynColor[3] = Colors.redAccent;
                          dynColor[idPosition] = Colors.greenAccent;
                        }
                        setState(() {
                          answered = true;
                        });
                      },
                    )),
              ],
            ))
      ],
    );
  }

 //LetterOrder
  Widget letterOrder() {
    String answer = vocableList[questionId][answerMode];

    if (answered == false) {
      lettersList = [];
      lettersList = answer.split('');
      print(lettersList);
    }

    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(10),
            height: 200,
            child: Row(children: <Widget>[
              Text(vocableList[questionId][questionMode],
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ])),
        Container(
            padding: EdgeInsets.all(10),
            height: 200,
            child: Row(
              children: <Widget>[],
            )),
        Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: List<Widget>.generate(
                lettersList.length,
                (index) => ActionChip(
                      label: Text(lettersList[index]),
                      onPressed: () {
                        lettersList.removeAt(index);
                        setState(() {});
                      },
                    )))
      ],
    );
  }



}

class LettersOrder extends StatefulWidget {
// bool answered = false;
  final int questionId;
  final String answerMode;
  final String questionMode;

  const LettersOrder(this.questionId, this.answerMode, this.questionMode);

  @override
  LettersOrderState createState() => LettersOrderState();
}

class LettersOrderState extends State<LettersOrder> {
  // bool answered = false;
  bool answered;
  List<String> lettersList;

//LettersOrderState(int questionId, String answerMode, String questionMode, bool answered);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("learn",
            style: TextStyle(fontSize: fontSize, color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: letterOrder(),
    );
  }

  //LetterOrder
  Widget letterOrder() {
    String answer = vocableList[widget.questionId][widget.answerMode];

    if (answered == false) {
      lettersList = [];
      lettersList = answer.split('');
      print(lettersList);
    }

    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(10),
            height: 200,
            child: Row(children: <Widget>[
              Text(vocableList[widget.questionId][widget.questionMode],
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ])),
        Container(
            padding: EdgeInsets.all(10),
            height: 200,
            child: Row(
              children: <Widget>[],
            )),
        Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: List<Widget>.generate(
                lettersList.length,
                (index) => ActionChip(
                      label: Text(lettersList[index]),
                      onPressed: () {
                        lettersList.removeAt(index);
                        setState(() {});
                      },
                    )))
      ],
    );
  }
}

//learn options
class LearnOptions extends StatefulWidget {
  @override
  _LearnOptions createState() => _LearnOptions();
}

class _LearnOptions extends State<LearnOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("learning options",
            style: TextStyle(fontSize: fontSize, color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
