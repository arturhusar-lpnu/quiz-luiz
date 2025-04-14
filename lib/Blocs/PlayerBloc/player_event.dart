part of 'player_bloc.dart';

abstract class PlayerEvent {
  const PlayerEvent();
}

class SubscribedPlayerEvent extends PlayerEvent{
  String playerId;
  SubscribedPlayerEvent(this.playerId);
}

class UpdatedPlayerEvent extends PlayerEvent {
  Player player;
  ImageProvider profileImage;
  UpdatedPlayerEvent(this.player, this.profileImage);
}