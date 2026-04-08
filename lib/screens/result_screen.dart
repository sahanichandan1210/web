import 'package:flutter/material.dart';

import '../models/quiz_result.dart';
import '../services/local_storage_service.dart';

class ResultArgs {
  ResultArgs({
    required this.category,
    required this.score,
    required this.total,
  });

  final String category;
  final int score;
  final int total;
}

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  static const routeName = '/result';

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final _storage = LocalStorageService();
  bool _saved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_saved) return;

    final args = ModalRoute.of(context)!.settings.arguments as ResultArgs;
    _storage.saveResult(
      QuizResult(
        category: args.category,
        score: args.score,
        total: args.total,
        timestamp: DateTime.now(),
      ),
    );
    _saved = true;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ResultArgs;
    final percent = ((args.score / args.total) * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Result')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                args.category,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Text(
                'Score: ${args.score}/${args.total}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text('Performance: $percent%'),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                icon: const Icon(Icons.home),
                label: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
