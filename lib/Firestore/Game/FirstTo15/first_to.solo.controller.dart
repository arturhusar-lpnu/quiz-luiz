import 'dart:math';
import 'package:fluter_prjcts/Firestore/Game/solo-game.dart';
import 'package:fluter_prjcts/Models/question.dart';
import '../../../Models/topic.dart';

class FirstToSoloController extends SoloGameController {
  final int pointsToWin;
  FirstToSoloController({
    required super.gameSetup,
    required super.topicIds,
    required super.hostId,
    required this.pointsToWin,
    required super.movesRepository,
    required super.topicRepository, required super.firestore, required super.leaderBoardRepository,
  });

  Map<String, List<Question>> gameQuestions = {};

  Map<String, dynamic> host = {};

  late String result;

  Future<void> _setupQuestions() async{
    int questionsCount = 0;
    for(final topicId in topicIds) {
      final questions = await topicRepository.getTopicQuestions(topicId);
      gameQuestions[topicId] = questions;
      questionsCount += questions.length;
    }
    if(questionsCount < pointsToWin) {
      throw Exception("Provide more Topics");
    }
  }

  @override
  Future init() async{
    await addGame(gameSetup.type, gameSetup.mode);
    await newGame();
    await _setupQuestions();
    await _getHost();
  }

  Question getQuestion() {
    final random = Random();
    for (final topicId in topicIds) {
      final questions = gameQuestions[topicId];

      if (questions == null || questions.isEmpty) {
        solvedTopicIds.add(topicId);
        gameQuestions.remove(topicId);
      } else {
        int index = random.nextInt(questions.length);
        return questions.removeAt(index);
      }
    }

    throw Exception('No questions available in any topic.');
  }

  Future _getHost() async {
    if(host.isEmpty) await getHostInfo();

    return host;
  }

  @override
  Future<List<Topic>> getSolvedTopics() async {
    List<Topic> topics = [];
    for(final soledTopicId in solvedTopicIds) {
      topics.add(await topicRepository.getTopic(soledTopicId));
    }
    return topics;
  }
  @override
  Future<String> getScore() async{
    final hostInfo = await _getHost();

    final score = StringBuffer("");
    score.write("Score: ${hostInfo["score"]}");

    return score.toString();
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
  Future roundSetup() async {
    final host = await _getHost();

    if(host["score"] == pointsToWin) {
      endGame("Win");
    }

    try {
      Question currentQuestion = getQuestion();
      await updateCurrentQuestion(currentQuestion.id);
    } catch (exception) { //No Questions left
      endGame("Loss");
    }
  }

  @override
  Future<String> checkAnswers() async {
    final currQuestionId = await getCurrentQuestionId();
    final host = await _getHost();
    final hostMoves = await movesRepository.getQuestionMoves(gameSetup.id, host["id"], currQuestionId);
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

    return result;
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