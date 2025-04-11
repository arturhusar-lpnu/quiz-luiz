import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String username;
  String id;
  String email;
  Player({required this.id, required this.username, required this.email});

  factory Player.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Player(
      id: doc.id,
      email: data['email'],
      username: data["username"],
    );
  }

  factory Player.fromMap(Map<String, dynamic> data) {
    return Player(
      id: data["id"],
      email: data['email'],
      username: data["username"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "username" : username,
      'email': email,
      "id" : id,
    };
  }
}