import 'game.dart';
import 'topic.dart';
import 'player.dart';

class GameData {
  late Game game;
  final List<Topic> topics;
  final Player hostPlayer;
  final Player invitedPlayer;

  GameData({
    required this.game,
    required this.topics,
    required this.hostPlayer,
    required this.invitedPlayer,
  });

  Map<String, dynamic> toJson() {
    return {
      'game': game.toMap(),  // Assuming `toJson()` exists in `Game`
      'topics': topics.map((topic) => topic.toMap()).toList(),  // Convert list of Topic to JSON
      'hostPlayer': hostPlayer.toMap(),  // Assuming `toJson()` exists in `Player`
      'invitedPlayer': invitedPlayer.toMap(),  // Assuming `toJson()` exists in `Player`
    };
  }

  factory GameData.fromMap(Map<String, dynamic> data) {
    return GameData(
      game: Game.fromMap(data['game']),
      topics: List<Topic>.from(data['topics'].map((topic) => Topic.fromMap(topic))),
      hostPlayer: Player.fromMap(data['hostPlayer']),
      invitedPlayer: Player.fromMap(data['invitedPlayer']),
    );
  }
}