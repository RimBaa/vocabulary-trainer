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

  @override
  void initState() {
    super.initState();

    progressvalue = 0.0;
    progresscounter = 0;
    ListVocabState vocListObj = new ListVocabState();
    vocListObj.getVocableList().whenComplete(() {
      setState(() {
        print("init");
      });
    });
  }

  //setstate from other class
  void callback() {
    setState(() {
      progressvalue = 0.0;
      newSession = true;
      progresscounter = 0;
      correctCounter = [];
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
    return Scaffold(
      body: getlearnoption(context),
    );
  }
//   }

  Widget getlearnoption(BuildContext context) {
    if (vocableList.length > 9) {
      vocablenumber = 10;
    } else {
      vocablenumber = vocableList.length;
    }
    addprogress = 1 / (3 * vocablenumber);
    print('vocablenumber $vocablenumber');
    print(vocableList);
    if (vocableList != null) {
      if (vocableList.length <= 3) {
        return new Container(
            width: 150,
            height: 150,
            child: Text(
                "There are not enough vocables to learn. At least 4 vocables are needed."));
      } else {
        Random rnd = new Random();

        while (questionList.length < vocablenumber) {
          int question = rnd.nextInt(vocableList.length);
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
    }
  }

// each vocable will be learned with the 3 learning options
  learn(BuildContext context) {
    int section = vocableList[questionId]['section'];

    print(newSession);
    if (newSession == true) {
      correctCounter = List.filled(vocableList.length, 0);
      return new StartLearning(callbackSet);
    } else {
      progresscounter += 1;
      print('progresscounter $progresscounter');
      if (progresscounter <= vocablenumber) {
        return new MultChoiceCl(questionList[progresscounter - 1], answerMode,
            questionMode, callbackSet, correctCounter, progressvalue);
      } else if (progresscounter <= vocablenumber * 2) {
        return new LettersOrder(
            questionList[(progresscounter - 1) ~/ 2],
            questionMode,
            answerMode,
            callbackSet,
            correctCounter,
            progressvalue);
      } else if (progresscounter <= vocablenumber * 3) {
        return new EnterAnswerCl(
            questionList[(progresscounter - 1) ~/ 3],
            questionMode,
            answerMode,
            callbackSet,
            correctCounter,
            progressvalue);
      } else {
        return new EndLearn(callback);
      }
    }
  }
}

class StartLearning extends StatefulWidget {
  final Function callback;

  StartLearning(this.callback);

  @override
  StartLearningState createState() => StartLearningState();
}
Icon iconArrow = Icon(Icons.arrow_forward);
class StartLearningState extends State<StartLearning> {
  int iconCounter;
  
  @override
  void initState() {
    iconCounter = 0;
    super.initState();
    iconArrow = Icon(Icons.arrow_forward);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("learn",
              style: TextStyle(fontSize: fontSize, color: Colors.white)),
          backgroundColor: Colors.amber,
          actions: <Widget>[
            RaisedButton(
                color: Colors.amber,
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  _settings(context);
                })
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: RaisedButton(
              padding: EdgeInsets.all(26),
              color: Colors.amber[400],
              child: Text('start learning',
                  style: TextStyle(fontSize: 25, color: Colors.white)),
              onPressed: () {
                widget.callback();
              }),
        ));
  }

  Future _settings(BuildContext context) {
    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            actions: <Widget>[
              RaisedButton(
                  child: Text('Back'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              RaisedButton(
                  child: Text('Change'),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
            title: Title(
                color: Colors.amber,
                child: Text('Settings', style: TextStyle(color: Colors.black))),
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft, child: Text('direction:')),
                Container(
                    alignment: Alignment.topLeft,
                    child:new IconButton(
                        icon: iconArrow,
                        onPressed: () {
                          setState(() {
                            print(Icon(Icons.arrow_forward));
                            if(iconArrow == Icon(Icons.arrow_forward)){
                              iconArrow = Icon(Icons.arrow_back);
                            }else{
                              iconArrow = Icon(Icons.arrow_forward);
                            }
                           // iconArrow = iconArrow == Icon(Icons.arrow_forward) ? Icon(Icons.arrow_back) : Icon(Icons.arrow_forward);
                            print(iconArrow);
                          });
                        }))
              ],
            ),
          );
        });
  }

  
}

