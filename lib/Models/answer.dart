import 'package:cloud_firestore/cloud_firestore.dart';

class Answer {
  final String id;
  final String content;
  final bool isCorrect;
  final String? questionId;

  Answer({
    required this.id,
    required this.content,
    required this.isCorrect,
    required this.questionId,
  });

  factory Answer.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Answer(
      id: doc.id,
      content: data['content'],
      isCorrect: data['isCorrect'],
      questionId: data['questionId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'isCorrect': isCorrect,
      'questionId': questionId,
    };
  }
}
