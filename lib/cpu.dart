import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CpuPage extends StatefulWidget {
  final int _difficulty;
  final bool _isPlayerFirst;

  const CpuPage(this._difficulty, this._isPlayerFirst, {Key? key})
      : super(key: key);

  @override
  State<CpuPage> createState() => _CpuPageState();
}

class _CpuPageState extends State<CpuPage> {
  List<String> choices = List<String>.filled(9, '', growable: false);
  int playerScore = 0;
  int cpuScore = 0;
  int draws = 0;

  List<Color?> playerColors = [Colors.deepPurple[300], Colors.green[400]];

  @override
  void initState() {
    if (widget._difficulty < 1 || widget._difficulty > 3) {
      throw ErrorHint("Something went wrong with the difficulty");
    }
    if (!widget._isPlayerFirst) {
      _cpuMoveEasy();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            widget._isPlayerFirst ? playerColors[0] : playerColors[1],
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
                          child: Text(
                              widget._difficulty == 1
                                  ? "[EASY] Scoreboard"
                                  : widget._difficulty == 2
                                      ? "[MEDIUM] Scoreboard"
                                      : "[HARD] Scoreboard",
                              style: GoogleFonts.pressStart2p(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 3,
                                      fontSize: 15)))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text("Player",
                                  style: GoogleFonts.pressStart2p(
                                      textStyle: const TextStyle(
                                          color: Colors.black, fontSize: 12))),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(playerScore.toString(),
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
                              Text("CPU",
                                  style: GoogleFonts.pressStart2p(
                                      textStyle: const TextStyle(
                                          color: Colors.black, fontSize: 12))),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(cpuScore.toString(),
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
                                      ? widget._isPlayerFirst
                                          ? playerColors[1]
                                          : playerColors[0]
                                      : widget._isPlayerFirst
                                          ? playerColors[0]
                                          : playerColors[1],
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
                      widget._isPlayerFirst
                          ? "It's your turn! Awaiting X move!"
                          : "It's your turn! Awaiting O move!",
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
                          Navigator.of(context)
                            ..pop()
                            ..pop();
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
        widget._isPlayerFirst ? choices[tapped] = 'X' : choices[tapped] = 'O';
        if (!_checkWinner()) {
          _cpuMove();
          _checkWinner();
        }
      }
    });
  }

  void _cpuMove() {
    if (widget._difficulty == 1) {
      _cpuMoveEasy();
    } else {
      if (widget._difficulty == 2) {
        if (widget._isPlayerFirst) {
          if (choices[0] == choices[1] &&
              choices[0] == 'X' &&
              choices[2] == '') {
            choices[2] = 'O';
          } else {
            if (choices[1] == choices[2] &&
                choices[1] == 'X' &&
                choices[0] == '') {
              choices[0] = 'O';
            } else {
              if (choices[0] == choices[2] &&
                  choices[0] == 'X' &&
                  choices[1] == '') {
                choices[1] = 'O';
              } else {
                if (choices[3] == choices[4] &&
                    choices[3] == 'X' &&
                    choices[5] == '') {
                  choices[5] = 'O';
                } else {
                  if (choices[4] == choices[5] &&
                      choices[4] == 'X' &&
                      choices[3] == '') {
                    choices[3] = 'O';
                  } else {
                    if (choices[3] == choices[5] &&
                        choices[3] == 'X' &&
                        choices[4] == '') {
                      choices[4] = 'O';
                    } else {
                      if (choices[6] == choices[7] &&
                          choices[6] == 'X' &&
                          choices[8] == '') {
                        choices[8] = 'O';
                      } else {
                        if (choices[7] == choices[8] &&
                            choices[7] == 'X' &&
                            choices[6] == '') {
                          choices[6] = 'O';
                        } else {
                          if (choices[6] == choices[8] &&
                              choices[6] == 'X' &&
                              choices[7] == '') {
                            choices[7] = 'O';
                          } else {
                            if (choices[0] == choices[3] &&
                                choices[0] == 'X' &&
                                choices[6] == '') {
                              choices[6] = 'O';
                            } else {
                              if (choices[3] == choices[6] &&
                                  choices[3] == 'X' &&
                                  choices[0] == '') {
                                choices[0] = 'O';
                              } else {
                                if (choices[0] == choices[6] &&
                                    choices[0] == 'X' &&
                                    choices[3] == '') {
                                  choices[3] = 'O';
                                } else {
                                  if (choices[1] == choices[4] &&
                                      choices[1] == 'X' &&
                                      choices[7] == '') {
                                    choices[7] = 'O';
                                  } else {
                                    if (choices[4] == choices[7] &&
                                        choices[4] == 'X' &&
                                        choices[1] == '') {
                                      choices[1] = 'O';
                                    } else {
                                      if (choices[1] == choices[7] &&
                                          choices[1] == 'X' &&
                                          choices[4] == '') {
                                        choices[4] = 'O';
                                      } else {
                                        if (choices[2] == choices[5] &&
                                            choices[2] == 'X' &&
                                            choices[8] == '') {
                                          choices[8] = 'O';
                                        } else {
                                          if (choices[5] == choices[8] &&
                                              choices[5] == 'X' &&
                                              choices[2] == '') {
                                            choices[2] = 'O';
                                          } else {
                                            if (choices[2] == choices[8] &&
                                                choices[2] == 'X' &&
                                                choices[5] == '') {
                                              choices[5] = 'O';
                                            } else {
                                              if (choices[0] == choices[4] &&
                                                  choices[0] == 'X' &&
                                                  choices[8] == '') {
                                                choices[8] = 'O';
                                              } else {
                                                if (choices[4] == choices[8] &&
                                                    choices[4] == 'X' &&
                                                    choices[0] == '') {
                                                  choices[0] = 'O';
                                                } else {
                                                  if (choices[0] ==
                                                          choices[8] &&
                                                      choices[0] == 'X' &&
                                                      choices[4] == '') {
                                                    choices[4] = 'O';
                                                  } else {
                                                    if (choices[2] ==
                                                            choices[4] &&
                                                        choices[2] == 'X' &&
                                                        choices[6] == '') {
                                                      choices[6] = 'O';
                                                    } else {
                                                      if (choices[4] ==
                                                              choices[6] &&
                                                          choices[4] == 'X' &&
                                                          choices[2] == '') {
                                                        choices[2] = 'O';
                                                      } else {
                                                        if (choices[2] ==
                                                                choices[6] &&
                                                            choices[2] == 'X' &&
                                                            choices[4] == '') {
                                                          choices[4] = 'O';
                                                        } else {
                                                          _cpuMoveEasy();
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
                }
              }
            }
          }
        } else {
          if (choices[0] == choices[1] &&
              choices[0] == 'O' &&
              choices[2] == '') {
            choices[2] = 'X';
          } else {
            if (choices[1] == choices[2] &&
                choices[1] == 'O' &&
                choices[0] == '') {
              choices[0] = 'X';
            } else {
              if (choices[0] == choices[2] &&
                  choices[0] == 'O' &&
                  choices[1] == '') {
                choices[1] = 'X';
              } else {
                if (choices[3] == choices[4] &&
                    choices[3] == 'O' &&
                    choices[5] == '') {
                  choices[5] = 'X';
                } else {
                  if (choices[4] == choices[5] &&
                      choices[4] == 'O' &&
                      choices[3] == '') {
                    choices[3] = 'X';
                  } else {
                    if (choices[3] == choices[5] &&
                        choices[3] == 'O' &&
                        choices[4] == '') {
                      choices[4] = 'X';
                    } else {
                      if (choices[6] == choices[7] &&
                          choices[6] == 'O' &&
                          choices[8] == '') {
                        choices[8] = 'X';
                      } else {
                        if (choices[7] == choices[8] &&
                            choices[7] == 'O' &&
                            choices[6] == '') {
                          choices[6] = 'X';
                        } else {
                          if (choices[6] == choices[8] &&
                              choices[6] == 'O' &&
                              choices[7] == '') {
                            choices[7] = 'X';
                          } else {
                            if (choices[0] == choices[3] &&
                                choices[0] == 'O' &&
                                choices[6] == '') {
                              choices[6] = 'X';
                            } else {
                              if (choices[3] == choices[6] &&
                                  choices[3] == 'O' &&
                                  choices[0] == '') {
                                choices[0] = 'X';
                              } else {
                                if (choices[0] == choices[6] &&
                                    choices[0] == 'O' &&
                                    choices[3] == '') {
                                  choices[3] = 'X';
                                } else {
                                  if (choices[1] == choices[4] &&
                                      choices[1] == 'O' &&
                                      choices[7] == '') {
                                    choices[7] = 'X';
                                  } else {
                                    if (choices[4] == choices[7] &&
                                        choices[4] == 'O' &&
                                        choices[1] == '') {
                                      choices[1] = 'X';
                                    } else {
                                      if (choices[1] == choices[7] &&
                                          choices[1] == 'O' &&
                                          choices[4] == '') {
                                        choices[4] = 'X';
                                      } else {
                                        if (choices[2] == choices[5] &&
                                            choices[2] == 'O' &&
                                            choices[8] == '') {
                                          choices[8] = 'X';
                                        } else {
                                          if (choices[5] == choices[8] &&
                                              choices[5] == 'O' &&
                                              choices[2] == '') {
                                            choices[2] = 'X';
                                          } else {
                                            if (choices[2] == choices[8] &&
                                                choices[2] == 'O' &&
                                                choices[5] == '') {
                                              choices[5] = 'X';
                                            } else {
                                              if (choices[0] == choices[4] &&
                                                  choices[0] == 'O' &&
                                                  choices[8] == '') {
                                                choices[8] = 'X';
                                              } else {
                                                if (choices[4] == choices[8] &&
                                                    choices[4] == 'O' &&
                                                    choices[0] == '') {
                                                  choices[0] = 'X';
                                                } else {
                                                  if (choices[0] ==
                                                          choices[8] &&
                                                      choices[0] == 'O' &&
                                                      choices[4] == '') {
                                                    choices[4] = 'X';
                                                  } else {
                                                    if (choices[2] ==
                                                            choices[4] &&
                                                        choices[2] == 'O' &&
                                                        choices[6] == '') {
                                                      choices[6] = 'X';
                                                    } else {
                                                      if (choices[4] ==
                                                              choices[6] &&
                                                          choices[4] == 'O' &&
                                                          choices[2] == '') {
                                                        choices[2] = 'X';
                                                      } else {
                                                        if (choices[2] ==
                                                                choices[6] &&
                                                            choices[2] == 'O' &&
                                                            choices[4] == '') {
                                                          choices[4] = 'X';
                                                        } else {
                                                          _cpuMoveEasy();
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
                }
              }
            }
          }
        }
      } else {
        if (widget._difficulty == 3) {
          int bestScore = -999;
          int bestMove = -1;
          for (int i = 0; i < 9; i++) {
            if (choices[i] == '') {
              choices[i] = widget._isPlayerFirst ? "O" : "X";
              int score = minimax(0, false);
              choices[i] = '';
              if (score > bestScore) {
                bestScore = score;
                bestMove = i;
              }
            }
          }
          widget._isPlayerFirst
              ? choices[bestMove] = 'O'
              : choices[bestMove] = 'X';
        }
      }
    }
  }

  int minimax(int depth, bool isMaximizing) {
    String result = _checkWinnerAlgo();
    if (result != '') {
      int score = result == 'X'
          ? (widget._isPlayerFirst ? -1 : 1)
          : result == "O"
              ? (widget._isPlayerFirst ? 1 : -1)
              : 0;
      return score;
    }
    if (isMaximizing) {
      int bestScoreMax = -999;
      for (int j = 0; j < 9; j++) {
        if (choices[j] == '') {
          choices[j] = widget._isPlayerFirst ? "O" : "X";
          int scoreMax = minimax(depth + 1, false);
          choices[j] = '';
          bestScoreMax = max(bestScoreMax, scoreMax);
        }
      }
      return bestScoreMax;
    } else {
      int bestScoreMin = 999;
      for (int j = 0; j < 9; j++) {
        if (choices[j] == '') {
          choices[j] = widget._isPlayerFirst ? "X" : "O";
          int scoreMin = minimax(depth + 1, true);
          choices[j] = '';
          bestScoreMin = min(bestScoreMin, scoreMin);
        }
      }
      return bestScoreMin;
    }
  }

  String _checkWinnerAlgo() {
    if (choices[0] == choices[1] &&
        choices[1] == choices[2] &&
        choices[0] != '') {
      return choices[0];
    } else {
      if (choices[3] == choices[4] &&
          choices[4] == choices[5] &&
          choices[3] != '') {
        return choices[3];
      } else {
        if (choices[6] == choices[7] &&
            choices[7] == choices[8] &&
            choices[6] != '') {
          return choices[6];
        } else {
          if (choices[0] == choices[4] &&
              choices[4] == choices[8] &&
              choices[0] != '') {
            return choices[0];
          } else {
            if (choices[2] == choices[4] &&
                choices[4] == choices[6] &&
                choices[2] != '') {
              return choices[2];
            } else {
              if (choices[0] == choices[3] &&
                  choices[3] == choices[6] &&
                  choices[0] != '') {
                return choices[0];
              } else {
                if (choices[1] == choices[4] &&
                    choices[4] == choices[7] &&
                    choices[1] != '') {
                  return choices[1];
                } else {
                  if (choices[2] == choices[5] &&
                      choices[5] == choices[8] &&
                      choices[2] != '') {
                    return choices[2];
                  } else {
                    if (!choices.contains('')) {
                      return 'T';
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return '';
  }

  void _cpuMoveEasy() {
    List<int> indexesOfRemainingTiles = List.empty(growable: true);
    for (int i = 0; i < 9; i++) {
      if (choices[i] == '') {
        indexesOfRemainingTiles.add(i);
      }
    }
    int randomIndex = indexesOfRemainingTiles[
        Random().nextInt(indexesOfRemainingTiles.length)];
    widget._isPlayerFirst
        ? choices[randomIndex] = 'O'
        : choices[randomIndex] = 'X';
  }

  bool _checkWinner() {
    if (choices[0] == choices[1] &&
        choices[1] == choices[2] &&
        choices[0] != '') {
      _showWinnerPopup(choices[0]);
      return true;
    } else {
      if (choices[3] == choices[4] &&
          choices[4] == choices[5] &&
          choices[3] != '') {
        _showWinnerPopup(choices[3]);
        return true;
      } else {
        if (choices[6] == choices[7] &&
            choices[7] == choices[8] &&
            choices[6] != '') {
          _showWinnerPopup(choices[6]);
          return true;
        } else {
          if (choices[0] == choices[4] &&
              choices[4] == choices[8] &&
              choices[0] != '') {
            _showWinnerPopup(choices[0]);
            return true;
          } else {
            if (choices[2] == choices[4] &&
                choices[4] == choices[6] &&
                choices[2] != '') {
              _showWinnerPopup(choices[2]);
              return true;
            } else {
              if (choices[0] == choices[3] &&
                  choices[3] == choices[6] &&
                  choices[0] != '') {
                _showWinnerPopup(choices[0]);
                return true;
              } else {
                if (choices[1] == choices[4] &&
                    choices[4] == choices[7] &&
                    choices[1] != '') {
                  _showWinnerPopup(choices[1]);
                  return true;
                } else {
                  if (choices[2] == choices[5] &&
                      choices[5] == choices[8] &&
                      choices[2] != '') {
                    _showWinnerPopup(choices[2]);
                    return true;
                  } else {
                    if (!choices.contains('')) {
                      _showWinnerPopup('');
                      return true;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return false;
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
                        ? widget._isPlayerFirst
                            ? "Well done! You won the round!"
                            : "Oops! CPU won the round!"
                        : widget._isPlayerFirst
                            ? "Oops! CPU won the round!"
                            : "Well done! You won the round!",
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
      if (widget._isPlayerFirst) {
        playerScore++;
      } else {
        cpuScore++;
      }
    } else {
      if (winner == "O") {
        if (widget._isPlayerFirst) {
          cpuScore++;
        } else {
          playerScore++;
        }
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
      if (!widget._isPlayerFirst) {
        _cpuMoveEasy();
      }
    });
  }
}
