import "package:fluter_prjcts/Firestore/Game/Moves/move.repository.dart";
import "package:fluter_prjcts/Firestore/Game/solo-game.dart";
import "package:fluter_prjcts/Firestore/Question/question.repository.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:fluter_prjcts/Models/question.dart";
import "package:fluter_prjcts/Models/answer.dart";
import "package:fluter_prjcts/Models/topic.dart";
part "quiz.state.dart";
part "quiz.event.dart";


class QuizBloc extends Bloc<QuizEvent, QuizState> {
  late SoloGameController controller;
  final QuestionRepository questionRepo;
  final MoveRepository moveRepo;

  QuizBloc({required this.controller, required this.questionRepo, required this.moveRepo}): super(QuizInitState()) {
    on<LoadNextQuestion>(_loadQuestionHandler);
    on<AnswerSubmitted>(_submittedAnswerHandler);
    on<EndQuiz>(_endQuizHandler);
  }

  Future<void> _loadQuestionHandler(LoadNextQuestion e, Emitter emit) async{
    try {
      await controller.roundSetup();

      if(controller.isGameOver()) {
        final gameResult = controller.getGameResult();
        if(gameResult == "Win") {
          await controller.addPointsToRanked();
        }

        //await addSolvedTopics(controller.hostId, controller.solvedTopicIds);
        add(EndQuiz(gameResult));
        return;
      }

      String id = await controller.getCurrentQuestionId();

      Question question = await questionRepo.getQuestion(id);

      List<Answer> questionAnswers = await questionRepo.getAnswers(id);

      String score = await controller.getScore();

      emit(QuizQuestionLoaded(question, questionAnswers, score));
    } catch(e) {
      add(EndQuiz(e.toString()));
    }
  }

  Future<void> _submittedAnswerHandler(AnswerSubmitted e, Emitter emit) async {
    try {
      final answers = e.answers;
      final questionId = e.questionId;

      for(final answer in answers) {
        await moveRepo.makeMove(controller.gameSetup.id, controller.hostId, questionId, answer.id);
      }

      String result = await controller.checkAnswers();

      if(result == "Correct") {
        emit(QuizAnsweredCorrect());
      } else if(result == "False") {
        emit(QuizAnsweredInCorrect());
      } else {
        emit(QuizAnswered());
      }
    } catch(e) { print(e); }
  }

  Future<void> _endQuizHandler(EndQuiz e, Emitter emit) async{
    final solvedTopics = await controller.getSolvedTopics();
    final score = await controller.getScore();
    emit(QuizCompleted(e.result, score, solvedTopics));
  }
}