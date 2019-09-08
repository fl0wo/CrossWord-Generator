import 'dart:math';

import 'Tuple.dart';

class Crossword {
  String letters = "abcdefghijklmnopqrstuvwxyz";
  List<num> _dirX = [0, 1];
  List<num> _dirY = [1, 0];
  List<List<String>> _board;
  List<List<num>> _hWords;
  List<List<num>> _vWords;
  num _n;
  num _m;
  num _hCount, _vCount;
  static Random _rand;
  static List<String> _wordsToInsert;
  static List<List<String>> _tempBoard;
  static num _bestSol;
  DateTime initialTime;

  Crossword(num xDimen, num yDimen) {
    _n = xDimen;
    _m = yDimen;
    _rand = new Random();

    _board = new List<List<String>>(xDimen);
    _hWords = new List<List<num>>(xDimen);
    _vWords = new List<List<num>>(xDimen);

    for (var i = 0; i < _n; i++) {
      _board[i] = new List<String>(yDimen);
      _hWords[i] = new List<num>(yDimen);
      _vWords[i] = new List<num>(yDimen);

      for (var j = 0; j < _m; j++) {
        _board[i][j] = ' ';
      }
    }
  }

  String toString() {
    String result = "";
    for (num i = 0; i < _n; i++) {
      for (num j = 0; j < _m; j++) {
        result +=
            letters.contains(_board[i][j].toString()) ? _board[i][j] : ' ';
      }
      if (i < _n - 1) result += '\n';
    }
    return result;
  }

  String getAt(num r, num c) {
    return _board[r][c];
  }

  void setAt(num r, num c, String value) {
    _board[r][c] = value;
  }

  num getN() {
    return _n;
  }

  num getM() {
    return _m;
  }

  var inRTL;

  isValidPosition(num x, num y) {
    return x >= 0 && y >= 0 && x < _n && y < _m;
  }

  num canBePlaced(String word, num x, num y, num dir) {
    var result = 0;

    if (dir == 0) {
      for (var j = 0; j < word.length; j++) {
        num x1 = x, y1 = y + j;

        if (!(isValidPosition(x1, y1) &&
            (_board[x1][y1] == ' ' || _board[x1][y1] == word[j]))) return -1;
        if (isValidPosition(x1 - 1, y1)) if (_hWords[x1 - 1][y1] > 0) return -1;
        if (isValidPosition(x1 + 1, y1)) if (_hWords[x1 + 1][y1] > 0) return -1;
        if (_board[x1][y1] == word[j]) result++;
      }
    } else {
      for (var j = 0; j < word.length; j++) {
        num x1 = x + j, y1 = y;
        if (!(isValidPosition(x1, y1) &&
            (_board[x1][y1] == ' ' || _board[x1][y1] == word[j]))) return -1;
        if (isValidPosition(x1, y1 - 1)) if (_vWords[x1][y1 - 1] > 0) return -1;
        if (isValidPosition(x1, y1 + 1)) if (_vWords[x1][y1 + 1] > 0) return -1;
        if (_board[x1][y1] == word[j]) result++;
      }
    }

    num xStar = x - _dirX[dir], yStar = y - _dirY[dir];
    if (isValidPosition(xStar, yStar)) if (!(_board[xStar][yStar] == ' ' ||
        _board[xStar][yStar] == '*')) return -1;

    xStar = x + _dirX[dir] * word.length;
    yStar = y + _dirY[dir] * word.length;
    if (isValidPosition(xStar, yStar)) if (!(_board[xStar][yStar] == ' ' ||
        _board[xStar][yStar] == '*')) return -1;

    return result == word.length ? -1 : result;
  }

  void putWord(String word, num x, num y, num dir, num value) {
    var mat = dir == 0 ? _hWords : _vWords;

    for (var i = 0; i < word.length; i++) {
      num x1 = x + _dirX[dir] * i, y1 = y + _dirY[dir] * i;
      _board[x1][y1] = word[i];
      mat[x1][y1] = value;
    }

    num xStar = x - _dirX[dir], yStar = y - _dirY[dir];
    if (isValidPosition(xStar, yStar)) _board[xStar][yStar] = '*';
    xStar = x + _dirX[dir] * word.length;
    yStar = y + _dirY[dir] * word.length;
    if (isValidPosition(xStar, yStar)) _board[xStar][yStar] = '*';
  }