class EndLearn extends StatefulWidget {
  final Function callback;

  EndLearn(this.callback);

  @override
  EndLearnState createState() => EndLearnState();
}

class EndLearnState extends State<EndLearn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("learn",
              style: TextStyle(fontSize: fontSize, color: Colors.white)),
          backgroundColor: Colors.amber,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: RaisedButton(
              padding: EdgeInsets.all(26),
              color: Colors.amber[400],
              child: Text('Done',
                  style: TextStyle(fontSize: 25, color: Colors.white)),
              onPressed: () {
                widget.callback();
              }),
        ));
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
  final double progressvalue;

  MultChoiceCl(this.questionId, this.answerMode, this.questionMode,
      this.callback, this.correctCounter, this.progressvalue);

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("learn",
            style: TextStyle(fontSize: fontSize, color: Colors.white)),
        backgroundColor: Colors.amber,
      ),
      body: Column(children: [
        Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 20,
            child: Center(
                child: LinearProgressIndicator(
              value: widget.progressvalue,
              //backgroundColor: Colors.amberAccent[100],
              //valueColor: AlwaysStoppedAnimation(Colors.amber),
            ))),
        multipleChoice()
      ]),
    );
  }

// multiple choice learn option
// after 6 correct answers section will be updated till section 3
  Widget multipleChoice() {
    Timer timer;
    int section = 1;
    print(widget.correctCounter);
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
      print('bottom');

      timer = new Timer.periodic(
          Duration(seconds: 1),
          (Timer t) => setState(() {
                timer.cancel();
                widget.callback();
              }));
    }

    int idPosition = multChoiceList.indexOf(widget.questionId);

    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(10),
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(vocableList[widget.questionId][widget.questionMode],
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              ],
            )),
        Container(
            height: 380,
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
                              widget.correctCounter[widget.questionId] == 3) {
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
                              widget.correctCounter[widget.questionId] == 3) {
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
                              widget.correctCounter[widget.questionId] == 3) {
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
                              widget.correctCounter[widget.questionId] == 3) {
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
  final Function callback;
  final int questionId;
  final String answerMode;
  final String questionMode;
  final bool answered = false;
  final List<int> correctCounter;
  final double progressvalue;

  LettersOrder(this.questionId, this.answerMode, this.questionMode,
      this.callback, this.correctCounter, this.progressvalue);

  @override
  LettersOrderState createState() => LettersOrderState(answered);
}

class LettersOrderState extends State<LettersOrder> {
  bool answered;
  Color answerColor;
  String correctanswer;
  List<String> lettersList;
  String answerStr;
  bool isKorean = false;

  LettersOrderState(this.answered);

