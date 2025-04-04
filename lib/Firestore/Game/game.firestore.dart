import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Models/Enums/game_mode.enum.dart';
import 'package:fluter_prjcts/Models/Enums/game_type.enum.dart';

Future<String?> addGame(String title, GameType type, GameMode mode) async{
  try {
    var game = await FirebaseFirestore.instance.collection("games").add({
      'title' : title,
      'type' : type.name.toLowerCase(),
      'mode': mode.name.toUpperCase(),
    });
    return game.id;
  } on FirebaseException catch(e) {
    print(e.message);
    return null;
  }
}

Future<void> addTopicToGame(String gameId, Set<String> topicsIds) async{
  try {
    var db = FirebaseFirestore.instance;

    final gameRef = db.collection("games").doc(gameId);

    var gameSnapshot = await gameRef.get();

    if(!gameSnapshot.exists) {
      throw Exception("Error: Topic with ID $gameId does not exist.");
    }

    for(var topicId in topicsIds) {
      await db.collection("game-topics").add({
        'gameId' : gameId,
        'topicId' : topicId,
      });
    }

  } on FirebaseException catch(e) {
    print(e.message);
  }
}

Future<List<String>> getGameTopicIds(String gameId) async {
  final gameTopicsSnapshot = await FirebaseFirestore.instance
      .collection('game-topics')
      .where('gameId', isEqualTo: gameId)
      .get();

  final topicIds = gameTopicsSnapshot.docs
      .map((doc) => doc['topicId'] as String)
      .toList();

  return topicIds;
}

