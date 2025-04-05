import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id;
  late String content;
  final String topicId;
  Question({required this.content, required this.id, required this.topicId});

  factory Question.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Question(
      id: doc.id,
      content: data['content'],
      topicId: data['topicId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'topicId' : topicId,
    };
  }
}