  @override
  void initState() {
    super.initState();
    answerColor = Colors.grey[100];
    correctanswer = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("learn",
              style: TextStyle(fontSize: fontSize, color: Colors.white)),
          backgroundColor: Colors.amber,
        ),
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
            letterOrder()
          ],
        )));
  }

  //LetterOrder
  Widget letterOrder() {
    String answer = vocableList[widget.questionId][widget.answerMode];
    Timer timer;

    print(widget.correctCounter);
    if (answered == false) {
      lettersList = [];
      answerColor = Colors.grey[300];
      correctanswer = '';
//hangul syllable block
      // if (answer.codeUnitAt(0) > 44032) {
      //   isKorean = true;
      //   lettersList = getLetters(answer);
      // }
      //latin character
      // else {
      // isKorean = false;
      lettersList = answer.split('');
      // }

      lettersList.shuffle();
      while (lettersList == answer.split('')) {
        lettersList.shuffle();
      }
      answerStr = "";
    }

    if (answered == true && lettersList.length == 0) {
      answered = false;
      print('bottom');

      timer = new Timer.periodic(
          Duration(seconds: 2),
          (Timer t) => setState(() {
                timer.cancel();
                widget.callback();
              }));
    }

    return Column(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(vocableList[widget.questionId][widget.questionMode],
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ])),
        Container(
            child: Text(correctanswer,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.green))),
        Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 3.0, color: answerColor))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(answerStr,
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              ],
            )),
        Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
            child: Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: List<Widget>.generate(
                    lettersList.length,
                    (index) => ActionChip(
                          label: Text(lettersList[index]),
                          onPressed: () async {
                            answerStr = answerStr + (lettersList[index]);

                            lettersList.removeAt(index);
                            print(answerStr);
                            answered = true;

                            if (lettersList.length == 0 && answered == true) {
                              if (answerStr ==
                                  vocableList[widget.questionId]
                                      [widget.answerMode]) {
                                answerColor = Colors.green;
                                if (vocableList[widget.questionId]['section'] <
                                        3 &&
                                    widget.correctCounter[widget.questionId] ==
                                        5) {
                                  widget.correctCounter[widget.questionId] = 0;
                                  await updateVocableTable(VocableTable(
                                      id: vocableList[widget.questionId]['id'],
                                      section: vocableList[widget.questionId]
                                              ['section'] +
                                          1,
                                      translation:
                                          vocableList[widget.questionId]
                                              ['translation'],
                                      word: vocableList[widget.questionId]
                                          ['word']));
                                } else {
                                  widget.correctCounter[widget.questionId] =
                                      widget.correctCounter[widget.questionId] +
                                          1;
                                }
                              } else {
                                answerColor = Colors.red;
                                correctanswer = answer;
                              }
                            }
                            setState(() {});
                          },
                        ))))
      ],
    );
  }

// get hangul character list
  List<String> getLetters(String answer) {
    List<String> characterList = [];

// extract from hangul syllable (in decimal) jamo (in hex)
    for (var i = 0; i < answer.length; i++) {
      int unicode = answer.codeUnitAt(i);
      print('hhhhhhhhhhhhhh');
      print(unicode);
      int divInt = 0;
      String charHex = "";
      int charInt = 0;
      print(6657 % 28);
      print(6657 ~/ 28);
      unicode = unicode - 44032;

      divInt = unicode ~/ 28;
      print(divInt);
      print(unicode);
      int rest = unicode % 28;
      if (rest > 0) {
        charInt = rest + 4519;
        charHex = charInt.toRadixString(16);
        characterList.add(
            String.fromCharCode(int.parse(charHex.toUpperCase(), radix: 16)));
      }
      rest = divInt % 21;
      charInt = rest + 4449;
      charHex = charInt.toRadixString(16);
      characterList.add(
          String.fromCharCode(int.parse(charHex.toUpperCase(), radix: 16)));

      divInt = divInt ~/ 21;
      charInt = divInt + 4352;
      charHex = charInt.toRadixString(16);

      characterList.add(
          String.fromCharCode(int.parse(charHex.toUpperCase(), radix: 16)));
    }

    print(characterList);

    return characterList;
  }

