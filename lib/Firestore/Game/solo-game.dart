import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Firestore/Game/game.firestore.dart';

abstract class SoloGameController extends GameController {
  final String hostId;
  late String gameResult;
  SoloGameController({
    required super.gameSetup,
    required super.topicIds,
    required this.hostId
  });

  String getGameResult() => gameResult;

  Future<String> checkAnswers();

  Future roundSetup();

  int getQuestionsCount();

  Future<String> getScore();

  @override
  Future<void> newGame() async {
    try {
      final gameId = await super.getGameId();

      await FirebaseFirestore.instance.collection(gameCollection).doc(gameId).set({
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

  Future addFailToHost() async {
    final gameDocRef = await getGameDocRef();

    await gameDocRef.update({
      'host.fails': FieldValue.increment(1),
    });
  }
}