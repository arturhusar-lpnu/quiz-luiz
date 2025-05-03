import "dart:async";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:fluter_prjcts/Models/question.dart";
import "package:fluter_prjcts/Firestore/Question/question.repository.dart";
part "question_event.dart";
part "question_state.dart";


class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final QuestionRepository repository;
  StreamSubscription? _subscription;

  QuestionBloc({required this.repository}) : super(QuestionsInitial()) {
    on<SubscribeQuestions>(_subscribeQuestionsHandler);
    on<QuestionsUpdated>(_updatedQuestionsHandler);
    on<AddNewQuestion>(_addNewQuestionHandler);
  }
  
  void _subscribeQuestionsHandler(SubscribeQuestions e, Emitter emit) {
    _subscription?.cancel();
    //emit(QuestionsLoading());
    _subscription = repository.firestore
        .collection("questions")
        .where("topicId", isEqualTo: e.topicId)
        .snapshots()
        .listen((querySnap) async {
          final questions = querySnap.docs
            .map((doc) => Question.fromFirestore(doc))
            .toList();

          add(QuestionsUpdated(questions));
        },
        onError: (error) {
          emit(QuestionsLoadFailed(error.toString()));
          //throw Exception(error);
        }
    );
  }
  
  void _updatedQuestionsHandler(QuestionsUpdated e, Emitter emit) {
    emit(QuestionsLoadSuccess(e.questions));
  }

  Future<void> _addNewQuestionHandler(AddNewQuestion e, Emitter emit) async {
    try {
      await repository.addQuestion(e.topicId, e.content);

      emit(QuestionAddedSuccess());

      add(SubscribeQuestions(e.topicId));
    } catch (e) {
      emit(QuestionAddFailure("Failed to add the question"));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}