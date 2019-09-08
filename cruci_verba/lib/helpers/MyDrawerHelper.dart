import 'package:cruci_verba/classes/CrossWord.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../classes/Tuple.dart';

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

    num horizontaStarts = 0, verticalStarts = 0;

    List<Tuple4<num, num, num, num>> starts = c.getStarts();

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < coloumns; j++) {
        int pos = _contain(starts, i, j);

        horizontaStarts = pos == 0 ? horizontaStarts + 1 : horizontaStarts;
        verticalStarts = pos == 1 ? verticalStarts + 1 : verticalStarts;

        row.add(_square(
            ((lato * i) + border),
            ((lato * j) + topBorder),
            lato - latoBordo,
            board[i][j] == ' ' || board[i][j] == '*'
                ? Colors.black
                : Colors.white,
            board[i][j],
            pos == -1
                ? null
                : () {
                    print(pos);
                  }));
      }
    }

    return row;
  }

  static int _contain(List<Tuple4<num, num, num, num>> list, num x, num y) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].Item1 == x && list[i].Item2 == y) {
        return i;
      }
    }
    return -1;
  }

  static Widget _square(
    double left,
    double top,
    double lato,
    Color colore,
    String txt,
    Function() onClick,
  ) {
    return Positioned(
        left: left,
        top: top,
        width: lato,
        height: lato,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: GestureDetector(
                onTap: onClick,
                child: Container(
                  color: colore,
                  child: Stack(children: <Widget>[
                    onClick == null
                        ? new Positioned(
                            child: Container(),
                          )
                        : new Positioned(
                            left: 3,
                            top: 3,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "1",
                                style: TextStyle(
                                    fontSize: 7.0, fontWeight: FontWeight.bold),
                              ),
                            )),
                    new Positioned(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          txt.toUpperCase(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ]),
                ))));
  }
}
