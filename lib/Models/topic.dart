import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  String id;
  String title;
  String description;

  Topic({
    required this.id,
    required this.title,
    required this.description
  });

  factory Topic.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Topic(
      id: doc.id,
      title: data['title'],
      description: data["description"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title" : title,
      'description': description,
    };
  }
}