import 'dart:async';

import 'package:flutter/material.dart';

import '../models/question.dart';
import '../utils/question_bank.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.category});

  final String category;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const int _secondsPerQuestion = 15;

  late final List<Question> _questions;
  int _currentIndex = 0;
  int _score = 0;
  int _timeLeft = _secondsPerQuestion;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _questions = QuestionBank.questionsForCategory(widget.category, take: 3);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = _secondsPerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_timeLeft == 0) {
        _nextQuestion();
      } else {
        setState(() {
          _timeLeft--;
        });
      }
    });
  }

  void _onAnswerSelected(String selected) {
    final currentQuestion = _questions[_currentIndex];
    if (selected == currentQuestion.answer) {
      _score++;
    }
    _nextQuestion();
  }

  void _nextQuestion() {
    if (_currentIndex == _questions.length - 1) {
      _timer?.cancel();
      Navigator.of(context).pushReplacementNamed(
        ResultScreen.routeName,
        arguments: ResultArgs(
          category: widget.category,
          score: _score,
          total: _questions.length,
        ),
      );
      return;
    }

    setState(() {
      _currentIndex++;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.category)),
        body: const Center(child: Text('No questions available.')),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text('${widget.category} Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
            ),
            const SizedBox(height: 12),
            Text(
              'Question ${_currentIndex + 1}/${_questions.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.timer_outlined),
                const SizedBox(width: 6),
                Text('$_timeLeft sec'),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              question.question,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...question.options.map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _onAnswerSelected(option),
                    child: Text(option),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
