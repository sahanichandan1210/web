import 'package:flutter/material.dart';

import '../services/local_storage_service.dart';
import '../utils/question_bank.dart';
import 'history_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = LocalStorageService();
  Map<String, int> _bestScores = {};

  @override
  void initState() {
    super.initState();
    _loadBestScores();
  }

  Future<void> _loadBestScores() async {
    final scores = await _storage.bestScoresByCategory();
    if (!mounted) return;
    setState(() {
      _bestScores = scores;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = QuestionBank.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Quiz App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () async {
              await Navigator.of(context).pushNamed(HistoryScreen.routeName);
              _loadBestScores();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a category',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final best = _bestScores[category];
                  return Card(
                    child: ListTile(
                      title: Text(category),
                      subtitle: Text(
                        best == null
                            ? 'Best score: No attempts yet'
                            : 'Best score: $best',
                      ),
                      trailing: const Icon(Icons.play_arrow),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(category: category),
                          ),
                        );
                        _loadBestScores();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
