part of "recent_topics_bloc.dart";

abstract class RecentTopicsEvent {}

class SubscribeRecentTopics extends RecentTopicsEvent {
  final String playerId;
  SubscribeRecentTopics(this.playerId);
}

class RecentTopicsUpdated extends RecentTopicsEvent {
  final List<Topic> topics;
  RecentTopicsUpdated(this.topics);
}
