import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Models/topic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'topic_event.dart';
part 'topic_state.dart';

class TopicBloc extends Bloc<TopicEvent, TopicState> {
  final FirebaseFirestore firestore;
  StreamSubscription? _subscription;

  TopicBloc({required this.firestore}) : super(TopicInitial()) {
    on<TopicEvent>(_topicEventHandler);
    on<TopicCardTapped>(_topicCardTapped);
    on<TopicSelected>(_topicSelected);
    on<SubscribeTopics>(_subscribeHandler);
    on<TopicsUpdated>(_topicsUpdatedHandler);
  }

  void _subscribeHandler(SubscribeTopics e, Emitter emit) {
    _subscription?.cancel();
    _subscription = firestore.collection("topics").snapshots().listen((snap) {
      final topics = snap.docs.map((doc) => Topic.fromFirestore(doc)).toList();
      add(TopicsUpdated(topics));
    });
  }

  void _topicsUpdatedHandler(TopicsUpdated e, Emitter emit) {
    emit(TopicLoadSuccess(e.topics));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> _topicEventHandler(TopicEvent e, Emitter emit) async {
    emit(TopicInitial());
  }

  Future<void> _topicCardTapped(TopicCardTapped e, Emitter emit) async {
    emit(TopicTappedState());
  }

  Future<void> _topicSelected(TopicSelected e, Emitter emit) async {
    emit(SelectedTopicState());
  }
}