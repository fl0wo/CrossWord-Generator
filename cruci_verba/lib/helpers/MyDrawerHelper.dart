import 'package:cruci_verba/classes/CrossWord.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyDrawerHelper {
  static getRowsInSquare(BuildContext context, double width, Crossword c) {
    var row = <Widget>[];

    const int percBorder = 10;
    const int topBorder = 100;
    const int percSquareBorder = 5;

    final int rows = c.getN();
    final int coloumns = c.getM();

    double width = MediaQuery.of(context).size.width;
    double border = width * percBorder / 100.0;

    double lato = (width - (border * 2)) / rows;
    double latoBordo = lato * percSquareBorder / 100.0;

    var board = c.getBoard();

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < coloumns; j++) {
        row.add(_square(
            ((lato * i) + border),
            ((lato * j) + topBorder),
            lato - latoBordo,
            board[i][j] == ' ' || board[i][j] == '*'
                ? Colors.black
                : Colors.white,
            board[i][j]));
      }
    }

    return row;
  }

  static Widget _square(
      double left, double top, double lato, Color colore, String txt) {
    return Positioned(
        left: left,
        top: top,
        width: lato,
        height: lato,
        child: Container(
            color: colore,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                txt,
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 14.0),
              ),
            )));
  }
}
