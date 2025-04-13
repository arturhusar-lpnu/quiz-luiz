import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Firestore/Game/DeathRun/death_run.firestore.dart';
import 'package:fluter_prjcts/Models/Enums/game_mode.enum.dart';
import 'package:fluter_prjcts/Models/Enums/game_type.enum.dart';
import 'package:fluter_prjcts/Models/game.dart';
import 'package:fluter_prjcts/Models/topic.dart';
import 'package:fluter_prjcts/Firestore/Topic/topic.firestore.dart';

class GameController {
  late Game gameSetup;
  late String gameCollection;
  late Set<String> topicIds;
  final String hostId;
  final String opponentId;

  GameController({
    required this.gameSetup,
    required this.topicIds,
    required this.hostId,
    required this.opponentId,
  }) {
    _getCollection(gameSetup.mode);
  }

  void setTopicIds(Set<String> topics) {
    topicIds = topics;
  }

  Future<void> _checkId() async{
    if(gameSetup.id.isEmpty) {
      gameSetup.id = await addGame(gameSetup.type, gameSetup.mode);
    }
  }

  Game game(){
    return gameSetup;
  }

  Future<String> getGameId() async{
    await _checkId();
    return gameSetup.id;
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
    await _checkId();

    await addTopicsToGame(gameSetup.id, topicIds);
  }

  Future<void> newGame() async {
    try {
      await _checkId();

      await FirebaseFirestore.instance.collection(gameCollection).doc(gameSetup.id).set({
        "players" : {
          "host" : {
            "id" : hostId,
            "fails": 0,
            "score": 0,
          },
          "opponent" : {
            "id": opponentId,
            "fails": 0,
            "score": 0,
          }
        },
        "status" : "inProgress",
        "currentQuestion" : "",
        "winner" : "",
      });
    } catch (e) {
      throw Exception("API Error: could not add $gameCollection game");
    }
  }

  Future<String> getCurrentQuestion() async{
    final doc = await getGameDoc();

    final String questionId = doc["currentQuestion"];

    return questionId;
  }

  Future getGameDoc() async {
    final doc = await FirebaseFirestore.instance
        .collection(gameCollection)
        .doc(gameSetup.id)
        .get();

    if(!doc.exists) throw Exception("No game found");

    return doc;
  }


  Future<DocumentReference<Map<String, dynamic>>>
    getGameDocRef() async {
    final gameDocRef = FirebaseFirestore.instance
        .collection(gameCollection)
        .doc(gameSetup.id);
    return gameDocRef;
  }



  Future addPointToHost() async {
    final gameDocRef = await getGameDocRef();

    await gameDocRef.update({
      'players.host.score': FieldValue.increment(1),
    });
  }

  Future addPointToOpponent() async {
    final gameDocRef = await getGameDocRef();

    await gameDocRef.update({
      'players.opponent.score': FieldValue.increment(1),
    });
  }

  Future addFailToHost() async {
    final gameDocRef = await getGameDocRef();

    await gameDocRef.update({
      'players.host.fails': FieldValue.increment(1),
    });
  }

  Future addFailToOpponent() async {
    final gameDocRef = await getGameDocRef();

    await gameDocRef.update({
      'players.opponent.fails': FieldValue.increment(1),
    });
  }

  Future<String> getWinner() async {
    final doc = await getGameDoc();

    final String winner = doc["winner"];

    return winner;
  }

  Future<Map<String, dynamic>> getHostInfo() async {
    final doc = await getGameDoc();

    final host = doc["players"]["host"];

    return host;
  }


  Future<Map<String, dynamic>> getOpponentInfo() async {
    final doc = await getGameDoc();

    final opponent = doc["players"]["opponent"];

    return opponent;
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

