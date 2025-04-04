import 'package:cloud_firestore/cloud_firestore.dart';

class Move {
  String id;
  String gameId;
  String playerId;
  String questionId;
  bool isCorrect;

  Move({
    required this.id,
    required this.gameId,
    required this.playerId,
    required this.questionId,
    required this.isCorrect,
  });

  factory Move.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Move(
      id: doc.id,
      gameId: data['gameId'],
      playerId: data['playerId'],
      questionId: data['questionId'],
      isCorrect: data['isCorrect'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'playerId': playerId,
      'isCorrect': isCorrect,
      'questionId': questionId,
    };
  }
}
