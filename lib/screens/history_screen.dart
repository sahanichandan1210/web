import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/quiz_result.dart';
import '../services/local_storage_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  static const routeName = '/history';

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _storage = LocalStorageService();
  late Future<List<QuizResult>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _storage.loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz History')),
      body: FutureBuilder<List<QuizResult>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(
              child: Text('No quiz attempts yet. Start a quiz from home.'),
            );
          }

          return ListView.separated(
            itemCount: data.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = data[index];
              return ListTile(
                title: Text(item.category),
                subtitle: Text(DateFormat.yMMMd().add_jm().format(item.timestamp)),
                trailing: Text('${item.score}/${item.total}'),
              );
            },
          );
        },
      ),
    );
  }
}
