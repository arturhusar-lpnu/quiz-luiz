part of 'topic_bloc.dart';

abstract class TopicEvent {
  const TopicEvent();
}

class TopicCardTapped extends TopicEvent {}

class SubscribeTopics extends TopicEvent {}

class TopicsUpdated extends TopicEvent {
  List<Topic> topics;
  TopicsUpdated(this.topics);
}

class TopicSelected extends TopicEvent {}