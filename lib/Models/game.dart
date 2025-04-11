  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:fluter_prjcts/Models/Enums/game_mode.enum.dart';
  import 'Enums/game_type.enum.dart';

  class Game {
    String id;
    GameMode mode;
    GameType type;

    Game({
      required this.id,
      required this.mode,
      required this.type
    });

    factory Game.fromFirestore(DocumentSnapshot doc){
      final data = doc.data() as Map<String, dynamic>;

      return Game(
        id: doc.id,
        mode: GameMode.values.firstWhere((e) => e.name == data['mode']),
        type: GameType.values.firstWhere((e) => e.name == data['type']),
      );
    }

    factory Game.fromMap(Map<String, dynamic> data) {
      return Game(
        id: data["id"],
        mode: GameMode.values.firstWhere((e) => e.name == data['mode']),
        type: GameType.values.firstWhere((e) => e.name == data['type']),
      );
    }

    Map<String, dynamic> toMap() {
      return {
        "mode": mode.name,
        "type": type.name,
        "id" : id,
      };
    }
  }