import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:fluter_prjcts/Models/answer.dart";
part "answer_event.dart";
part 'answer_state.dart';

class AnswersBloc extends Bloc<AnswerEvent, AnswerState> {
  final FirebaseFirestore firestore;
  StreamSubscription? _subscription;

  AnswersBloc({required this.firestore}) : super(AnswerInitial()) {
    on<SubscribeAnswers>(_subscribeAnswersHandler);
    on<AnswersUpdated>(_updatedAnswersHandler);
  }

  void _subscribeAnswersHandler(SubscribeAnswers e, Emitter emit) {
    _subscription?.cancel();
    _subscription = firestore
        .collection("answers")
        .where("questionId", isEqualTo: e.questionId)
        .snapshots()
        .listen((querySnap) async {
      final answers = querySnap.docs
          .map((doc) => Answer.fromFirestore(doc))
          .toList();

      add(AnswersUpdated(answers));
    },
        onError: (error) {
          throw Exception(error);
        }
    );
  }

  void _updatedAnswersHandler(AnswersUpdated e, Emitter emit) {
    emit(AnswerLoadSuccess(e.answers));
  }
}
