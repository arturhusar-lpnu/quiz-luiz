import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username;
  String id;
  String email;
  User({required this.id, required this.username, required this.email});

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      email: data['email'],
      username: data["username"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "username" : username,
      'email': email,
    };
  }
}