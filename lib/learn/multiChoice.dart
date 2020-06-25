import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vocabulary/global_vars.dart';

//multiple choice page with 4 answer options
class MultChoiceCl extends StatefulWidget {
  final Function callback;
  final int questionId;
  final String answerMode;
  final String questionMode;
  final bool answered = false;
  final List<int> correctCounter;
  final double progressvalue;
  final int counter;

  MultChoiceCl(
      this.questionId,
      this.counter,
      this.answerMode,
      this.questionMode,
      this.callback,
      this.correctCounter,
      this.progressvalue);

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
  Timer timer;
  MultChoiceState(this.answered);

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 20,
            child: Center(
                child: LinearProgressIndicator(
              value: widget.progressvalue,
            ))),
        multipleChoice()
      ]),
    );
  }

// multiple choice learn option
// after 6 correct answers section will be updated till section 3
  Widget multipleChoice() {
    String questionNote = '';
    String answerNote = '';
    var wordId;

    print(widget.correctCounter);
    if (widget.questionMode == 'translation') {
      questionNote = 'translationNote';
      answerNote = 'wordNote';
    } else {
      questionNote = 'wordNote';
      answerNote = 'translationNote';
    }

    if (answered == false) {
      multChoiceList = [];
      dynColor = [Colors.white, Colors.white, Colors.white, Colors.white];
      int randNumb;
      Random rnd = new Random();
      multChoiceList.add(widget.questionId);
      while (multChoiceList.length < 4) {
        randNumb = rnd.nextInt(vocableLearnList.length);

        if (!multChoiceList.contains(randNumb)) {
          multChoiceList.add(randNumb);
        }
      }

      multChoiceList.shuffle();
    } else if (timer == null || timer != null && !timer.isActive) {
      print('bottom');
      speakWord(vocableLearnList[widget.questionId]['translation'])
          .whenComplete(() {
        timer = new Timer.periodic(
            Duration(seconds: 2),
            (Timer t) => setState(() {
                  answered = false;
                  print(mounted);
                  timer.cancel();
                  widget.callback();
                }));
      });
    }
    int idPosition = multChoiceList.indexOf(widget.questionId);
    wordId = vocableLearnList.where((element) => element['id'] == 74);
    print(wordId);
    return Column(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(children: [
                  Text(vocableLearnList[widget.questionId][widget.questionMode],
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  Text(vocableLearnList[widget.questionId][questionNote],
                      style: (TextStyle(fontSize: 15, color: Colors.grey)),
                      textAlign: TextAlign.center)
                ])
              ],
            )),
        Container(
            height: MediaQuery.of(context).size.height * 0.6,
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
                                vocableLearnList[multChoiceList[0]]
                                    [widget.answerMode],
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center),
                            Text(
                                vocableLearnList[multChoiceList[0]][answerNote],
                                style: (TextStyle(
                                    fontSize: 15, color: Colors.grey)),
                                textAlign: TextAlign.center)
                          ]),
                      onTap: () async {
                        if (widget.questionId == multChoiceList[0]) {
                          dynColor[0] = Colors.greenAccent;

                          widget.correctCounter[widget.counter] =
                              widget.correctCounter[widget.counter] + 1;
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
                                vocableLearnList[multChoiceList[1]]
                                    [widget.answerMode],
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center),
                            Text(
                                vocableLearnList[multChoiceList[1]][answerNote],
                                style: (TextStyle(
                                    fontSize: 15, color: Colors.grey)),
                                textAlign: TextAlign.center)
                          ]),
                      onTap: () async {
                        if (widget.questionId == multChoiceList[1]) {
                          dynColor[1] = Colors.greenAccent;

                          widget.correctCounter[widget.counter] =
                              widget.correctCounter[widget.counter] + 1;
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
                                vocableLearnList[multChoiceList[2]]
                                    [widget.answerMode],
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center),
                            Text(
                                vocableLearnList[multChoiceList[2]][answerNote],
                                style: (TextStyle(
                                    fontSize: 15, color: Colors.grey)),
                                textAlign: TextAlign.center)
                          ]),
                      onTap: () async {
                        if (widget.questionId == multChoiceList[2]) {
                          dynColor[2] = Colors.greenAccent;

                          widget.correctCounter[widget.counter] =
                              widget.correctCounter[widget.counter] + 1;
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
                                vocableLearnList[multChoiceList[3]]
                                    [widget.answerMode],
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center),
                            Text(
                                vocableLearnList[multChoiceList[3]][answerNote],
                                style: (TextStyle(
                                    fontSize: 15, color: Colors.grey)),
                                textAlign: TextAlign.center)
                          ]),
                      onTap: () async {
                        if (widget.questionId == multChoiceList[3]) {
                          dynColor[3] = Colors.greenAccent;

                          widget.correctCounter[widget.counter] =
                              widget.correctCounter[widget.counter] + 1;
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

  speakWord(String word) async {
    FlutterTts flutterTts = FlutterTts();
    flutterTts.setLanguage(languageCode);
    flutterTts.setPitch(1.0);
    await flutterTts.speak(word);
  }
}
