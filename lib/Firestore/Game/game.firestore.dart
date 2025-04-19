import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Firestore/Game/DeathRun/death_run.firestore.dart';
import 'package:fluter_prjcts/Models/Enums/game_mode.enum.dart';
import 'package:fluter_prjcts/Models/Enums/game_type.enum.dart';
import 'package:fluter_prjcts/Models/game.dart';
import 'package:fluter_prjcts/Models/topic.dart';
import 'package:fluter_prjcts/Firestore/Topic/topic.firestore.dart';


abstract class GameController {
  late Game gameSetup;
  late String gameCollection;
  late Set<String> topicIds;

  GameController({
    required this.gameSetup,
    required this.topicIds,
  }) {
    _getCollection(gameSetup.mode);
  }
  Future<void> init();
  void setTopicIds(Set<String> topics) {
    topicIds = topics;
  }

  Future<void> _checkId() async{
    if(gameSetup.id.isEmpty) {
      await addGame(gameSetup.type, gameSetup.mode);
    }
  }

  Future<void> addGame(GameType type, GameMode mode) async{
    try {
      var game = await FirebaseFirestore.instance.collection("games").add({
        'type' : type.name.toLowerCase(),
        'mode': mode.name.toLowerCase(),
      });
      gameSetup.id = game.id;
    } catch(e) {
      throw(Exception("API error: could not add a game"));
    }
  }

  bool _gameOver = false;

  bool isGameOver() {
    return _gameOver;
  }

  void gameOver() {
    _gameOver = true;
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
    final gameId = await getGameId();

    try {
      var db = FirebaseFirestore.instance;

      final gameRef = db.collection("games").doc(gameId);

      var gameSnapshot = await gameRef.get();

      if(!gameSnapshot.exists) {
        throw Exception("Error: Topic with ID $gameId does not exist.");
      }

      for(var topicId in topicIds) {
        await db.collection("game-topics").add({
          'gameId' : gameId,
          'topicId' : topicId,
        });
      }

    } catch(e) {
      throw(Exception("API error: could not add topics to a game"));
    }
  }

  Future<void> newGame() async {
  }

  Future<String> getCurrentQuestionId() async{
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

  Future<List<Topic>> getTopics() async {
    final gameId = await getGameId();
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

  Future<void> updateStatus(GameStatus status) async {
    try{
      final gameId = await getGameId();
      await FirebaseFirestore.instance.collection(gameCollection).doc(gameId).update({
        "status" : status.name,
      });
    } catch (e) {
      throw Exception("Error updating status");
    }
  }

  Future<void> updateCurrentQuestion(String questionId) async {
    try{
      final gameId = await getGameId();
      await FirebaseFirestore.instance.collection(gameCollection).doc(gameId).update({
        "currentQuestion" : questionId,
      });
    } catch (e) {
      throw Exception("API Error updating current question");
    }
  }
}
