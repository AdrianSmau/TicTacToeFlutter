import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MultiplayerPage extends StatefulWidget {
  const MultiplayerPage({Key? key}) : super(key: key);

  @override
  State<MultiplayerPage> createState() => _MultiplayerPageState();
}

class _MultiplayerPageState extends State<MultiplayerPage> {
  bool isXTurn = true;
  List<String> choices = List<String>.filled(9, '', growable: false);
  int player1Score = 0;
  int player2Score = 0;
  int draws = 0;

  List<Color?> playerColors = [Colors.deepPurple[300], Colors.green[400]];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: isXTurn ? playerColors[0] : playerColors[1],
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Text("Scoreboard",
                              style: GoogleFonts.pressStart2p(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 3,
                                      fontSize: 25)))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text("Player1",
                                  style: GoogleFonts.pressStart2p(
                                      textStyle: const TextStyle(
                                          color: Colors.black, fontSize: 12))),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(player1Score.toString(),
                                    style: GoogleFonts.pressStart2p(
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12))),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text("Draws",
                                  style: GoogleFonts.pressStart2p(
                                      textStyle: const TextStyle(
                                          color: Colors.black, fontSize: 12))),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(draws.toString(),
                                    style: GoogleFonts.pressStart2p(
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12))),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text("Player2",
                                  style: GoogleFonts.pressStart2p(
                                      textStyle: const TextStyle(
                                          color: Colors.black, fontSize: 12))),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(player2Score.toString(),
                                    style: GoogleFonts.pressStart2p(
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12))),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  )),
              Expanded(
                flex: 7,
                child: SizedBox(
                  width: 9 * MediaQuery.of(context).size.width / 10,
                  child: GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 9,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            _makeMove(index);
                          },
                          child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: choices[index] != ''
                                      ? (isXTurn
                                          ? playerColors[1]
                                          : playerColors[0])
                                      : (isXTurn
                                          ? playerColors[0]
                                          : playerColors[1]),
                                  border: Border.all(
                                      color: Colors.black, width: 2)),
                              child: Center(
                                  child: Text(
                                choices[index],
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 36),
                              ))),
                        );
                      }),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                      isXTurn
                          ? "[Player1 turn] Awaiting X move!"
                          : "[Player2 turn] Awaiting O move!",
                      style: GoogleFonts.novaSlim(
                          textStyle: const TextStyle(
                              color: Colors.black, fontSize: 24))),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _clearBoard,
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            textStyle: GoogleFonts.novaSlim(
                                textStyle: const TextStyle(
                                    color: Colors.black, fontSize: 20))),
                        child: const Text('Reset Round'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            textStyle: GoogleFonts.novaSlim(
                                textStyle: const TextStyle(
                                    color: Colors.black, fontSize: 20))),
                        child: const Text('Return to Menu'),
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }

  void _makeMove(int tapped) {
    setState(() {
      if (choices[tapped] == '') {
        isXTurn ? choices[tapped] = 'X' : choices[tapped] = 'O';
        isXTurn = !isXTurn;
        _checkWinner();
      }
    });
  }

  void _checkWinner() {
    if (choices[0] == choices[1] &&
        choices[1] == choices[2] &&
        choices[0] != '') {
      _showWinnerPopup(choices[0]);
    } else {
      if (choices[3] == choices[4] &&
          choices[4] == choices[5] &&
          choices[3] != '') {
        _showWinnerPopup(choices[3]);
      } else {
        if (choices[6] == choices[7] &&
            choices[7] == choices[8] &&
            choices[6] != '') {
          _showWinnerPopup(choices[6]);
        } else {
          if (choices[0] == choices[4] &&
              choices[4] == choices[8] &&
              choices[0] != '') {
            _showWinnerPopup(choices[0]);
          } else {
            if (choices[2] == choices[4] &&
                choices[4] == choices[6] &&
                choices[2] != '') {
              _showWinnerPopup(choices[2]);
            } else {
              if (choices[0] == choices[3] &&
                  choices[3] == choices[6] &&
                  choices[0] != '') {
                _showWinnerPopup(choices[0]);
              } else {
                if (choices[1] == choices[4] &&
                    choices[4] == choices[7] &&
                    choices[1] != '') {
                  _showWinnerPopup(choices[1]);
                } else {
                  if (choices[2] == choices[5] &&
                      choices[5] == choices[8] &&
                      choices[2] != '') {
                    _showWinnerPopup(choices[2]);
                  } else {
                    if (!choices.contains('')) {
                      _showWinnerPopup('');
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  void _showWinnerPopup(String winner) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                winner == ''
                    ? "Match ended in a draw!"
                    : winner == 'X'
                        ? "Player1 won the round!"
                        : "Player2 won the round!",
                style: GoogleFonts.pressStart2p(
                    textStyle:
                        const TextStyle(color: Colors.black, fontSize: 12))),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  _clearBoard();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    textStyle: GoogleFonts.novaSlim(
                        textStyle: const TextStyle(
                            color: Colors.black, fontSize: 18))),
                child: const Text('Play Again'),
              ),
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                  },
                  style: OutlinedButton.styleFrom(
                      primary: Colors.black,
                      textStyle: GoogleFonts.novaSlim(
                          textStyle: const TextStyle(
                              color: Colors.black, fontSize: 18))),
                  child: const Text('Main Menu'))
            ],
          );
        });
    if (winner == "X") {
      player1Score++;
    } else {
      if (winner == "O") {
        player2Score++;
      } else {
        draws++;
      }
    }
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        choices[i] = '';
      }
      isXTurn = true;
    });
  }
}
