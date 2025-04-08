import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Firestore/Game/DeathRun/death_run.firestore.dart';
import 'package:fluter_prjcts/Firestore/Player/player.firestore.dart';
import 'package:fluter_prjcts/Models/Enums/game_mode.enum.dart';
import 'package:fluter_prjcts/Models/Enums/game_type.enum.dart';
import 'package:fluter_prjcts/Models/game.dart';
import 'package:fluter_prjcts/Models/player.dart';
import 'package:fluter_prjcts/Models/topic.dart';
import 'package:fluter_prjcts/Firestore/Topic/topic.firestore.dart';

class GameController {
  late Game gameSetup;
  late String gameCollection;
  late Set<String> topicIds;
  late List<String> playerIds;

  GameController({
    required this.gameSetup,
  }) {
    _getCollection(gameSetup.mode);
  }


  void setTopicIds(Set<String> topics) {
    topicIds = topics;
  }

  void setPlayers(String player1Id, String player2Id) {
    playerIds = [player1Id, player2Id];
  }

  Game game(){
    return gameSetup;
  }

  void _getCollection(GameMode mode) {
    switch(mode) {
      case GameMode.death_run:
        gameCollection = "death-runs";
        break;
      case GameMode.first_to_15:
        gameCollection = "first-to";
        break;
      case GameMode.in_a_row:
        gameCollection = "in-a-row";
        break;
    }
  }

  Future<void> addTopics() async{
    if(gameSetup.id.isEmpty) {
      await addGame(gameSetup.type, gameSetup.mode);
    }

    await addTopicsToGame(gameSetup.id, topicIds);
  }

  Future<void> addPlayers() async {
    try {
      if(gameSetup.id.isEmpty) {
        gameSetup.id = await addGame(gameSetup.type, gameSetup.mode);
      }

      if(playerIds.isEmpty) {
        throw Exception("Add players");
      }

      await FirebaseFirestore.instance.collection(gameCollection).doc(gameSetup.id).set({
        "players" : {
          playerIds.first: {
            "fails": 0,
            "score": 0,
          },
          playerIds.last: {
            "fails": 0,
            "score": 0,
          }
        },
        "status" : "inProgress",
        "currentQuestion" : "",
        "winner" : null,
      });
    } catch (e) {
      throw Exception("API Error: could not add $gameCollection game");
    }
  }

  Future<List<Player>> getGamePlayers() async {
    List<String> playerIds =  await getPlayerIds(gameSetup.id, gameCollection);
    List<Player> players = [];
    for(var playerId in playerIds) {
      var player = await getPlayer(playerId);
      players.add(player);
    }

    return players;
  }

  Future<List<Topic>> getTopics() async {
    return await getGameTopics(gameSetup.id);
  }

  Future<void> setWinner(String playerId) async {
    try {
      await FirebaseFirestore.instance.collection(gameCollection).doc(gameSetup.id).update({
        "winner": playerId,
      });
    } catch (e) {
      throw Exception("API error setting the winner");
    }
  }

  Future<void> updateStatus(GameStatus status) async {
    try{
      await FirebaseFirestore.instance.collection(gameCollection).doc(gameSetup.id).update({
        "status" : status.name,
      });
    } catch (e) {
      throw Exception("Error updating status");
    }
  }

  Future<void> updateCurrentQuestion(String questionId) async {
    try{
      await FirebaseFirestore.instance.collection(gameCollection).doc(gameSetup.id).update({
        "currentQuestion" : questionId,
      });
    } catch (e) {
      throw Exception("API Error updating current question");
    }
  }
}

Future<String> addGame(GameType type, GameMode mode) async{
  try {
    var game = await FirebaseFirestore.instance.collection("games").add({
      'type' : type.name.toLowerCase(),
      'mode': mode.name.toLowerCase(),
    });
    return game.id;
  } catch(e) {
    throw(Exception("API error: could not add a game"));
  }
}

Future<List<Player>> getGamePlayers(gameId, GameMode mode) async {
  String gameCollection = "";
  switch(mode) {
    case GameMode.death_run:
      gameCollection = "death-runs";
      break;
    case GameMode.first_to_15:
      gameCollection = "first-to";
      break;
    case GameMode.in_a_row:
      gameCollection = "in-a-row";
      break;
  }

  List<String> playerIds =  await getPlayerIds(gameId, gameCollection);
  List<Player> players = [];
  for(var playerId in playerIds) {
    var player = await getPlayer(playerId);
    players.add(player);
  }

  return players;
}

Future<List<String>> getPlayerIds(String gameId, String collection) async {
  try {
    final docSnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .doc(gameId)
        .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      final playersMap = data?['players'] as Map<String, dynamic>;
      return playersMap.keys.toList();
    } else {
      throw Exception("Game not found");
    }
  } catch (e) {
    throw Exception("API Error fetching players");
  }
}

Future<void> addTopicsToGame(String gameId, Set<String> topicsIds) async{
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

  } catch(e) {
    throw(Exception("API error: could not add topics to a game"));
  }
}

Future<Game> getGame(String gameId) async{
  final gameSnapshot = await FirebaseFirestore.instance.collection("games").doc(gameId).get();

  return Game.fromFirestore(gameSnapshot);
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

