import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Models/Enums/game_mode.enum.dart';
import 'Enums/game_type.enum.dart';

class Game {
  String id;
  String title;
  GameMode mode;
  GameType type;

  Game({
    required this.title,
    required this.id,
    required this.mode,
    required this.type
  });

  factory Game.fromFirestore(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;

    return Game(
      id: doc.id,
      title: doc["title"],
      mode: GameMode.values.firstWhere((e) => e.name == data['mode']),
      type: GameType.values.firstWhere((e) => e.name == data['type']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "mode": mode.name,
      "type": type.name,
    };
  }
}