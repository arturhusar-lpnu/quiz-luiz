import 'package:fluter_prjcts/Firestore/Game/multi-player.firestore.dart';
import 'package:fluter_prjcts/Firestore/Player/player.firestore.dart';
import 'package:fluter_prjcts/Firestore/Topic/topic.firestore.dart';
import 'package:fluter_prjcts/Models/question.dart';
import 'package:fluter_prjcts/Router/router.dart';

import '../Moves/move.firestore.dart';

class DeathRunMultiPlayerController extends MultiPlayerController {
  DeathRunMultiPlayerController({
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
    final currQuestionId = await getCurrentQuestionId();
    final host = await _getHost();
    final opponent = await _getOpponent();
    final hostMoves = await getQuestionMoves(gameSetup.id, host["id"], currQuestionId);
    final oppMoves = await getQuestionMoves(gameSetup.id, opponent["id"], currQuestionId);

    int correctHostAnswers = 0;
    int wrongHostAnswers = 0;

    int correctOppAnswers = 0;
    int wrongOppAnswers = 0;

    for(final move in hostMoves) {
      if(move.isCorrect) {
        correctHostAnswers++;
      } else {
        wrongHostAnswers++;
      }
    }

    for(final move in oppMoves) {
      if(move.isCorrect) {
        correctOppAnswers++;
      } else {
        wrongOppAnswers++;
      }
    }

    if(correctHostAnswers > wrongHostAnswers) {
      await addPointToHost();
    }

    if(correctHostAnswers < wrongHostAnswers) {
      await addFailToHost();
    }

    if(correctOppAnswers > wrongOppAnswers) {
      await addPointToOpponent();
    }

    if(correctOppAnswers < wrongOppAnswers) {
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