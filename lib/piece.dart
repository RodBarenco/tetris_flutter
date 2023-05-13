import 'package:flutter/material.dart';
import 'package:tetris/board.dart';

import 'values.dart';

class Piece {
  // types od tetris pieces
  Tetromino type;

  Piece({required this.type});

  //the piece is just a list of ints
  List<int> position = [];

  // generate the ints
  void initializePiece() {
    switch (type) {
      case Tetromino.L:
        position = [
          -26,
          -16,
          -6,
          -5,
        ];
        break;
      case Tetromino.J:
        position = [
          -25,
          -15,
          -5,
          -6,
        ];
        break;
      case Tetromino.I:
        position = [
          -4,
          -5,
          -6,
          -7,
        ];
        break;
      case Tetromino.O:
        position = [
          -15,
          -16,
          -5,
          -6,
        ];
        break;
      case Tetromino.S:
        position = [
          -15,
          -14,
          -6,
          -5,
        ];
        break;
      case Tetromino.T:
        position = [
          -26,
          -16,
          -6,
          -15,
        ];
        break;
      case Tetromino.Z:
        position = [
          -17,
          -16,
          -6,
          -5,
        ];
        break;
      default:
    }
  }

  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLegth;
        }
        break;
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
      default:
    }
  }

  // rotate piece
  int rotationState = 1;
  void rotatePiece() {
    List<int> newPosition = [];

    // rotate the piece based on it's type
    switch (type) {
      case Tetromino.L:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLegth,
              position[1],
              position[1] + rowLegth,
              position[1] + rowLegth + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLegth - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            newPosition = [
              position[1] + rowLegth,
              position[1],
              position[1] - rowLegth,
              position[1] - rowLegth - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            newPosition = [
              position[1] - rowLegth + 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;

      case Tetromino.J:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLegth,
              position[1],
              position[1] + rowLegth,
              position[1] + rowLegth - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            newPosition = [
              position[1] - rowLegth - 1,
              position[1],
              position[1] - 1,
              position[1] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            newPosition = [
              position[1] + rowLegth,
              position[1],
              position[1] - rowLegth,
              position[1] - rowLegth + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] + rowLegth + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;

      case Tetromino.I:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            newPosition = [
              position[1] - rowLegth,
              position[1],
              position[1] + rowLegth,
              position[1] + 2 * rowLegth,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] - 2,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            newPosition = [
              position[1] + rowLegth,
              position[1],
              position[1] - rowLegth,
              position[1] - 2 * rowLegth,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;

      case Tetromino.S:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLegth - 1,
              position[1] + rowLegth,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            newPosition = [
              position[0] - rowLegth,
              position[0],
              position[0] + 1,
              position[0] + rowLegth + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLegth - 1,
              position[1] + rowLegth,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            newPosition = [
              position[0] - rowLegth,
              position[0],
              position[0] + 1,
              position[0] + rowLegth + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;

      case Tetromino.Z:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[0] + rowLegth - 2,
              position[1],
              position[2] + rowLegth - 1,
              position[3] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            newPosition = [
              position[0] - rowLegth + 2,
              position[1],
              position[2] - rowLegth + 1,
              position[3] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            newPosition = [
              position[0] + rowLegth - 2,
              position[1],
              position[2] + rowLegth - 1,
              position[3] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            newPosition = [
              position[0] - rowLegth + 2,
              position[1],
              position[2] - rowLegth + 1,
              position[3] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;

      case Tetromino.T:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[2] - rowLegth,
              position[2],
              position[2] + 1,
              position[2] + rowLegth,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLegth,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            newPosition = [
              position[1] - rowLegth,
              position[1] - 1,
              position[1],
              position[1] + rowLegth,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            newPosition = [
              position[2] - rowLegth,
              position[2] - 1,
              position[2],
              position[2] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;

      default:
    }
  }

  // check if position is valid
  bool positionIsValid(int position) {
    int row = (position / rowLegth).floor();
    int col = position % rowLegth;

    // if the position is taken, reeturn false
    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    }

    // otherwise return true
    else {
      return true;
    }
  }

  // check if piece is valid position
  bool piecePositionIsValid(List<int> piecePosition) {
    bool firstColOcp = false;
    bool lastColOcp = false;

    for (int pos in piecePosition) {
      // return false if any posiytion is already taken
      if (!positionIsValid(pos)) {
        return false;
      }

      //get the position
      int col = pos % rowLegth;

      //check if the first or laast colum is occupied
      if (col == 0) {
        firstColOcp = true;
      }
      if (col == rowLegth - 1) {
        lastColOcp = true;
      }
    }

    //if there is a piece in the first col and last, its going true the wall
    return !(firstColOcp && lastColOcp);
  }
}
