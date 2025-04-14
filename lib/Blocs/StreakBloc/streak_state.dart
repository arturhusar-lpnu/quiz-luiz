part of "streak_bloc.dart";

abstract class StreakState {
  const StreakState();
}

class StreakStateInitial extends StreakState{}

class SubscribedStreak extends StreakState {
  String playerId;
  SubscribedStreak(this.playerId);
}

class StreakLoadSuccess extends StreakState {
  int streak;
  StreakLoadSuccess(this.streak);
}

class StreakLoadFail extends StreakState {
  String errorMessage;
  StreakLoadFail(this.errorMessage);
}
