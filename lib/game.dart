import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int attempts = 0;
  static const maxSeconds = 30;
  int seconds = maxSeconds;
  Timer? timer;

  bool oTurn = false;
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0; //to check for tie
  String resultD = "";
  static var customFontWhite = GoogleFonts.coiny(
      textStyle: const TextStyle(
    color: Colors.white,
    letterSpacing: 3,
    fontSize: 25,
  ));
  List<String> displayxo = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];
  List<int> matchedIndexes = [];
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    resetTimer();
    //when second is 0 we need to stop it
    timer?.cancel();
  }

  void resetTimer() => seconds = maxSeconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Player O",
                          style: customFontWhite,
                        ),
                        Text(
                          oScore.toString(),
                          style: customFontWhite,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Player X",
                          style: customFontWhite,
                        ),
                        Text(
                          xScore.toString(),
                          style: customFontWhite,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      _tapped(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(width: 5, color: Colors.black),
                        color: matchedIndexes.contains(index)
                            ? Colors.green
                            : Colors.yellow,
                      ),
                      child: Center(
                        child: Text(
                          displayxo[index],
                          style:
                              const TextStyle(color: Colors.red, fontSize: 30),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      resultD,
                      style: customFontWhite,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildTimer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _tapped(int index) {
    final isRunning = timer == null ? false : timer!.isActive;
    if (isRunning) {
      setState(() {
        if (oTurn && displayxo[index] == "") {
          filledBoxes++;
          displayxo[index] = "0";
        } else if (!oTurn && displayxo[index] == "") {
          //we can't use else only it'll change the O when pressed so we use else if and set conditions
          displayxo[index] = "X";
          filledBoxes++;
        }
        oTurn = !oTurn;
        checkWinner();
      });
    }
  }

  void checkWinner() {
    //first row
    if (displayxo[0] == displayxo[1] &&
        displayxo[0] == displayxo[2] &&
        displayxo[0] != "") {
      setState(() {
        resultD = "Player ${displayxo[0]} Wins!";
        matchedIndexes.addAll([0, 1, 2]);
        stopTimer();
        _updateScore(displayxo[0]);
      });
    } //second row
    if (displayxo[3] == displayxo[4] &&
        displayxo[3] == displayxo[5] &&
        displayxo[3] != "") {
      setState(() {
        resultD = "Player ${displayxo[3]} Wins!";
        matchedIndexes.addAll([3, 4, 5]);
        stopTimer();
        _updateScore(displayxo[3]);
      });
    } //third row
    if (displayxo[6] == displayxo[7] &&
        displayxo[6] == displayxo[8] &&
        displayxo[6] != "") {
      setState(() {
        resultD = "Player ${displayxo[6]} Wins!";
        matchedIndexes.addAll([6, 7, 8]);
        stopTimer();
        _updateScore(displayxo[6]);
      });
    }
    //first column
    if (displayxo[0] == displayxo[3] &&
        displayxo[0] == displayxo[6] &&
        displayxo[0] != "") {
      setState(() {
        matchedIndexes.addAll([0, 3, 6]);
        stopTimer();
        resultD = "Player ${displayxo[0]} Wins!";
        _updateScore(displayxo[0]);
      });
    }
    //second column
    if (displayxo[1] == displayxo[4] &&
        displayxo[1] == displayxo[7] &&
        displayxo[1] != "") {
      setState(() {
        matchedIndexes.addAll([1, 4, 7]);
        stopTimer();
        resultD = "Player ${displayxo[1]} Wins!";
        _updateScore(displayxo[1]);
      });
    }
    //third column
    if (displayxo[2] == displayxo[5] &&
        displayxo[2] == displayxo[8] &&
        displayxo[2] != "") {
      setState(() {
        resultD = "Player ${displayxo[2]} Wins!";
        matchedIndexes.addAll([2, 5, 8]);
        stopTimer();
        _updateScore(displayxo[2]);
      });
    } //diagonal
    if (displayxo[0] == displayxo[4] &&
        displayxo[0] == displayxo[8] &&
        displayxo[0] != "") {
      setState(() {
        matchedIndexes.addAll([0, 4, 8]);
        stopTimer();
        resultD = "Player ${displayxo[0]} Wins!";
        _updateScore(displayxo[0]);
      });
    } //second diagonal
    if (displayxo[2] == displayxo[4] &&
        displayxo[2] == displayxo[6] &&
        displayxo[2] != "") {
      setState(() {
        matchedIndexes.addAll([2, 4, 6]);
        stopTimer();
        resultD = "Player ${displayxo[2]} Wins!";
        _updateScore(displayxo[2]);
      });
    } else if (filledBoxes == 9) {
      setState(() {
        stopTimer();
        resultD = "Nobody Wins!";
      });
    }
  }

  void _updateScore(String winner) {
    if (winner == "O") {
      oScore++;
    } else if (winner == "X") {
      xScore++;
    }
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayxo[i] = "";
      }
      resultD = '';
      xScore = 0;
      oScore = 0;
      filledBoxes = 0;
      matchedIndexes.clear();
    });
  }

  Widget _buildTimer() {
    final isRunning = timer == null ? false : timer!.isActive;
    return isRunning
        ? SizedBox(
            height: 100,
            width: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1 - seconds / maxSeconds,
                  valueColor: const AlwaysStoppedAnimation(
                    Colors.white,
                  ),
                  strokeWidth: 8,
                  backgroundColor: Colors.blueAccent,
                ),
                Center(
                  child: Text(
                    '$seconds',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 50,
                    ),
                  ),
                )
              ],
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            onPressed: () {
              startTimer();
              _clearBoard();
              attempts++;
            },
            child: Text(
              attempts == 0 ? "Start" : "Play Again",
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
          );
  }
}
