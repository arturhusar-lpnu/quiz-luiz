part of "question_bloc.dart";

abstract class QuestionState {
  const QuestionState();
}

class QuestionsInitial extends QuestionState {}

class QuestionsLoadSuccess extends QuestionState {
  List<Question> questions;
  QuestionsLoadSuccess(this.questions);
}

class QuestionAddedSuccess extends QuestionState {}

class QuestionAddFailure extends QuestionState {
  final String message;

  QuestionAddFailure(this.message);
}