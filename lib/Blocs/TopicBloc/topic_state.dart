part of "topic_bloc.dart";

abstract class TopicState {
  const TopicState();
}

class TopicInitial extends TopicState {}

class TopicLoadSuccess extends TopicState {
  List<Topic> topics;
  TopicLoadSuccess(this.topics);
}

class TopicTappedState extends TopicState {}

class SelectedTopicState extends TopicState {}