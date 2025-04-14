part of "answer_bloc.dart";

abstract class AnswerState {
  const AnswerState();
}

class AnswerInitial extends AnswerState {}

class AnswerLoadSuccess extends AnswerState {
  List<Answer> answers;
  AnswerLoadSuccess(this.answers);
}

