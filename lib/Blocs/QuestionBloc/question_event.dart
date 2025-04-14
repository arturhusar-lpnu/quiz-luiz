part of 'question_bloc.dart';

abstract class QuestionEvent {
  const QuestionEvent();
}

class SubscribeQuestions extends QuestionEvent {
  String topicId;
  SubscribeQuestions(this.topicId);
}

class QuestionsUpdated extends QuestionEvent {
  List<Question> questions;
  QuestionsUpdated(this.questions);
}

class AddNewQuestion extends QuestionEvent {
  final String topicId;
  final String content;

  AddNewQuestion({required this.topicId, required this.content});
}