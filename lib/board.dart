import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tetris/piece.dart';
import 'package:tetris/pixel.dart';
import 'package:tetris/record.dart';
import 'package:tetris/values.dart';

// GAMEBOAR -> 2x2 grid with null as a empty space, and a color as non empty

//create game board
List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLegth,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

// game level
int getlevel = 1;
//game over
bool isGameOver = false;
// create a random object to generate a random tetrominio type
Random rand = Random();
Tetromino firstPiece = Tetromino.values[rand.nextInt(Tetromino.values.length)];

class _GameBoardState extends State<GameBoard> {
  //current teris piece
  Piece currentPiece = Piece(type: firstPiece);

  @override
  void initState() {
    super.initState();
    topsocore();

    // start the game
    startGame();
  }

  // the top score
  int? setHighScore;
  void topsocore() {
    // Atualizar a variável setHighScore com o valor do recorde máximo
    getHighScore().then((highScore) {
      setState(() {
        setHighScore = highScore;
      });
    });
  }

  Timer? gameTimer;
  int points = 0;
  int? level = getLevelValue(getlevel);
  Duration frameRate = Duration(milliseconds: 600);
  void startGame() {
    currentPiece.initializePiece();
    // frame rate
    int velocity = level ?? 600;
    frameRate = Duration(milliseconds: velocity);
    gameLoop(frameRate);
  }

  //game loop

