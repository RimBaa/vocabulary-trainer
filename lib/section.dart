import 'package:flutter/material.dart';
import 'global_vars.dart';

// class Sections extends StatefulWidget{
//   @override
//   _Sections createState() => _Sections();
// }

// class _Sections extends State<Sections>{
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("sections", style: TextStyle(fontSize: fontSize, color: Colors.white)),
//         backgroundColor: Colors.blue,
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'global_vars.dart';
import 'dart:math';
import 'vocable.dart';

class Sections extends StatefulWidget {
  @override
  S createState() => S();
}

class S extends State<Sections> {
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
  //bool newSession = true;
  String answerMode;
  String questionMode;
  bool newSession = true;

  @override
  void initState() {
    super.initState();

    ListVocabState vocListObj = new ListVocabState();
    vocListObj.getVocableList().whenComplete(() {
      setState(() {});
    });
  }

  //setstate from other class
  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //if (vocableList[questionId]['section'] >= 1) {

// else{
    return Scaffold(
      body: test(context),
    );
  }
//   }

  Widget test(BuildContext context) {
    print(vocableList);
    if (vocableList != null) {
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
    }
  }

// one of three learn options
  learn(BuildContext context) {
    int section = vocableList[questionId]['section'];
    Random rnd = new Random();
    int rndOption = rnd.nextInt(section);
print(vocableList);
print("learn optin $rndOption");

    //multiple choice with 4 options
    if (vocableList[questionId]['section'] >= 1 &&
        vocableList.length > 3 &&
        rndOption == 1) {
      return new MultChoiceCl(
          questionId, answerMode, questionMode, callback, correctCounter);
    } else if (vocableList[questionId]['section'] >= 1 && rndOption == 0) {
      print('UUUUUUUUUUU');
      return new LettersOrder(
          questionId, questionMode, answerMode, callback, correctCounter);
    } else if (vocableList[questionId]['section'] == 3 && rndOption == 2) {
      //  return Column();
    }
  }
}

//multiple choice page with 4 answer options
class MultChoiceCl extends StatefulWidget {
  final Function callback;
  final int questionId;
  final String answerMode;
  final String questionMode;
  final bool answered = false;
  final List<int> correctCounter;

  MultChoiceCl(this.questionId, this.answerMode, this.questionMode,
      this.callback, this.correctCounter);

  @override
  MultChoiceState createState() => MultChoiceState(answered);
}

class MultChoiceState extends State<MultChoiceCl> {
  bool answered;
  List<int> multChoiceList = [];
  List<Color> dynColor = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white
  ];

  MultChoiceState(this.answered);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("learn",
            style: TextStyle(fontSize: fontSize, color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: multipleChoice(),
    );
  }

