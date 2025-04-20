import "package:fluter_prjcts/Actions/Buttons/action_button.dart";
import "package:fluter_prjcts/Blocs/QuizBloc/quiz.bloc.dart";
import "package:fluter_prjcts/Firestore/Game/DeathRun/death_run.solo.controller.dart";
import "package:fluter_prjcts/Firestore/Game/FirstTo15/first_to.solo.controller.dart";
import "package:fluter_prjcts/Firestore/Game/In_a_row/in_arow.solo.controller.dart";
import "package:fluter_prjcts/Firestore/Game/solo-game.dart";
import "package:fluter_prjcts/Models/Enums/game_mode.enum.dart";
import "package:fluter_prjcts/Models/answer.dart";
import "package:fluter_prjcts/Models/question.dart";
import "package:fluter_prjcts/Pages/QuizPage/quiz_answers_list.dart";
import "package:fluter_prjcts/Router/router.dart";
import "package:fluter_prjcts/Widgets/Other/screen_title.dart";
import "package:fluter_prjcts/Widgets/PopUp/answer_result.popup.dart";
import "package:flutter/material.dart";
import "package:fluter_prjcts/Models/game.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class QuizScreen extends StatefulWidget {
  final Game configGame;
  final String hostId;
  final Set<String> gameTopicIds;
  const QuizScreen({ super.key,
    required this.configGame,
    required this.gameTopicIds,
    required this.hostId
  });

  @override
  State<QuizScreen> createState() => _QuizState();
}

class _QuizState extends State<QuizScreen> {
  late SoloGameController gameController;
  late QuizBloc quizBloc;
  List<Answer> selectedAnswers = [];
  bool _isInitialized = false;

  Future<void> _initGame() async {
    final game = widget.configGame;
    final topicIds = widget.gameTopicIds;
    final hostId = widget.hostId;

    switch (game.mode) {
      case GameMode.death_run:
        gameController = DeathRunSoloPlayerController(
          gameSetup: game,
          topicIds: topicIds,
          hostId: hostId,
        );
        break;
      case GameMode.first_to_15:
        gameController = FirstToSoloController(
          gameSetup: game,
          topicIds: topicIds,
          hostId: hostId,
          pointsToWin: 15,
        );
        break;
      case GameMode.in_a_row:
        gameController = InArowToSoloController(
          gameSetup: game,
          topicIds: topicIds,
          hostId: hostId,
          pointsToWin: 5,
        );
        break;
    }

    await gameController.init();

    setState(() {
      quizBloc = QuizBloc(controller: gameController);
      quizBloc.add(LoadNextQuestion());
      _isInitialized = true;
    });
  }

  @override
  void initState() {
    super.initState();

    _initGame();
  }

  @override
  void dispose() {
    quizBloc.close();
    super.dispose();
  }

  void handleAnswerSelected(Answer selected) {
    setState(() {
      if (selectedAnswers.contains(selected)) {
        selectedAnswers.remove(selected);
      } else {
        selectedAnswers.add(selected);
      }
    });
  }

  Future<void> _handleQuizResult({
    required bool isCorrect,
    required String message,
  }) async {
    await showResultDialog(
      context,
      isCorrect: isCorrect,
      pointsGainMessage: message,
    );
    quizBloc.add(LoadNextQuestion());
  }

  Widget buildBlocContent(BuildContext context) {
    return BlocProvider.value(
        value: quizBloc,
      child: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if(state is QuizQuestionLoaded) {
            return _buildQuestion(context, state.currentQuestion, state.answers, state.score);
          } else if(state is QuizAnsweredCorrect) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _handleQuizResult(isCorrect: true, message: "+ 1 point");
            });
          } else if (state is QuizAnsweredInCorrect) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _handleQuizResult(isCorrect: false, message: "+ 0 point");
            });
          } else if (state is QuizAnswered) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _handleQuizResult(isCorrect: true, message: "+ 0 point. Too many options");
            });
          } else if(state is QuizCompleted) {
            router.go("/game-result", extra: {
              "result" : state.result,
              "score" : state.score,
              "solvedTopics" : state.solvedTopics,
            });
          }
          return Column(
            children: [
              const Center(
                  child: Text(
                      "Loading...")
              ),
              CircularProgressIndicator()
            ],
          );
        }
      )
    );
  }

  Widget _buildQuestion(BuildContext ctx, Question q, List<Answer> answers, String score) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Center(
            child: Text(
              score,
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 20
              ),
              textAlign: TextAlign.center,
            )
          ),


          Container( //Question Box
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
              color: const Color(0xFF4d5061),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                q.content,
                style: TextStyle(fontSize: 24, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          QuizAnswerList(
            answers: answers,
            selectedAnswers: selectedAnswers,
            onAnswerSelected: handleAnswerSelected,
          ),

          ActionButton(
            text: "Answer",
            color: Color(0xFF6E3DDA),
            width: double.infinity,
            height: 90,
            onPressed: () async {
              quizBloc.add(AnswerSubmitted(selectedAnswers, q.id ));
              selectedAnswers = [];
            },
          ),
        ],
      )
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child:
      Column(
        children: [
          const SizedBox(height: 60,),
          const ScreenTitle(title: "Solo Game"),
          Center(
            child: Text(
              _getTitle(widget.configGame.mode),
              style: TextStyle(
                color: Colors.amber,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(child: Align(
            child: buildBlocContent(context),
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isInitialized ? _buildMainContent(context) : const Center(child: CircularProgressIndicator()),
    );
  }

  String _getTitle(GameMode mode) {
    switch (mode) {
      case GameMode.death_run:
        return 'Death Run';
      case GameMode.first_to_15:
        return 'First to 15';
      case GameMode.in_a_row:
        return '5 In A Row';
    }
  }
}