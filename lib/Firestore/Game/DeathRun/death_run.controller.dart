import 'package:fluter_prjcts/Firestore/Game/game.firestore.dart';
import 'package:fluter_prjcts/Firestore/Player/player.firestore.dart';
import 'package:fluter_prjcts/Firestore/Topic/topic.firestore.dart';
import 'package:fluter_prjcts/Models/question.dart';
import 'package:fluter_prjcts/Router/router.dart';

import '../Moves/move.firestore.dart';

class DeathRunController extends GameController {
  DeathRunController({
    required super.gameSetup,
    required super.topicIds,
    required super.hostId,
    required super.opponentId
  });
  late List<Question> gameQuestions;
  Map<String, dynamic> host = {};
  Map<String, dynamic> opponent = {};

  Future<void> _getQuestions() async{
    for(final topicId in topicIds) {
      final questions = await getTopicQuestions(topicId);
      for (var q in questions) {
        gameQuestions.add(q);
      }
    }
  }

  Future init() async{
    await _getQuestions();
    await _getHost();
    await _getOpponent();
  }


  Future _getHost() async {
    if(host.isEmpty) await getHostInfo();

    return host;
  }

  Future _getOpponent() async {
    if(opponent.isEmpty) await getOpponentInfo();

    return opponent;
  }

  Future<void> chooseAWinner() async {
    final host = await _getHost();
    final opponent = await _getOpponent();

    int hostPoints = host["points"];
    int oppPoints = opponent["points"];

    String winnerId =  hostPoints > oppPoints ?
    host["id"] : opponent["id"];

    if(oppPoints == hostPoints) {
      winnerId = "";
    }
    setWinner(winnerId);
    await _endGame();
  }

  /// TODO Before calling start a 30 seconds timer on the ui and then call checkAnswers;
  Future<void> onNewRound() async{
    if(gameQuestions.isEmpty) {
      await chooseAWinner();
      return;
    }

    final host = await _getHost();
    final opponent = await _getOpponent();

    if(host["fails"] == 3 && opponent["fails"] == 3) {
      await chooseAWinner();
    }

    if(host["fails"] == 3) {
      setWinner(opponent["id"]);
      await _endGame();
      return;
    }

    if(opponent["fails"] == 3) {
      setWinner(host["id"]);
      await _endGame();
      return;
    }

    final currentPlayer = await getCurrentPlayer();
    if( currentPlayer?.id != host["id"] ) {
      return;
    }

    final currentQuestion = gameQuestions.removeLast();

    await super.updateCurrentQuestion(currentQuestion.id);
  }



  Future checkAnswers() async {
    final currQuestionId = await getCurrentQuestion();
    final host = await _getHost();
    final opponent = await _getOpponent();
    final hostMove = await getMove(gameSetup.id, host["id"], currQuestionId);
    final oppMove = await getMove(gameSetup.id, opponent["id"], currQuestionId);

    if(hostMove.isCorrect) {
      await addPointToHost();
    } else {
      await addFailToHost();
    }

    if(oppMove.isCorrect) {
      await addPointToOpponent();
    } else {
      await addFailToOpponent();
    }
  }

  Future _endGame() async{
    final winner = await getWinner();

    if(winner.isEmpty) {
      router.push("/draw", extra: gameSetup);
      return;
    }

    router.push(
        "/game/win",
        extra: {
          "game": gameSetup,
          "winner": winner
        }
    );
  }
}