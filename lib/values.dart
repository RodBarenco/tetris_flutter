// grid dimensions
int rowLegth = 10;
int colLength = 15;

//levels of the game
Map<int, int> level = {
  1: 600,
  2: 550,
  3: 500,
  4: 450,
  5: 400,
  6: 375,
  7: 350,
  8: 325,
  9: 300,
  10: 275,
  11: 250,
  12: 225,
  13: 200,
  14: 175,
  15: 150,
  16: 125,
  17: 100,
  18: 75,
  19: 40,
  20: 20,
};

int? getLevelValue(int key) {
  return level[key];
}

enum Tetromino {
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}

enum Direction {
  left,
  right,
  down,
}
