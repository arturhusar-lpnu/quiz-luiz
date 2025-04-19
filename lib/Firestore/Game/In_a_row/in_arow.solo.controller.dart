import 'package:fluter_prjcts/Firestore/Game/solo-game.dart';
import 'package:fluter_prjcts/Firestore/Topic/topic.firestore.dart';
import 'package:fluter_prjcts/Models/question.dart';
import 'package:fluter_prjcts/Router/router.dart';
import '../Moves/move.firestore.dart';
import "dart:math";

class InArowToSoloController extends SoloGameController {
  final int pointsToWin;
  InArowToSoloController({
    required super.gameSetup,
    required super.topicIds,
    required super.hostId,
    required this.pointsToWin
  });
  int consCorrect = 0;
  Map<String, List<Question>> gameQuestions = {};

  List<String> solvedTopics = [];

  Map<String, dynamic> host = {};

  late String result;

  Future<void> _setupQuestions() async{
    int questionsCount = 0;

    for(final topicId in topicIds) {
      final questions = await getTopicQuestions(topicId);
      gameQuestions[topicId] = questions;
      questionsCount += questions.length;
    }

    if(questionsCount < pointsToWin) {
      throw Exception("Not Enough Questions");
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
        solvedTopics.add(topicId);
      } else {
        final randomIndex = random.nextInt(questions.length);
        return questions.removeAt(randomIndex);
      }
    }

    throw Exception('No questions available in any topic.');
  }

  Future _getHost() async {
    if(host.isEmpty) await getHostInfo();

    return host;
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
    //final host = await _getHost();

    if(consCorrect == pointsToWin) {
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
      consCorrect++;
      result = "Correct";
    }

    if(correctAnswers < wrongAnswers) {
      await addFailToHost();
      consCorrect = 0;
      result = "False";
    }

    return result;
  }

  Future endGame(String result) async{

    gameOver();
    gameResult = result;

    if(result == "Loss") {
      router.push("/loss", extra: { gameSetup, hostId });
      return;
    }

    if(result == "Win") {
      router.push("/win", extra: { gameSetup, hostId, solvedTopics });
      return;
    }
  }
}