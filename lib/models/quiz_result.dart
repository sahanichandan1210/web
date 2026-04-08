import 'dart:convert';

class QuizResult {
  QuizResult({
    required this.category,
    required this.score,
    required this.total,
    required this.timestamp,
  });

  final String category;
  final int score;
  final int total;
  final DateTime timestamp;

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'score': score,
      'total': total,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      category: map['category'] as String,
      score: map['score'] as int,
      total: map['total'] as int,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory QuizResult.fromJson(String source) =>
      QuizResult.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
