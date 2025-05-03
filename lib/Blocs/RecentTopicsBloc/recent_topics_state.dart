part of "recent_topics_bloc.dart";

abstract class RecentTopicsState {}

class RecentTopicsInitial extends RecentTopicsState {}

class RecentTopicLoadSuccess extends RecentTopicsState {
  List<Topic> topics;
  RecentTopicLoadSuccess(this.topics);
}

class RecentTopicLoading extends RecentTopicsState {}