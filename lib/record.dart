import 'package:shared_preferences/shared_preferences.dart';

// Armazenar o recorde
Future<void> saveHighScore(int score) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int currentHighScore = prefs.getInt('highScore') ?? 0;

  // Verificar se o score atual é maior que o high score armazenado
  if (score > currentHighScore) {
    await prefs.setInt('highScore', score);
  }
}

// Obter o recorde armazenado
Future<int> getHighScore() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('highScore') ??
      0; // Valor padrão caso não haja recorde armazenado
}
