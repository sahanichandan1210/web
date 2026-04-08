import 'package:shared_preferences/shared_preferences.dart';

import '../models/quiz_result.dart';

class LocalStorageService {
  static const String _historyKey = 'quiz_history';

  Future<List<QuizResult>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final rawHistory = prefs.getStringList(_historyKey) ?? [];
    return rawHistory.map(QuizResult.fromJson).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> saveResult(QuizResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_historyKey) ?? [];
    current.add(result.toJson());
    await prefs.setStringList(_historyKey, current);
  }

  Future<Map<String, int>> bestScoresByCategory() async {
    final history = await loadHistory();
    final Map<String, int> best = {};

    for (final item in history) {
      final previous = best[item.category] ?? 0;
      if (item.score > previous) {
        best[item.category] = item.score;
      }
    }
    return best;
  }
}
