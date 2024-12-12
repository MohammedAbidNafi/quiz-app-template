import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final String response =
        await rootBundle.loadString('assets/questions.json');
    final data = await json.decode(response);
    setState(() {
      _questions = data;
    });
  }

  void _answerQuestion(String answer) {
    if (_questions[_currentQuestionIndex]['answer'] == answer) {
      setState(() {
        _score += 5;
      });
    }
    setState(() {
      _currentQuestionIndex++;
    });
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestionIndex >= _questions.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Quiz Completed! Your score: $_score'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetQuiz,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              question['question'],
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ...question['options'].map<Widget>((option) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Color(0xFFE14761)),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  onPressed: () => _answerQuestion(option),
                  child: Text(option),
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            Text('Score: $_score'),
          ],
        ),
      ),
    );
  }
}
