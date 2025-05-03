import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Models/topic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part "recent_topics_event.dart";
part "recent_topics_state.dart";

class RecentTopicsBloc extends Bloc<RecentTopicsEvent, RecentTopicsState> {
  final FirebaseFirestore firestore;
  StreamSubscription? _subscription;

  RecentTopicsBloc({required this.firestore}) : super(RecentTopicsInitial()) {
    on<SubscribeRecentTopics>(_subscribeHandler);
    on<RecentTopicsUpdated>(_updateHandler);
  }

  void _subscribeHandler(SubscribeRecentTopics e, Emitter emit) {
    _subscription?.cancel();
    emit(RecentTopicLoading());
    _subscription = firestore
        .collection("recent-topics")
        .where("playerId", isEqualTo: e.playerId)
        .snapshots()
        .listen((querySnap) async {
      final topicIds = querySnap.docs
          .map((doc) => doc.data()['topicId'] as String)
          .toList();

      final topicFutures = topicIds.map(
            (id) => firestore.collection("topics").doc(id).get(),
      );

      final snapshots = await Future.wait(topicFutures);

      final topics = snapshots.map((doc) => Topic.fromFirestore(doc)).toList();

      add(RecentTopicsUpdated(topics));
    });
  }

  void _updateHandler(RecentTopicsUpdated e, Emitter emit) {
    emit(RecentTopicLoadSuccess(e.topics));
  }
}