// multiple choice learn option
// after 6 correct answers section will be updated till section 3
  Widget multipleChoice() {
    Timer timer;
    int section = 1;

    if (answered == false) {
      multChoiceList = [];
      dynColor = [Colors.white, Colors.white, Colors.white, Colors.white];
      int randNumb;
      Random rnd = new Random();
      multChoiceList.add(widget.questionId);
      while (multChoiceList.length < 4) {
        randNumb = rnd.nextInt(vocableList.length);

        if (!multChoiceList.contains(randNumb)) {
          multChoiceList.add(randNumb);
        }
      }

      multChoiceList.shuffle();
      section = vocableList[widget.questionId]['section'];
    } else {
      answered = false;
      
      timer = new Timer.periodic(
          Duration(seconds: 1),
          (Timer t) => setState(() {
                timer.cancel();
                widget.callback();
              }));
    }

    int idPosition = multChoiceList.indexOf(widget.questionId);

    print(multChoiceList);
    print(vocableList);
    print(vocableList[widget.questionId]);
    print(widget.correctCounter);

    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(10),
            height: 100,
            child: Row(
              children: <Widget>[
                Text(vocableList[widget.questionId][widget.questionMode],
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
                              vocableList[multChoiceList[0]][widget.answerMode],
                              style: TextStyle(fontSize: 20),
                            )
                          ]),
                      onTap: () async {
                        if (widget.questionId == multChoiceList[0]) {
                          dynColor[0] = Colors.greenAccent;
                          if (section < 3 &&
                              widget.correctCounter[widget.questionId] == 5) {
                            widget.correctCounter[widget.questionId] = 0;
                            await updateVocableTable(VocableTable(
                                id: vocableList[widget.questionId]['id'],
                                section: section + 1,
                                translation: vocableList[widget.questionId]
                                    ['translation'],
                                word: vocableList[widget.questionId]['word']));
                          } else {
                            widget.correctCounter[widget.questionId] =
                                widget.correctCounter[widget.questionId] + 1;
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
                              vocableList[multChoiceList[1]][widget.answerMode],
                              style: TextStyle(fontSize: 20),
                            )
                          ]),
                      onTap: () async {
                        if (widget.questionId == multChoiceList[1]) {
                          dynColor[1] = Colors.greenAccent;
                          if (section < 3 &&
                              widget.correctCounter[widget.questionId] == 5) {
                            widget.correctCounter[widget.questionId] = 0;
                            await updateVocableTable(VocableTable(
                                id: vocableList[widget.questionId]['id'],
                                section: section + 1,
                                translation: vocableList[widget.questionId]
                                    ['translation'],
                                word: vocableList[widget.questionId]['word']));
                          } else {
                            widget.correctCounter[widget.questionId] =
                                widget.correctCounter[widget.questionId] + 1;
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
                              vocableList[multChoiceList[2]][widget.answerMode],
                              style: TextStyle(fontSize: 20),
                            )
                          ]),
                      onTap: () async {
                        if (widget.questionId == multChoiceList[2]) {
                          dynColor[2] = Colors.greenAccent;
                          if (section < 3 &&
                              widget.correctCounter[widget.questionId] == 5) {
                            widget.correctCounter[widget.questionId] = 0;
                            await updateVocableTable(VocableTable(
                                id: vocableList[widget.questionId]['id'],
                                section: section + 1,
                                translation: vocableList[widget.questionId]
                                    ['translation'],
                                word: vocableList[widget.questionId]['word']));
                          } else {
                            widget.correctCounter[widget.questionId] =
                                widget.correctCounter[widget.questionId] + 1;
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
                              vocableList[multChoiceList[3]][widget.answerMode],
                              style: TextStyle(fontSize: 20),
                            )
                          ]),
                      onTap: () async {
                        if (widget.questionId == multChoiceList[3]) {
                          dynColor[3] = Colors.greenAccent;
                          if (section < 3 &&
                              widget.correctCounter[widget.questionId] == 5) {
                            widget.correctCounter[widget.questionId] = 0;
                            await updateVocableTable(VocableTable(
                                id: vocableList[widget.questionId]['id'],
                                section: section + 1,
                                translation: vocableList[widget.questionId]
                                    ['translation'],
                                word: vocableList[widget.questionId]['word']));
                          } else {
                            widget.correctCounter[widget.questionId] =
                                widget.correctCounter[widget.questionId] + 1;
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

class LettersOrder extends StatefulWidget {
// bool answered = false;
  final Function callback;
  final int questionId;
  final String answerMode;
  final String questionMode;
  final bool answered = false;
  final List<int> correctCounter;
  LettersOrder(this.questionId, this.answerMode, this.questionMode,
      this.callback, this.correctCounter);

  @override
  LettersOrderState createState() => LettersOrderState(answered);
}

class LettersOrderState extends State<LettersOrder> {
  bool answered;
  LettersOrderState(this.answered);
  // bool answered = false;

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
    print(widget.correctCounter);
    print(vocableList);
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
                      onPressed: () async {
                        print(lettersList);
                        print(index);
                       
                        lettersList.removeAt(index);

                        answered = true;
                        print(lettersList);
                        print(answered);
                        if (lettersList.length == 0 && answered == true) {
                          print('donneee');

                         answered = false;
                          
                          if (vocableList[widget.questionId]['section'] < 3 &&
                              widget.correctCounter[widget.questionId] == 5) {
                            widget.correctCounter[widget.questionId] = 0;
                            await updateVocableTable(VocableTable(
                                id: vocableList[widget.questionId]['id'],
                                section: vocableList[widget.questionId]
                                        ['section'] +
                                    1,
                                translation: vocableList[widget.questionId]
                                    ['translation'],
                                word: vocableList[widget.questionId]['word']));
                          } else {
                            widget.correctCounter[widget.questionId] =
                                widget.correctCounter[widget.questionId] + 1;
                          }
                          widget.callback();
                          setState(() {});
                        } else {
                          setState(() {});
                        }
                      },
                    )))
      ],
    );
  }
}
