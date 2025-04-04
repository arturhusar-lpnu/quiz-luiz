import 'package:cloud_firestore/cloud_firestore.dart';
import 'death_run.player.dart';

class DeathRunGame {
  final Map<String, DeathRunPlayer> players;
  final String status;
  final String currentQuestion;
  final String? winner;

  DeathRunGame({
    required this.players,
    required this.status,
    required this.currentQuestion,
    this.winner,
  });

  factory DeathRunGame.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final playersData = data['players'] as Map<String, dynamic>;

    final players = playersData.map((playerId, playerMap) =>
        MapEntry(playerId, DeathRunPlayer.fromMap(playerMap)));

    return DeathRunGame(
      players: players,
      status: data['status'],
      currentQuestion: data['currentQuestion'],
      winner: data['winner'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'players': players.map((key, value) => MapEntry(key, value.toMap())),
      'status': status,
      'currentQuestion': currentQuestion,
      'winner': winner,
    };
  }
}
