import 'dart:math';

import 'package:fluter_prjcts/Firestore/Game/solo-game.dart';
import 'package:fluter_prjcts/Models/question.dart';
import 'package:fluter_prjcts/Models/topic.dart';

class DeathRunSoloPlayerController extends SoloGameController {
  DeathRunSoloPlayerController({
    required super.gameSetup,
    required super.topicIds,
    required super.hostId,
    required super.movesRepository,
    required super.topicRepository, required super.firestore, required super.leaderBoardRepository,
  });

  Map<String, List<Question>> gameQuestions = {};

  Map<String, dynamic> host = {};

  late String result;
  late String currentTopicId;

  Future<void> _setupQuestions() async{
    for(final topicId in topicIds) {
      final questions = await topicRepository.getTopicQuestions(topicId);
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
    final topicQuestions = await topicRepository.getTopicQuestions(topicId);

    for (final q in topicQuestions) {
      final moves = await movesRepository.getQuestionMoves(gameSetup.id, hostId, q.id);
      final correct = moves.where((m) => m.isCorrect).length;
      final wrong = moves.where((m) => !m.isCorrect).length;
      if (correct <= wrong) {
        return false;
      }
    }

    await topicRepository.addSolvedTopics(hostId, [topicId]);

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

    } catch (e) {
      endGame("Win");
    }
  }

  @override
  Future<String> checkAnswers() async {
    final currQuestionId = await getCurrentQuestionId();
    final host = await _getHost();
    final hostMoves = await movesRepository.getQuestionMoves(gameSetup.id, host["id"], currQuestionId);
    int correctAnswers = 0;
    int wrongAnswers = 0;

    String result = "No result";

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
      topics.add(await topicRepository.getTopic(soledTopicId));
    }
    return topics;
  }


  Future endGame(String result) async{
    gameOver();
    gameResult = result;
  }
}