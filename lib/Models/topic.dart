import 'package:fluter_prjcts/Models/question.dart';

class Topic {
  String id;
  String title;
  String description;
  List<Question> questions;

  Topic({
    required this.id,
    required this.title,
    required this.description,
    required this.questions
  });
}