import 'package:fluter_prjcts/Models/answer.dart';

class Question {
  final String content;
  final List<Answer> answerOptions;

  Question({required this.content, required this.answerOptions});
}