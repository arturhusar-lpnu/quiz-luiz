part of 'leaderboard_bloc.dart';

abstract class LeaderBoardState {
  const LeaderBoardState();
}

class LeaderBoardInitial extends LeaderBoardState {}


class LeaderBoardLoadSuccess extends LeaderBoardState{
  List<RankedPlayer> rankedPlayers;
  LeaderBoardLoadSuccess(this.rankedPlayers);
}

class LeaderBoardLoadFailure extends LeaderBoardState {
  String errorMessage;
  LeaderBoardLoadFailure(this.errorMessage);
}