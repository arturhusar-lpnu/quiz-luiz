import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Firestore/Game/DeathRun/death_run.firestore.dart';
import 'package:fluter_prjcts/Firestore/Player/player.firestore.dart';
import 'package:fluter_prjcts/Models/Enums/game_mode.enum.dart';
import 'package:fluter_prjcts/Models/Enums/game_type.enum.dart';
import 'package:fluter_prjcts/Models/game.dart';
import 'package:fluter_prjcts/Models/player.dart';

import '../../Models/topic.dart';
import '../Topic/topic.firestore.dart';

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

Future<Game> getGame(String gameId) async{
  final gameSnapshot = await FirebaseFirestore.instance.collection("games").doc(gameId).get();

  return Game.fromFirestore(gameSnapshot);
}

Future<List<Player>> getGamePlayers(String gameId) async {
  List<String> playerIds =  await getPlayerIdsFromDeathRun(gameId);
  List<Player> players = [];
  for(var playerId in playerIds) {
    var player = await getPlayer(playerId);
    players.add(player);
  }

  return players;
}


Future<List<Topic>> getGameTopics(String gameId) async {
  final gameTopicsSnapshot = await FirebaseFirestore.instance
      .collection('game-topics')
      .where('gameId', isEqualTo: gameId)
      .get();

  final topicIds = gameTopicsSnapshot.docs
      .map((doc) => doc['topicId'] as String)
      .toList();

  List<Topic> topics = [];

  for(var topicId in topicIds) {
    var topic = await getTopic(topicId);
    topics.add(topic);
  }

  return topics;
}

