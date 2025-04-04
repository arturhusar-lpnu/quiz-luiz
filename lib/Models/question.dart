import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id;
  final String content;

  Question({required this.content, required this.id});

  factory Question.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Question(
      id: doc.id,
      content: data['content'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
    };
  }
}