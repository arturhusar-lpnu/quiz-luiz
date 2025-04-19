part of "quiz.bloc.dart";

abstract class QuizEvent {}

class LoadNextQuestion extends QuizEvent {}

class EndQuiz extends QuizEvent{
  String result;
  EndQuiz(this.result);
}

class AnswerSubmitted extends QuizEvent {
  List<Answer> answers;
  String questionId;
  AnswerSubmitted(this.answers, this.questionId);
}