  num addWord(String word) {
    //var max = int.MaxValue;
    // region ubicate the word into the board
    var wordToInsert = word;
    var info = bestPosition(wordToInsert);
    if (info != null) {
      if (info.Item3 == 0) {
        _hCount++;
        // if (inRTL)
        // wordToInsert = word.Aggregate("", (x, y) => y + x);
      } else {
        _vCount++;
      }
      var value = info.Item3 == 0 ? _hCount : _vCount;
      putWord(wordToInsert, info.Item1, info.Item2, info.Item3, value);
      return info.Item3;
    }

    return -1;
  }

  List<Tuple<int, int, int>> findPositions(String word) {
    //region find best position to ubicate the word into the board
    var max = 0;
    var positions = new List<Tuple<int, int, int>>();
    for (var x = 0; x < _n; x++) {
      for (var y = 0; y < _m; y++) {
        for (var i = 0; i < _dirX.length; i++) {
          var dir = i;
          // var wordToInsert = i == 0 && inRTL ? word.Aggregate("", (a, b) => b + a) : word;
          var wordToInsert = word;

          var count = canBePlaced(wordToInsert, x, y, dir);

          if (count < max) continue;
          if (count > max) positions.clear();

          max = count;
          positions.add(new Tuple<int, int, int>(x, y, dir));
        }
      }
    }
    //endregion

    return positions;
  }

  Tuple<int, int, int> bestPosition(String word) {
    var positions = findPositions(word);
    if (positions.length > 0) {
      var index = _rand.nextInt(positions.length);
      return positions[index];
    }
    return null;
  }

  bool isLetter(String a) {
    return letters.contains(a.toString());
  }

  List<List<String>> getBoard() {
    return _board;
  }

  void reset() {
    for (var i = 0; i < _n; i++) {
      for (var j = 0; j < _m; j++) {
        _board[i][j] = ' ';
        _vWords[i][j] = 0;
        _hWords[i][j] = 0;
        _hCount = _vCount = 0;
      }
    }
  }

  void addWords(List<String> words) {
    _wordsToInsert = words;
    _bestSol = getN() * getM();
    initialTime = DateTime.now();
    gen(0);

    _board = _tempBoard;
  }

  int freeSpaces() {
    var count = 0;
    for (var i = 0; i < getN(); i++) {
      for (var j = 0; j < getM(); j++) {
        if (_board[i][j] == ' ' || _board[i][j] == '*') count++;
      }
    }
    return count;
  }

  void gen(int pos) {
    if (pos >= _wordsToInsert.length ||
        (DateTime.now().difference(initialTime)).inMinutes > 1) return;

    for (int i = pos; i < _wordsToInsert.length; i++) {
      var posi = bestPosition(_wordsToInsert[i]);
      if (posi != null) {
        var word = _wordsToInsert[i];
        // if (posi.Item3==0 && inRTL)
        //     word = word.Aggregate("", (x, y) => y + x);

        var value = posi.Item3 == 0 ? _hCount : _vCount;

        putWord(word, posi.Item1, posi.Item2, posi.Item3, value);
        gen(pos + 1);
        removeWord(word, posi.Item1, posi.Item2, posi.Item3);
      } else {
        gen(pos + 1);
      }
    }

    var c = freeSpaces();
    if (c >= _bestSol) return;
    _bestSol = c;
    _tempBoard = new List<List<String>>.from(_board);
  }

  void removeWord(String word, int x, int y, int dir) {
    var mat = dir == 0 ? _hWords : _vWords;
    var mat1 = dir == 0 ? _vWords : _hWords;

    for (var i = 0; i < word.length; i++) {
      int x1 = x + _dirX[dir] * i, y1 = y + _dirY[dir] * i;
      if (mat1[x1][y1] == 0) _board[x1][y1] = ' ';
      mat[x1][y1] = 0;
    }

    int xStar = x - _dirX[dir], yStar = y - _dirY[dir];
    if (isValidPosition(xStar, yStar) && hasFactibleValueAround(xStar, yStar))
      _board[xStar][yStar] = ' ';

    xStar = x + _dirX[dir] * word.length;
    yStar = y + _dirY[dir] * word.length;
    if (isValidPosition(xStar, yStar) && hasFactibleValueAround(xStar, yStar))
      _board[xStar][yStar] = ' ';
  }

  bool hasFactibleValueAround(int x, int y) {
    for (var i = 0; i < _dirX.length; i++) {
      int x1 = x + _dirX[i], y1 = y + _dirY[i];
      if (isValidPosition(x1, y1) &&
          (_board[x1][y1] != ' ' || _board[x1][y1] == '*')) return true;
      x1 = x - _dirX[i];
      y1 = y - _dirY[i];
      if (isValidPosition(x1, y1) &&
          (_board[x1][y1] != ' ' || _board[x1][y1] == '*')) return true;
    }
    return false;
  }
}
