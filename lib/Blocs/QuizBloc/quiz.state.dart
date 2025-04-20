part of 'quiz.bloc.dart';

abstract class QuizState {}

class QuizInitState extends QuizState {}

class QuizLoaded extends QuizState {
  final Question currentQuestion;
  QuizLoaded(this.currentQuestion);
}

class QuizAnsweredCorrect extends QuizState {}

class QuizQuestionLoaded extends QuizState {
  Question currentQuestion;
  List<Answer> answers;
  String score;
  QuizQuestionLoaded(this.currentQuestion, this.answers, this.score);
}

class QuizAnsweredInCorrect extends QuizState {
}

class QuizAnswered extends QuizState {
}

class QuizCompleted extends QuizState {
  final String result;
  final String score;
  final List<Topic> solvedTopics;
  QuizCompleted(this.result, this.score, this.solvedTopics);
}
