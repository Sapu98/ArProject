import 'dart:math';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;


class ARTicTacToe extends StatefulWidget {
  @override
  _ARTicTacToeState createState() => _ARTicTacToeState();
}

class _ARTicTacToeState extends State<ARTicTacToe> {
  ArCoreController arCoreController;

  var displayXO = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];
  bool OTurn = true;
  bool playing = false;
  int filledBoxes = 0;
  final _random = new Random();
  ArCoreHitTestResult plane;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TicTacToe'),
        ),
        body: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enableTapRecognizer: true,
        ),
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => onTapHandler(name);
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  void _addBoard(ArCoreHitTestResult plane) {
    final board = ArCoreReferenceNode(
        name: "Board",
        objectUrl:
            "https://raw.githubusercontent.com/Sapu98/ArProject/master/assets/board.gltf",
        position: plane.pose.translation);

    arCoreController.addArCoreNodeWithAnchor(board);
  }

  _addX(ArCoreHitTestResult plane, int index) {
    int x = index ~/ 3;
    int y = index % 3;
    final node = ArCoreReferenceNode(
      name: "X_$index",
      objectUrl:
          "https://raw.githubusercontent.com/Sapu98/ArProject/master/assets/x.gltf",
      position: vector.Vector3(
          plane.pose.translation[0] + (0.22 * x) - 0.22,
          plane.pose.translation[1] + 0.01,
          plane.pose.translation[2] + (0.22 * y) - 0.22),
    );

    arCoreController.addArCoreNodeWithAnchor(node);
  }

  _addO(ArCoreHitTestResult plane, int index) {
    int x = index ~/ 3;
    int y = index % 3;
    final node = ArCoreReferenceNode(
      name: "O_$index",
      objectUrl: "https://raw.githubusercontent.com/Sapu98/ArProject/master/assets/o.gltf",
      position: vector.Vector3(
          plane.pose.translation[0] + (0.22 * x) - 0.22,
          plane.pose.translation[1] + 0.01,
          plane.pose.translation[2] + (0.22 * y) - 0.22),
    );
    arCoreController.addArCoreNodeWithAnchor(node);
  }

  _addEmpty(ArCoreHitTestResult plane, int index) {
    int x = index ~/ 3;
    int y = index % 3;
    final node = ArCoreReferenceNode(
      name: "Empty_$index",
      objectUrl: "assets/empty.gltf",
      position: vector.Vector3(
          plane.pose.translation[0] + (0.22 * x) - 0.22,
          plane.pose.translation[1] + 0.02,
          plane.pose.translation[2] + (0.22 * y) - 0.22),
    );
    arCoreController.addArCoreNodeWithAnchor(node);
  }

  //crea il piano e lo popola di oggetti invisibili
  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    if (!playing) {
      final hit = hits.first;
      setState(() {
        plane = hit;
        playing = true;
      });
      _addBoard(hit);
      for (int i = 0; i < 9; i++) {
        _addEmpty(hit, i);
      }
    }
  }

  void onTapHandler(String name) {
    if (name.contains("Empty")) {
      int index = int.parse(name.substring(6));
      _tapped(index);
    }
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  void _tapped(int index) {
    setState(() {
      if (OTurn && displayXO[index] == '') {
        displayXO[index] = 'O';
        filledBoxes++;
        _addO(plane, index);
      } else if (!OTurn && displayXO[index] == '') {
        displayXO[index] = 'X';
        filledBoxes++;
        _addX(plane, index);
      }
      arCoreController.removeNode(nodeName: "Empty_$index");
      OTurn = !OTurn;
      _checkWinner();
    });
    if (playing && filledBoxes<8) {
      _aiMove();
    }
  }

  int getRandomEmpty() {
    String value = "x";
    int index = -1;

    while (value != "") {
      int rng = _random.nextInt(8);
      value = displayXO[rng];
      index = rng;
    }
    return index;
  }

  void _aiMove() {
    int index = getRandomEmpty();
    setState(() {
      if (OTurn && displayXO[index] == '') {
        displayXO[index] = 'O';
        filledBoxes += 1;
        _addO(plane, index);
      } else if (!OTurn && displayXO[index] == '') {
        displayXO[index] = 'X';
        filledBoxes += 1;
        _addX(plane, index);
      }
    });
    arCoreController.removeNode(nodeName: "Empty_$index");
    OTurn = !OTurn;
    _checkWinner();
  }

  void _checkWinner() {
    if (displayXO[0] == displayXO[1] &&
        displayXO[0] == displayXO[2] &&
        displayXO[0] != '') {
      _showWinDialog(displayXO[0]);
    } else if (displayXO[3] == displayXO[4] &&
        displayXO[3] == displayXO[5] &&
        displayXO[3] != '') {
      _showWinDialog(displayXO[3]);
    } else if (displayXO[6] == displayXO[7] &&
        displayXO[6] == displayXO[8] &&
        displayXO[6] != '') {
      _showWinDialog(displayXO[6]);
    } else if (displayXO[0] == displayXO[3] &&
        displayXO[0] == displayXO[6] &&
        displayXO[0] != '') {
      _showWinDialog(displayXO[0]);
    } else if (displayXO[1] == displayXO[4] &&
        displayXO[1] == displayXO[7] &&
        displayXO[1] != '') {
      _showWinDialog(displayXO[1]);
    } else if (displayXO[2] == displayXO[5] &&
        displayXO[2] == displayXO[8] &&
        displayXO[2] != '') {
      _showWinDialog(displayXO[2]);
    } else if (displayXO[6] == displayXO[4] &&
        displayXO[6] == displayXO[2] &&
        displayXO[6] != '') {
      _showWinDialog(displayXO[6]);
    } else if (displayXO[0] == displayXO[4] &&
        displayXO[0] == displayXO[8] &&
        displayXO[0] != '') {
      _showWinDialog(displayXO[0]);
    } else if (filledBoxes == 9) {
      _showDrawDialog();
    }
  }

  void _showDrawDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Draw'),
            actions: <Widget>[
              TextButton(
                child: Text('Play Again!'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _clearBoard();
                },
              )
            ],
          );
        });
  }

  void _showWinDialog(String winner) {
    setState(() {
      playing = false;
    });
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Winner is: ' + winner),
            actions: <Widget>[
              TextButton(
                child: Text('Play Again!'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _clearBoard();
                },
              )
            ],
          );
        });
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayXO[i] = '';
      }
    });
    arCoreController.removeNode(nodeName: "Board");
    for (int i = 0; i < 9; i++) {
      arCoreController.removeNode(nodeName: "Empty_$i");
      arCoreController.removeNode(nodeName: "X_$i");
      arCoreController.removeNode(nodeName: "O_$i");
    }
    filledBoxes = 0;
  }
}
