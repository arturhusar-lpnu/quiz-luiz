import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Firestore/Game/game.firestore.dart';

class MultiPlayerController extends GameController {
  final String hostId;
  final String opponentId;

  MultiPlayerController({
    required super.gameSetup,
    required super.topicIds,
    required this.hostId,
    required this.opponentId,
    required super.firestore
  });

  @override
  Future<void> init() async {

  }

  @override
  Future<void> newGame() async {
    try {
      final gameId = await super.getGameId();

      await FirebaseFirestore.instance.collection(gameCollection).doc(gameId).set({
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

  Future<void> setWinner(String playerId) async {
    try {
      await FirebaseFirestore.instance.collection(gameCollection).doc(gameSetup.id).update({
        "winner": playerId,
      });
    } catch (e) {
      throw Exception("API error setting the winner");
    }
  }
}