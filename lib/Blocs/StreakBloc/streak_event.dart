
part of "streak_bloc.dart";

abstract class StreakEvent {
  const StreakEvent();
}

class SubscribeStreakEvent extends StreakEvent {
  String playerId;
  SubscribeStreakEvent(this.playerId);
}

class UpdatedStreakEvent extends StreakEvent {
  int streak;
  UpdatedStreakEvent(this.streak);
}