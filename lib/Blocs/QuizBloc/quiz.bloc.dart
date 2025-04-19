import "package:fluter_prjcts/Firestore/Game/Moves/move.firestore.dart";
import "package:fluter_prjcts/Firestore/Game/solo-game.dart";
import "package:fluter_prjcts/Firestore/Question/question.firestore.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:fluter_prjcts/Models/question.dart";
import "package:fluter_prjcts/Models/answer.dart";
part "quiz.state.dart";
part "quiz.event.dart";


class QuizBloc extends Bloc<QuizEvent, QuizState> {
  late SoloGameController controller;

  QuizBloc({required this.controller}): super(QuizInitState()) {
    on<LoadNextQuestion>(_loadQuestionHandler);
    on<AnswerSubmitted>(_submittedAnswerHandler);
    on<EndQuiz>(_endQuizHandler);
  }

  Future<void> _loadQuestionHandler(LoadNextQuestion e, Emitter emit) async{
    try {
      await controller.roundSetup();

      if(controller.isGameOver()) throw Exception("Game Over");

      String id = await controller.getCurrentQuestionId();

      Question question = await getQuestion(id);

      List<Answer> questionAnswers = await getAnswers(id);

      String score = await controller.getScore();

      emit(QuizQuestionLoaded(question, questionAnswers, score));
    } catch(e) {
      emit(QuizCompleted(e.toString()));
    }
  }

  Future<void> _submittedAnswerHandler(AnswerSubmitted e, Emitter emit) async {
    try {
      final answers = e.answers;
      final questionId = e.questionId;

      for(final answer in answers) {
        await makeMove(controller.gameSetup.id, controller.hostId, questionId, answer.id);
      }

      String result = await controller.checkAnswers();

      if(result == "Correct") {
        emit(QuizAnsweredCorrect());
      } else if(result == "False") {
        emit(QuizAnsweredInCorrect());
      } else {
        emit(QuizAnswered());
      }

      if(controller.isGameOver()) {
        add(EndQuiz(controller.getGameResult()));
      }
    } catch(_) {

    }
  }

  void _endQuizHandler(EndQuiz e, Emitter emit) {
    emit(QuizCompleted(e.result));
  }
}