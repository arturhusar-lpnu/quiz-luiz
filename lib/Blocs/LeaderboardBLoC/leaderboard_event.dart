part of "leaderboard_bloc.dart";

abstract class LeaderBoardEvent {
  const LeaderBoardEvent();
}

class SubscribeLeaderBoardEvent extends LeaderBoardEvent {
  SubscribeLeaderBoardEvent();
}

class UpdatedLeaderBoardEvent extends LeaderBoardEvent {
  List<RankedPlayer> players;
  UpdatedLeaderBoardEvent(this.players);
}

