import 'dart:math';

import 'package:fluter_prjcts/Firestore/Game/solo-game.dart';
import 'package:fluter_prjcts/Firestore/Topic/topic.firestore.dart';
import 'package:fluter_prjcts/Models/question.dart';
import 'package:fluter_prjcts/Models/topic.dart';
import 'package:fluter_prjcts/Firestore/Game/Moves/move.firestore.dart';

class DeathRunSoloPlayerController extends SoloGameController {
  DeathRunSoloPlayerController({
    required super.gameSetup,
    required super.topicIds,
    required super.hostId,
  });

  Map<String, List<Question>> gameQuestions = {};

  Map<String, dynamic> host = {};

  late String result;
  late String currentTopicId;

  Future<void> _setupQuestions() async{
    for(final topicId in topicIds) {
      final questions = await getTopicQuestions(topicId);
      gameQuestions[topicId] = questions;
    }
  }

  @override
  int getQuestionsCount() {
    int count = 0;
    for(final key in gameQuestions.keys) {
      count += gameQuestions[key]!.length;
    }
    return count;
  }

  @override
  Future init() async{
    await addGame(gameSetup.type, gameSetup.mode);
    await newGame();
    await _setupQuestions();
  }

  // Question getQuestion() {
  //   final random = Random();
  //
  //   if (gameQuestions.isEmpty) {
  //     throw Exception('No questions available in any topic.');
  //   }
  //
  //   final topicIds = gameQuestions.keys.toList();
  //   final randomTopicId = topicIds[random.nextInt(topicIds.length)];
  //   final questions = gameQuestions[randomTopicId]!;
  //
  //   if (questions.isEmpty) {
  //     solvedTopicIds.add(randomTopicId);
  //     gameQuestions.remove(randomTopicId);
  //     return getQuestion();
  //   }
  //
  //   final question = questions.removeAt(random.nextInt(questions.length));
  //   if (questions.isEmpty) {
  //     solvedTopicIds.add(randomTopicId);
  //     gameQuestions.remove(randomTopicId);
  //   }
  //
  //   return question;
  // }
  Question getQuestion() {
    final random = Random();

    if (gameQuestions.isEmpty) {
      throw Exception('No questions available in any topic.');
    }

    final topicIds = gameQuestions.keys.toList();
    final randomTopicId = topicIds[random.nextInt(topicIds.length)];
    final questions = gameQuestions[randomTopicId]!;

    if (questions.isEmpty) {
      gameQuestions.remove(randomTopicId);
      return getQuestion(); // retry with another topic
    }

    currentTopicId = randomTopicId; // Track current topic

    final question = questions.removeAt(random.nextInt(questions.length));
    return question;
  }

  Future _getHost() async {
    host = await getHostInfo();

    return host;
  }

  @override
  Future<String> getScore() async{
    final hostInfo = await _getHost();

    final score = StringBuffer("");
    score.write("Score: ${hostInfo["score"]}");
    score.write(" Fails: ${hostInfo["fails"]}");

    return score.toString();
  }

  Future<bool> _isTopicSolved(String topicId, String hostId) async {
    final topicQuestions = await getTopicQuestions(topicId);

    for (final q in topicQuestions) {
      final moves = await getQuestionMoves(gameSetup.id, hostId, q.id);
      final correct = moves.where((m) => m.isCorrect).length;
      final wrong = moves.where((m) => !m.isCorrect).length;
      if (correct <= wrong) {
        return false;
      }
    }

    await addSolvedTopics(hostId, [topicId]);

    return true;
  }

  @override
  Future roundSetup() async {
    final host = await _getHost();

    if(host["fails"] == 3) {
      endGame("Loss");
    }

    try {
      final question = getQuestion();
      await updateCurrentQuestion(question.id);

      // Check if current topic is depleted
      // if (gameQuestions[currentTopicId]!.isEmpty) {
      //   final isSolved = await _isTopicSolved(currentTopicId, host["id"]);
      //   if (isSolved) {
      //     solvedTopicIds.add(currentTopicId);
      //   }
      //   gameQuestions.remove(currentTopicId);
      // }

    } catch (e) {
      endGame("Win");
    }


    // try {
    //   Question currentQuestion = getQuestion();
    //   await updateCurrentQuestion(currentQuestion.id);
    // } catch (exception) {
    //   endGame("Win");
    // }
  }

  @override
  Future<String> checkAnswers() async {
    final currQuestionId = await getCurrentQuestionId();
    final host = await _getHost();
    final hostMoves = await getQuestionMoves(gameSetup.id, host["id"], currQuestionId);
    int correctAnswers = 0;
    int wrongAnswers = 0;

    String result = "You lox";

    for(final move in hostMoves) {
      if(move.isCorrect) {
        correctAnswers++;
      } else {
        wrongAnswers++;
      }
    }

    if(correctAnswers > wrongAnswers) {
      await addPointToHost();
      result = "Correct";
    }

    if(correctAnswers < wrongAnswers) {
      await addFailToHost();
      result = "False";
    }

    if (gameQuestions.containsKey(currentTopicId) &&
        gameQuestions[currentTopicId]!.isEmpty) {
      final isSolved = await _isTopicSolved(currentTopicId, host["id"]);
      if (isSolved) {
        solvedTopicIds.add(currentTopicId);
      }
      gameQuestions.remove(currentTopicId);
    }

    return result;
  }

  @override
  Future<List<Topic>> getSolvedTopics() async {
    List<Topic> topics = [];
    for(final soledTopicId in solvedTopicIds) {
      topics.add(await getTopic(soledTopicId));
    }
    return topics;
  }


  Future endGame(String result) async{
    gameOver();
    gameResult = result;
    // if(result == "Loss") {
    //   router.push("/loss", extra: { gameSetup, hostId });
    //   return;
    // }
    //
    // if(result == "Win") {
    //   router.push("/win", extra: { gameSetup, hostId, solvedTopicIds });
    //   return;
    // }
  }
}