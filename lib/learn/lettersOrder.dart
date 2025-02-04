import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vocabulary/global_vars.dart';

class LettersOrder extends StatefulWidget {
  final Function callback;
  final int questionId;
  final String answerMode;
  final String questionMode;
  final bool answered = false;
  final List<int> correctCounter;
  final double progressvalue;
  final int counter;

  LettersOrder(
      this.questionId,
      this.counter,
      this.answerMode,
      this.questionMode,
      this.callback,
      this.correctCounter,
      this.progressvalue);

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
  Timer timer;
  LettersOrderState(this.answered);

  @override
  void initState() {
    super.initState();
    answerColor = Colors.grey[100];
    correctanswer = '';
  }

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
    String answer = vocableLearnList[widget.questionId][widget.answerMode];

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
                        color: Colors.green),
                    textAlign: TextAlign.center))),
        Center(
            child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.005),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 3.0, color: answerColor))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(answerStr,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ],
                ))),
        Center(
            child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: Wrap(
                    spacing: 6.0,
                    runSpacing: 6.0,
                    children: List<Widget>.generate(
                        lettersList.length,
                        (index) => ActionChip(
                              label: Text(lettersList[index],
                                  textAlign: TextAlign.center),
                              onPressed: () async {
                                answerStr = answerStr + (lettersList[index]);

                                lettersList.removeAt(index);
                                print(answerStr);
                                answered = true;

                                if (lettersList.length == 0 &&
                                    answered == true) {
                                  if (answerStr ==
                                      vocableLearnList[widget.questionId]
                                          [widget.answerMode]) {
                                    answerColor = Colors.green;

                                    widget.correctCounter[widget.counter] =
                                        widget.correctCounter[widget.counter] +
                                            1;
                                  } else {
                                    answerColor = Colors.red;
                                    correctanswer = answer;
                                  }
                                }
                                setState(() {});
                              },
                            )))))
      ],
    );
  }

  speakWord(String word) async {
    FlutterTts flutterTts = FlutterTts();
    flutterTts.setLanguage('ko');
    flutterTts.setPitch(1.0);
    await flutterTts.speak(word);
  }

//not used
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
    String answer = vocableLearnList[widget.questionId][widget.answerMode];

    if (answerStr == vocableLearnList[widget.questionId][widget.answerMode]) {
      textcolor = Colors.green;
      iscorrect = 'Correct!';
      correctanswer = '';
    } else {
      textcolor = Colors.red;
      iscorrect = 'Wrong!';
      correctanswer = vocableLearnList[widget.questionId][widget.questionMode] +
          ' = $answer \n';
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