// get hangul syllable block
  String getSyllable(String answer) {
    String syllable = '';
    int previousval = 0;
    int nextval = 0;
    List<int> onlyinitialList = [4356, 4360, 4365];
    List<int> onlyfinalList = [
      4522,
      4524,
      4525,
      4529,
      4530,
      4531,
      4532,
      4533,
      4534,
      4539
    ];
    Map initialFinalMap = {
      0: 1,
      1: 2,
      2: 4,
      3: 7,
      5: 8,
      6: 16,
      7: 17,
      9: 19,
      10: 20,
      11: 21,
      12: 22,
      14: 23,
      15: 24,
      16: 25,
      17: 26,
      18: 27
    };

    Map finalInitialMap = {
      1: 0,
      2: 1,
      4: 2,
      7: 3,
      8: 5,
      16: 6,
      17: 7,
      19: 9,
      20: 10,
      21: 11,
      22: 12,
      23: 14,
      24: 15,
      25: 16,
      26: 17,
      27: 28
    };

    int unicodeBlock = 44032;
    bool newblock = false;
    bool onlyoneletter = false;
    print(answer);
    print(answer.length);
    int cons;

    int unicode = answer.codeUnitAt(0);

// first letter of answer
//initial cons
    if (unicode < 4449) {
      unicodeBlock += (unicode - 4352) * 588;

      newblock = false;
      onlyoneletter = true;
    }
//vowel
    else if (unicode >= 4449 && unicode < 4470) {
      unicodeBlock = unicode;

      syllable = syllable + String.fromCharCode(unicodeBlock);
      unicodeBlock = 44032;
      newblock = true;
    }
// final cons
    else {
      cons = unicode - 4519;
      if (onlyfinalList.contains(unicode)) {
        unicodeBlock = unicode;

        syllable = syllable + String.fromCharCode(unicodeBlock);
        unicodeBlock = 44032;
        newblock = true;
      } else {
        //get value of inital version of final consonant
        cons = finalInitialMap[cons];

        unicodeBlock += (cons) * 588;
        onlyoneletter = true;
        newblock = false;
      }
    }
    print('unicodeblock: $unicodeBlock');

    for (var i = 1; i < answer.length; i++) {
      unicode = answer.codeUnitAt(i);
      previousval = answer.codeUnitAt(i - 1);
      if (i == answer.length - 2) {
        nextval = answer.codeUnitAt(i + 1);
      }

      print('iiiiiiiiiiiiiiiiiiiii');
      print(unicode);
      print(newblock);
      if (newblock == false) {
        //cc
        if (previousval < 4449 || previousval > 4469) {
          if (unicode < 4449 || unicode > 4469) {
            if (onlyoneletter == true) {
              unicodeBlock = answer.codeUnitAt(i - 1);
            }
            syllable = syllable + String.fromCharCode(unicodeBlock);
            unicodeBlock = 44032;

            if (unicode > 4469) {
              if (onlyfinalList.contains(unicode)) {
                if (onlyoneletter == true) {
                  unicodeBlock = answer.codeUnitAt(i - 1);
                }
                syllable = syllable + String.fromCharCode(unicodeBlock);
                unicodeBlock = 44032;
                newblock = true;
              }
              cons = unicode - 4519;
              cons = finalInitialMap[cons];
              unicodeBlock += (cons) * 588;
            } else {
              onlyoneletter = false;
              unicodeBlock += (unicode - 4352) * 588;
            }
          }
          //cv
          else {
            //unecessary part since prevval can only be initial???
            if (onlyfinalList.contains(previousval)) {
              if (onlyoneletter == true) {
                unicodeBlock = answer.codeUnitAt(i - 1);
              }
              syllable = syllable + String.fromCharCode(unicodeBlock);
              // unicodeBlock = 44032;

              // unicodeBlock += (unicode - 4449) * 28;
              unicodeBlock = unicode;
              syllable = syllable + String.fromCharCode(unicodeBlock);
              unicodeBlock = 44032;
              newblock = true;
            } else {
              onlyoneletter = false;
              unicodeBlock += (unicode - 4449) * 28;
            }
          }
        }
        //vc or vv
        else {
          //vv
          if (unicode >= 4449 && unicode < 4470) {
            if (onlyoneletter == true) {
              unicodeBlock = answer.codeUnitAt(i - 1);
            }
            syllable = syllable + String.fromCharCode(unicodeBlock);
            // unicodeBlock = 44032;

            // unicodeBlock += (unicode - 4449) * 28;
            unicodeBlock = unicode;
            syllable = syllable + String.fromCharCode(unicodeBlock);
            unicodeBlock = 44032;
            newblock = true;
          }
          //vc with c only initial
          else if (onlyinitialList.contains(unicode)) {
            if (onlyoneletter == true) {
              unicodeBlock = answer.codeUnitAt(i - 1);
            }
            syllable = syllable + String.fromCharCode(unicodeBlock);
            unicodeBlock = 44032;
            unicodeBlock += (unicode - 4352) * 588;
            onlyoneletter = true;
            newblock = false;
          }
          //vc
          else {
            // vc stays together in one block if next value is c else after v starts a new block
            if (i == answer.length - 2) {
              print('neexxxtt');
              if (nextval > 4448 &&
                  nextval < 4470 &&
                  !onlyfinalList.contains(unicode)) {
                if (onlyoneletter == true) {
                  unicodeBlock = answer.codeUnitAt(i - 1);
                }
                syllable = syllable + String.fromCharCode(unicodeBlock);
                unicodeBlock = 44032;

                if (unicode > 4469) {
                  cons = unicode - 4519;
                  unicode = finalInitialMap[cons];
                }
                unicodeBlock += (unicode - 4352) * 588;
                onlyoneletter = true;
                newblock = false;
              }
              if (nextval < 4449 || nextval > 4469) {
                if (unicode < 4449) {
                  cons = unicode - 4352;
                  unicode = initialFinalMap[cons];
                }
                unicodeBlock += unicode - 4519;
                syllable = syllable + String.fromCharCode(unicodeBlock);
                unicodeBlock = 44032;
                newblock = true;
              } else {
                if (onlyoneletter == true) {
                  unicodeBlock = answer.codeUnitAt(i - 1);
                }
                syllable = syllable + String.fromCharCode(unicodeBlock);
                unicodeBlock = 44032;
                newblock = true;
              }
            } else {
              //vc if c is last letter of answer
              if (onlyinitialList.contains(unicode)) {
                if (onlyoneletter == true) {
                  unicodeBlock = answer.codeUnitAt(i - 1);
                }
                syllable = syllable + String.fromCharCode(unicodeBlock);
                syllable = syllable + String.fromCharCode(unicode);
              } else {
                if (unicode < 4449) {
                  cons = initialFinalMap[cons];
                  unicodeBlock += cons - 4519;
                  syllable = syllable + String.fromCharCode(unicodeBlock);
                  unicodeBlock = 44032;
                  newblock = true;
                } else {
                  unicodeBlock += unicode - 4519;
                  syllable = syllable + String.fromCharCode(unicodeBlock);
                  unicodeBlock = 44032;
                  newblock = true;
                }
              }
            }
          }
        }
      }
      //new block first letter
      else {
        //initial cons
        if (unicode < 4449) {
          unicodeBlock += (unicode - 4352) * 588;
          onlyoneletter = true;
          newblock = false;
        }
//vowel
        else if (unicode >= 4449 && unicode < 4470) {
          unicodeBlock = unicode;

          syllable = syllable + String.fromCharCode(unicodeBlock);
          unicodeBlock = 44032;
          newblock = true;
        }
// final cons
        else {
          cons = unicode - 4519;
          if (onlyfinalList.contains(unicode)) {
            unicodeBlock = unicode;

            syllable = syllable + String.fromCharCode(unicodeBlock);
            unicodeBlock = 44032;
            newblock = true;
          } else {
            //get value of inital version of final consonant
            cons = finalInitialMap[cons];
            unicodeBlock = cons;

            newblock = false;
          }
        }
      }

// // final cons that can only be final
//       if (onlyfinalList.contains(unicode)) {
//         // previous value is an initial consonant -> cc not possible -> two different blocks
//         if (previousval < 4449) {
//           syllable = syllable + String.fromCharCode(unicodeBlock);
//           unicodeBlock = 44032;
//           newblock = true;
//         }
//         unicodeBlock += (unicode - 4519);

//         syllable = syllable + String.fromCharCode(unicodeBlock);
//         unicodeBlock = 44032;
//         newblock = true;
//       }
//       // final cons that also can be initial
//       // if next value is vowel make final to initial and start with it a new block
//       else if (unicode >= 4519) {
//         print('final');
//         if (i == answer.length - 2) {
//           print('nextvalll');
//           nextval = answer.codeUnitAt(i + 1);

//           if (nextval >= 4449 && nextval < 4470) {
//             syllable = syllable + String.fromCharCode(unicodeBlock);
//             cons = (unicode - 4519);
//             cons = finalInitialMap[cons];
//             unicodeBlock = 44032;
//             unicodeBlock += (cons) * 588;

//             newblock = false;
//             print(unicodeBlock);
//           }
//           //TODO: else is missing
//         }
// // vc
//         else if (previousval >= 4449 && previousval < 4470) {
//           print('aaaaaaaaaaaaaaaaaaa');
//           unicodeBlock += unicode - 4519;
//           syllable = syllable + String.fromCharCode(unicodeBlock);
//           unicodeBlock = 44032;
//           newblock = true;
//         }
//         // cc not possible
//         else {
//           print(newblock);
//           if (newblock == false) {
//             syllable = syllable + String.fromCharCode(unicodeBlock);
//             unicodeBlock = 44032;
//             newblock = true;
//           }
//           cons = (unicode - 4519);
//           cons = finalInitialMap[cons];
//           unicodeBlock += (cons) * 588;

//           newblock = false;
//           print(unicodeBlock);
//         }
//       }
//       // vowel
//       else if (unicode >= 4449 && unicode < 4470) {
//         // initial cons + vowel
//         if (previousval < 4449) {
//           unicodeBlock += (unicode - 4449) * 28;

//           if (i == answer.length - 1) {
//             syllable = syllable + String.fromCharCode(unicodeBlock);
//             unicodeBlock = 44032;
//             newblock = true;
//           }
//         }
//         // vv and cv if c is final is not possible -> two blocks
//         else if (previousval >= 4449 && previousval < 4470 ||
//             onlyfinalList.contains(previousval)) {
//           syllable = syllable + String.fromCharCode(unicodeBlock);
//           unicodeBlock = 44032;
//           unicodeBlock += (unicode - 4449) * 28;
//           newblock = false;
//           print('wroooong');
//         } else {
//           unicodeBlock += (unicode - 4449) * 28;
//         }
//       }
//       // initial cons
//       else {
//         print(unicodeBlock);
//         // cc not possible -> two blocks
//         if (previousval < 4449 || previousval > 4469) {
//           if (unicodeBlock > 44032) {
//             syllable = syllable + String.fromCharCode(unicodeBlock);
//             unicodeBlock = 44032;
//           }
//           unicodeBlock += (unicode - 4352) * 588;

//           newblock = false;
//         } else if (previousval >= 4449 && previousval < 4470) {
//           // vc with c initial not possible -> two blocks
//           if (onlyinitialList.contains(unicode)) {
//             syllable = syllable + String.fromCharCode(unicodeBlock);
//             unicodeBlock = 44032;
//             unicodeBlock += (unicode - 4352) * 588;

//             newblock = false;
//           } else if (i == answer.length - 2) {
//             nextval = answer.codeUnitAt(i + 1);
//             if (nextval >= 4449 && nextval < 4470) {
//               syllable = syllable + String.fromCharCode(unicodeBlock);
//               unicodeBlock = 44032;
//               unicodeBlock += (unicode - 4352) * 588;

//               newblock = false;
//             }
//           } else {
//             cons = unicode - 4352;
//             cons = initialFinalMap[cons];
//             unicodeBlock += cons;

//             syllable = syllable + String.fromCharCode(unicodeBlock);
//             unicodeBlock = 44032;
//             newblock = true;
//           }
//         }
//       }
      print('syllable step: $syllable');
//only up to 3 jamo per block
      // if (counter < 3) {
      //   counter += 1;
      // }

      // if (counter == 1) {
      //   unicodeBlock += (unicode - 4352) * 588;
      // } else if (counter == 2) {
      //   unicodeBlock += (unicode - 4449) * 28;
      //   if (answer.length == 2 ||
      //       answer.length > 2 && answer.codeUnitAt(i + 1) < 4519) {
      //     counter = 0;
      //     isblock = true;
      //   }
      // } else if (counter == 3) {
      //   unicodeBlock += (unicode - 4519);
      //   isblock = true;
      //   counter = 0;
      // }

//unicodeblock to string to be interpreted by utf16 unit
      // if (isblock) {
      //   print(unicodeBlock);
      //   syllable = syllable + String.fromCharCode(unicodeBlock);
      //   print(syllable);
      //   isblock = false;
      //}
      //   divInt = unicode ~/ 28;
      //   int rest = unicode % 28;
      //   if (rest > 0) {
      //     charInt = rest + 4519;
      //     charHex = charInt.toRadixString(16);
      //     characterList.add(
      //         String.fromCharCode(int.parse(charHex.toUpperCase(), radix: 16)));
      //   }
      //   rest = divInt % 21;
      //   charInt = rest + 4449;
      //   charHex = charInt.toRadixString(16);
      //   characterList.add(
      //       String.fromCharCode(int.parse(charHex.toUpperCase(), radix: 16)));

      //   divInt = divInt ~/ 21;
      //   charInt = divInt + 4352;
      //   charHex = charInt.toRadixString(16);

      //   characterList.add(
      //       String.fromCharCode(int.parse(charHex.toUpperCase(), radix: 16)));
      // }

    }
    if (newblock == false) {
      syllable = syllable + String.fromCharCode(unicodeBlock);
      unicodeBlock = 44032;
      newblock = true;
    }
    print('syllable: $syllable');
    return syllable;
  }

