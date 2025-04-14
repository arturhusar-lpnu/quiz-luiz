part of "answer_bloc.dart";

abstract class AnswerEvent {}

class SubscribeAnswers extends AnswerEvent {
  String questionId;
  SubscribeAnswers(this.questionId);
}

class AnswersUpdated extends AnswerEvent {
  List<Answer> answers;
  AnswersUpdated(this.answers);
}