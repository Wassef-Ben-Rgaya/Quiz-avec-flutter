import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/screens/result_screen/result_screen.dart';
import 'package:quiz_app/screens/welcome_screen.dart';

class QuizResult {
  final String name;
  final double score;

  QuizResult(this.name, this.score);
}

class QuestionModel {
  final int id;
  final String question;
  final List<String> options;
  final int answer;

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.answer,
  });
}

class QuizController extends GetxController {
  String name = '';
  final List<QuizResult> quizResults = <QuizResult>[].obs;

  int get countOfQuestion => questionsList.length;
  List<QuestionModel> questionsList = [];

  bool _isPressed = false;
  bool get isPressed => _isPressed;

  double _numberOfQuestion = 1;
  double get numberOfQuestion => _numberOfQuestion;

  int? _selectAnswer;
  int? get selectAnswer => _selectAnswer;

  int? _correctAnswer;

  int _countOfCorrectAnswers = 0;
  int get countOfCorrectAnswers => _countOfCorrectAnswers;

  final Map<int, bool> _questionIsAnswered = {};

  late PageController pageController;

  Timer? _timer;
  final maxSec = 59;
  final RxInt _sec = 15.obs;
  RxInt get sec => _sec;

  get score => null;

  @override
  void onInit() {
    loadQuestions();
    pageController = PageController(initialPage: 0);
    resetAnswer();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  double get scoreResult {
    return _countOfCorrectAnswers * countOfQuestion / questionsList.length;
  }

  Future<void> loadQuestions() async {
    String jsonData = await rootBundle.loadString('assets/question.json');
    List<dynamic> jsonList = json.decode(jsonData);
    questionsList = jsonList.map((item) {
      return QuestionModel(
        id: item['id'],
        question: item['question'],
        options: List<String>.from(item['options']),
        answer: item['answer'],
      );
    }).toList();
  }

  void checkAnswer(QuestionModel questionModel, int selectAnswer) {
    _isPressed = true;

    _selectAnswer = selectAnswer;
    _correctAnswer = questionModel.answer;

    if (_correctAnswer == _selectAnswer) {
      _countOfCorrectAnswers++;
    }
    _questionIsAnswered.update(questionModel.id, (value) => true);
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => nextQuestion());
    update();
  }

  bool checkIsQuestionAnswered(int quesId) {
    return _questionIsAnswered.putIfAbsent(quesId, () => false);
  }

  void nextQuestion() {
    if (_timer != null && _timer!.isActive) {}

    if (pageController.page! < questionsList.length - 1) {
      _isPressed = false;
      pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
      _numberOfQuestion++;
      update();
    }
  }

  void resetAnswer() {
    for (var element in questionsList) {
      _questionIsAnswered.addAll({element.id: false});
    }
    update();
  }

  Color getColor(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Colors.green.shade700;
      } else if (answerIndex == _selectAnswer &&
          _correctAnswer != _selectAnswer) {
        return Colors.red.shade700;
      }
    }
    return Colors.white;
  }

  IconData getIcon(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Icons.done;
      } else if (answerIndex == _selectAnswer &&
          _correctAnswer != _selectAnswer) {
        return Icons.close;
      }
    }
    return Icons.close;
  }

  void startTimer() {
    resetTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sec.value > 0) {
        _sec.value--;
      } else {
        submitAnswers();
      }
    });
  }

  void resetTimer() => _sec.value = maxSec;

  void stopTimer() => _timer!.cancel();

  void startAgain() {
    _numberOfQuestion = 1;
    _correctAnswer = null;
    _countOfCorrectAnswers = 0;
    resetAnswer();
    _selectAnswer = null;
    Get.offAllNamed(WelcomeScreen.routeName);
  }

  void previousPage() {
    if (pageController.page! > 0) {
      // Vérifier si ce n'est pas la première page
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      _numberOfQuestion = pageController.page!;
      update();
    }
  }

  void submitAnswers() {
    stopTimer();
    quizResults.add(QuizResult(name, scoreResult));
    Get.offAndToNamed(ResultScreen.routeName);
  }

  int get countOfIncorrectAnswers {
    return countOfQuestion - _countOfCorrectAnswers;
  }

  int get countOfUnansweredQuestions {
    int count = 0;
    for (var question in questionsList) {
      if (_questionIsAnswered[question.id] == false) {
        count++;
      }
    }
    return count;
  }
}
