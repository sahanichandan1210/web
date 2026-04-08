import 'dart:math';

import '../models/question.dart';

class QuestionBank {
  static final Map<String, List<Question>> _questionsByCategory = {
    'GK': const [
      Question(
        question: 'What is the capital of France?',
        options: ['Paris', 'Berlin', 'Madrid', 'Rome'],
        answer: 'Paris',
      ),
      Question(
        question: 'Which planet is known as the Red Planet?',
        options: ['Venus', 'Mars', 'Saturn', 'Jupiter'],
        answer: 'Mars',
      ),
      Question(
        question: 'Who wrote the Indian national anthem?',
        options: [
          'Rabindranath Tagore',
          'Bankim Chandra Chattopadhyay',
          'Mahatma Gandhi',
          'Sarojini Naidu'
        ],
        answer: 'Rabindranath Tagore',
      ),
    ],
    'Programming': const [
      Question(
        question: 'What is Flutter?',
        options: ['SDK', 'Language', 'IDE', 'OS'],
        answer: 'SDK',
      ),
      Question(
        question: 'Which language is used for Flutter app development?',
        options: ['Kotlin', 'Java', 'Dart', 'Swift'],
        answer: 'Dart',
      ),
      Question(
        question: 'What does OOP stand for?',
        options: [
          'Object-Oriented Programming',
          'Only One Program',
          'Open Operational Protocol',
          'Object Over Process'
        ],
        answer: 'Object-Oriented Programming',
      ),
    ],
    'Science': const [
      Question(
        question: 'What gas do plants absorb from the atmosphere?',
        options: ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Hydrogen'],
        answer: 'Carbon Dioxide',
      ),
      Question(
        question: 'What is H2O commonly known as?',
        options: ['Hydrogen', 'Water', 'Salt', 'Oxygen'],
        answer: 'Water',
      ),
      Question(
        question: 'How many bones are in the adult human body?',
        options: ['106', '206', '306', '406'],
        answer: '206',
      ),
    ],
  };

  static List<String> get categories => _questionsByCategory.keys.toList();

  static List<Question> questionsForCategory(String category, {int take = 3}) {
    final questions = List<Question>.from(_questionsByCategory[category] ?? const []);
    questions.shuffle(Random());
    if (questions.length <= take) {
      return questions;
    }
    return questions.take(take).toList();
  }
}