  void gameLoop(Duration frameRate) {
    //stop timer if it exist
    gameTimer?.cancel();

    //init new timer
    gameTimer = Timer.periodic(frameRate, (timer) {
      setState(() {
        clarLines();
        checkLanding();
        updateLevel();
        if (isGameOver == true) {
          timer.cancel();
          showGameOverDialog();
        }

        // move current piece down
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  void showGameOverDialog() {
    saveHighScore(points);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'FIM DE JOGO',
          style: GoogleFonts.pressStart2p(
            fontSize: 20,
            color: Colors.amber,
          ),
        ),
        content: Text(
          'VOCÊ FEZ $points PONTOS',
          style: GoogleFonts.pressStart2p(
            fontSize: 16,
            color: Colors.amber,
          ),
        ),
        backgroundColor: Colors.grey[800],
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              resetGame();
            },
            icon: Icon(
              Icons.play_arrow,
              color: Colors.black,
            ),
            label: Text(
              'Jogar Novamente',
              style: GoogleFonts.pressStart2p(
                color: Colors.black,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  //reset game
  void resetGame() {
    setState(() {
      gameBoard = List.generate(
        colLength,
        (i) => List.generate(
          rowLegth,
          (j) => null,
        ),
      );
      isGameOver = false;
      topsocore();
      up = 10;
      points = 0;
      getlevel = 1;
      createNewPiece();
      startGame();
    });
  }

  //colision detection - true if is colisoon, false if isnt
  bool checkCollision(Direction direction) {
    // loop through each position of the current peace each position
    for (int i = 0; i < currentPiece.position.length; i++) {
      //calculate the row and column of the current piece
      int row = (currentPiece.position[i] / rowLegth).floor();
      int col = currentPiece.position[i] % rowLegth;

      // adjust the row and col based on the direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }
      // check if the piece is out of bounds (low, left, right)
      if (row >= colLength || col < 0 || col >= rowLegth) {
        return true;
      } else if (row > 0 && gameBoard[row][col] != null) {
        return true;
      }
    }
    // if collision is detected return false
    return false;
  }

  void checkLanding() {
    // if going down  is occupied
    if (checkCollision(Direction.down)) {
      // mark position as occupied on the gameboard
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLegth).floor();
        int col = currentPiece.position[i] % rowLegth;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      //onde landed, create the next piece
      createNewPiece();
    }
  }

  void createNewPiece() {
    // create a new piece with random type
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();

    // check game over!!!!!!!!!!!!!!
    if (gameOver()) {
      isGameOver = true;
    }
  }

  // move left
  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  // move right
  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  // rotate
  void rotatePiece() {
    currentPiece.rotatePiece();
  }

  // speedUp
  void setSpeedUp(bool isButtonPressed) {
    if (isButtonPressed) {
      int speedup = ((level ?? 600) / 3).floor();
      frameRate = Duration(milliseconds: speedup);
    } else {
      frameRate = Duration(milliseconds: level ?? 600);
    }
    // Reinicie o timer do gameLoop com a nova velocidade
    gameLoop(frameRate);
  }

  //claer line function
  void clarLines() {
    //loop each row - bottom to top
    for (int row = colLength - 1; row >= 0; row--) {
      //variable to track if row is full
      bool rowFull = true;

      //put pieces in all parts of the row if row is full
      for (int col = 0; col < rowLegth; col++) {
        //if any empity colum set rowFull to false and out of the loop
        if (gameBoard[row][col] == null) {
          rowFull = false;
          break;
        }
      }
      //clear the row
      if (rowFull) {
        //moving all rows above
        for (int r = row; r > 0; r--) {
          //copy above row to current
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }
        //top row to empty
        gameBoard[0] = List.generate(rowLegth, (index) => null);

        //increase points
        points += getlevel;
      }
    }
  }

  //GAME OVER
  bool gameOver() {
    for (int col = 0; col < rowLegth; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }
    return false;
  }

  // update level
  int up = 10;
  void updateLevel() {
    if (getlevel > 0 && points > getlevel * up) {
      getlevel++;
      up += 5;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 63, 70, 64),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 10.0,
                    ),
                  ),
                  child: GridView.builder(
                    itemCount: rowLegth * colLength,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowLegth,
                    ),
                    itemBuilder: (context, index) {
                      // get row and col of each index
                      int row = (index / rowLegth).floor();
                      int col = index % rowLegth;

                      if (currentPiece.position.contains(index)) {
                        // current piece
                        return Pixel(
                          color: Color.fromARGB(62, 9, 9, 9),
                          child: '',
                        );
                      }

                      // landed pieces
                      else if (gameBoard[row][col] != null) {
                        return Pixel(
                          color: Color.fromARGB(189, 25, 25, 25),
                          child: '',
                        );
                      } else {
                        // black pixel
                        return Pixel(
                          color: Color.fromARGB(100, 80, 80, 80),
                          child: '',
                        );
                      }
                    },
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(193, 63, 84, 70),
                  border: Border.all(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 5.0,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TOP: $setHighScore', // Substitua pela sua variável de level
                        style: GoogleFonts.pressStart2p(
                          textStyle: TextStyle(
                            color: Color.fromARGB(189, 25, 25, 25),
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                      Text(
                        'LEVEL: $getlevel', // Substitua pela sua variável de level
                        style: GoogleFonts.pressStart2p(
                          textStyle: TextStyle(
                            color: Color.fromARGB(189, 25, 25, 25),
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Text(
                        'PONTOS: $points', // Substitua pela sua variável de pontos
                        style: GoogleFonts.pressStart2p(
                          textStyle: TextStyle(
                            color: Color.fromARGB(189, 25, 25, 25),
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // game controlls
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //left
                    RawMaterialButton(
                      onPressed: moveLeft,
                      elevation: 3.0,
                      fillColor: Colors.amber,
                      shape: const CircleBorder(),
                      constraints: const BoxConstraints.tightFor(
                        width: 54.0,
                        height: 54.0,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Color.fromARGB(255, 37, 29, 29),
                      ),
                    ),

                    //speedup
                    Listener(
                      onPointerDown: (_) {
                        setState(() {
                          setSpeedUp(true);
                        });
                      },
                      onPointerUp: (_) {
                        setState(() {
                          setSpeedUp(false);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.red,
                            width: 5.0,
                          ),
                        ),
                        child: RawMaterialButton(
                          onPressed: () {},
                          elevation: 3.0,
                          fillColor: Colors.amber,
                          shape: const CircleBorder(),
                          constraints: const BoxConstraints.tightFor(
                            width: 40.0,
                            height: 40.0,
                          ),
                          child: const Icon(
                            Icons.arrow_downward_outlined,
                            color: Color.fromARGB(255, 37, 29, 29),
                          ),
                        ),
                      ),
                    ),

                    //rotate
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.amber,
                          width: 5.0,
                        ),
                      ),
                      child: RawMaterialButton(
                        onPressed: rotatePiece,
                        elevation: 3.0,
                        fillColor: Colors.amber,
                        shape: const CircleBorder(),
                        constraints: const BoxConstraints.tightFor(
                          width: 40.0,
                          height: 40.0,
                        ),
                        child: const Icon(
                          Icons.rotate_right,
                          color: Color.fromARGB(255, 37, 29, 29),
                        ),
                      ),
                    ),

                    //right
                    RawMaterialButton(
                      onPressed: moveRight,
                      elevation: 4.0,
                      fillColor: Colors.amber,
                      shape: const CircleBorder(),
                      constraints: const BoxConstraints.tightFor(
                        width: 54.0,
                        height: 54.0,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Color.fromARGB(255, 37, 29, 29),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
