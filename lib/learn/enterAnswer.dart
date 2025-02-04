import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vocabulary/global_vars.dart';

// write answer to given word
class EnterAnswerCl extends StatefulWidget {
  final Function callback;
  final int questionId;
  final String answerMode;
  final String questionMode;
  final List<int> correctCounter;
  final double progressvalue;
  final int counter;

  EnterAnswerCl(
      this.questionId,
      this.counter,
      this.answerMode,
      this.questionMode,
      this.callback,
      this.correctCounter,
      this.progressvalue);

  @override
  EnterAnswerState createState() => EnterAnswerState();
}

class EnterAnswerState extends State<EnterAnswerCl> {
  TextEditingController _controller;
  bool answered;
  Timer timer;
  String correctanswer;
  Color answerColor;

  initState() {
    super.initState();
    answered = false;
    _controller = TextEditingController();
    correctanswer = '';
    answerColor = Colors.grey[300];
  }

  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 20,
                child: Center(
                    child: LinearProgressIndicator(
                  value: widget.progressvalue,
                ))),
            enterAnswer()
          ],
        )));
  }

  Widget enterAnswer() {
    if (answered == false) {
      _controller.clear();
      correctanswer = '';
      answerColor = Colors.grey[300];
    } else {
      answered = false;

      if (readTrans) {
        speakWord(vocableLearnList[widget.questionId]['translation'])
            .whenComplete(() {
          timer = new Timer.periodic(
              Duration(seconds: 2),
              (Timer t) => setState(() {
                    answered = false;

                    timer.cancel();
                    widget.callback();
                  }));
        });
      } else {
        timer = new Timer.periodic(
            Duration(seconds: 2),
            (Timer t) => setState(() {
                  answered = false;

                  timer.cancel();
                  widget.callback();
                }));
      }
    }
    return Column(
      children: <Widget>[
        Center(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          vocableLearnList[widget.questionId]
                              [widget.questionMode],
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      Text(
                          vocableLearnList[widget.questionId]
                              ['${widget.questionMode}' + 'Note'],
                          style: (TextStyle(fontSize: 15, color: Colors.grey)))
                    ]))),
        Center(
            child: Container(
                child: Text(correctanswer,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)))),
        Center(
            child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  autocorrect: false,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 3.0, color: answerColor)),
                      labelText: 'Enter translation'),
                  controller: _controller,
                  onSubmitted: (String value) async {
                    answered = true;
                    if (value ==
                        vocableLearnList[widget.questionId]
                            [widget.answerMode]) {
                      answerColor = Colors.green;
                      if (vocableLearnList[widget.questionId]['section'] < 5 &&
                          widget.correctCounter[widget.counter] == 2) {
                        widget.correctCounter[widget.counter] = 3;
                      } else {
                        widget.correctCounter[widget.counter] =
                            widget.correctCounter[widget.counter] + 1;
                        //  setState(() {});
                      }
                    } else {
                      correctanswer = vocableLearnList[widget.questionId]
                          [widget.answerMode];
                      answerColor = Colors.red;
                    }
                  },
                )))
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
