part of "player_bloc.dart";

abstract class PlayerState {
  const PlayerState();
}

class PlayerStateInitial extends PlayerState {}

class PlayerSubscribed extends PlayerState {
  String playerId;
  PlayerSubscribed(this.playerId);
}

class PlayerLoadSuccess extends PlayerState{
  Player player;
  ImageProvider profileImage;

  PlayerLoadSuccess(this.player, this.profileImage);
}

class PlayerLoadFail extends PlayerState{
  String errorMessage;

  PlayerLoadFail(this.errorMessage);
}