// show if answer is correct, display correct answer if entered answer is wrong
  showAnswer() {
    Color textcolor = Colors.black;
    String iscorrect = '';
    String correctanswer = '';
    String answer = vocableList[widget.questionId][widget.answerMode];

    if (answerStr == vocableList[widget.questionId][widget.answerMode]) {
      textcolor = Colors.green;
      iscorrect = 'Correct!';
      correctanswer = '';
    } else {
      textcolor = Colors.red;
      iscorrect = 'Wrong!';
      correctanswer =
          vocableList[widget.questionId][widget.questionMode] + ' = $answer \n';
    }
    return showModalBottomSheet<void>(
        enableDrag: false,
        isDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 170,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      iscorrect + ' \n',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: textcolor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        correctanswer,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ]),
                RaisedButton(
                  onPressed: () {
                    answered = false;
                    widget.callback();
                  },
                  child: Text('Next'),
                )
              ],
            ),
          );
        });
  }
}
// \u: 110B 1161 1102
// 4363 4449 4354
//6580
//50504

class EnterAnswerCl extends StatefulWidget {
  final Function callback;
  final int questionId;
  final String answerMode;
  final String questionMode;
  final List<int> correctCounter;
  final double progressvalue;

  EnterAnswerCl(this.questionId, this.answerMode, this.questionMode,
      this.callback, this.correctCounter, this.progressvalue);

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
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("learn",
              style: TextStyle(fontSize: fontSize, color: Colors.white)),
          backgroundColor: Colors.amber,
        ),
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
      print('bottom');
      answered = false;

      timer = new Timer.periodic(
          Duration(seconds: 2),
          (Timer t) => setState(() {
                timer.cancel();
                widget.callback();
              }));
    }
    return Column(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(vocableList[widget.questionId][widget.questionMode],
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ])),
        Container(
            child: Text(correctanswer,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.green))),
        Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextField(
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3.0, color: answerColor)),
                  labelText: 'Enter translation'),
              controller: _controller,
              onSubmitted: (String value) {
                answered = true;

                if (value ==
                    vocableList[widget.questionId][widget.answerMode]) {
                  answerColor = Colors.green;
                } else {
                  correctanswer =
                      vocableList[widget.questionId][widget.answerMode];
                  answerColor = Colors.red;
                }
                setState(() {});
              },
            ))
      ],
    );
  }
}
