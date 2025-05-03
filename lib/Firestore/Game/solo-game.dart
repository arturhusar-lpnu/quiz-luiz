import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Firestore/Game/Moves/move.repository.dart';
import 'package:fluter_prjcts/Firestore/Game/game.firestore.dart';
import 'package:fluter_prjcts/Firestore/LeaderBoard/leaderboard.firestore.dart';
import 'package:fluter_prjcts/Firestore/Topic/topic.repository.dart';

import '../../Models/topic.dart';

abstract class SoloGameController extends GameController {
  final TopicRepository topicRepository;
  final MoveRepository movesRepository;
  final LeaderBoardRepository leaderBoardRepository;
  final String hostId;
  late String gameResult;
  List<String> solvedTopicIds = [];
  SoloGameController({
    required super.gameSetup,
    required super.topicIds,
    required this.hostId,
    required this.topicRepository,
    required this.movesRepository,
    required this.leaderBoardRepository,
    required super.firestore
  });

  String getGameResult() => gameResult;

  Future<String> checkAnswers();

  Future roundSetup();

  int getQuestionsCount();

  Future<String> getScore();

  Future<List<Topic>> getSolvedTopics();

  @override
  Future<void> newGame() async {
    try {
      final gameId = await super.getGameId();

      await firestore.collection(gameCollection).doc(gameId).set({
        "host" : {
          "id" : hostId,
          "fails": 0,
          "score": 0,
        },
        "status" : "inProgress",
        "currentQuestion" : "",
      });
    } catch (e) {
      throw Exception("API Error: could not add $gameCollection game");
    }
  }

  Future<Map<String, dynamic>> getHostInfo() async {
    final doc = await getGameDoc();

    final host = doc["host"];

    return host;
  }

  Future addPointToHost() async {
    final gameDocRef = await getGameDocRef();

    await gameDocRef.update({
      'host.score': FieldValue.increment(1),
    });
  }

  Future addPointsToRanked () async {
    final host = await getHostInfo();
    final points = host["score"] as int;
    await leaderBoardRepository.addPoints(hostId, points);
  }

  Future addFailToHost() async {
    final gameDocRef = await getGameDocRef();

    await gameDocRef.update({
      'host.fails': FieldValue.increment(1),
    });
  }
}