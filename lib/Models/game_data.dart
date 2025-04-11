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
      'game': game.toMap(),
      'topics': topics.map((topic) => topic.toMap()).toList(),
      'hostPlayer': hostPlayer.toMap(),
      'invitedPlayer': invitedPlayer.toMap(),
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