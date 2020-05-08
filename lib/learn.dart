import 'dart:async';

import 'package:flutter/material.dart';
import 'global_vars.dart';
import 'dart:math';
import 'vocable.dart';

//begin learning
class Learn extends StatefulWidget {
  @override
  _Learn createState() => _Learn();
}

class _Learn extends State<Learn> {
  bool answered = false;
  List<int> multChoiceIdList = [];
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

// choose a word to test
  Widget showVoc(BuildContext context) {
    if (answered == false) {
      return FutureBuilder(
          future: getVocableList(),
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
  Widget learn(BuildContext context) {
    //multiple choice with 4 options
    if (vocableList[questionId]['section'] >= 1 && vocableList.length > 3) {
      if (answered == false) {
        multChoiceIdList = [];
        dynColor = [Colors.white, Colors.white, Colors.white, Colors.white];
        int randNumb;
        Random rnd = new Random();
        wordOrtransl = rnd.nextInt(2);

        multChoiceIdList.add(questionId);

        while (multChoiceIdList.length < 4) {
          randNumb = rnd.nextInt(vocableList.length);

          if (!multChoiceIdList.contains(randNumb)) {
            multChoiceIdList.add(randNumb);
          }
        }
      }
      return multipleChoice(multChoiceIdList, wordOrtransl);
    } else if (vocableList[questionId]['section'] == 2) {
      return Column();
    } else if (vocableList[questionId]['section'] == 3) {
      return Column();
    }
  }

// create page body with multiple choice
// after 6 correct answers section will be updated till section 3
  Widget multipleChoice(List<int> multChoiceList, int wordOrtransl) {
    Timer timer;
    int section = 1;
    String answerMode;
    String questionMode;

    if (answered == false) {
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

    int idPosition = multChoiceIdList.indexOf(questionId);

    print(multChoiceList);
    print(vocableList);
    print(vocableList[questionId]);
    print(correctCounter);

    if (wordOrtransl == 0) {
      answerMode = 'word';
      questionMode = 'translation';
    } else {
      answerMode = 'translation';
      questionMode = 'word';
    }

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
