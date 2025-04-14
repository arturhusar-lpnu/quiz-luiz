import 'dart:async';
import 'package:fluter_prjcts/Firestore/Player/player.firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluter_prjcts/Models/player.dart';
import "package:fluter_prjcts/Widgets/user_image.helper.dart";

part "player_event.dart";
part 'player_state.dart';

class ProfileBloc extends Bloc<PlayerEvent, PlayerState> {
  StreamSubscription? _playerSubscription;
  StreamSubscription? _imageSubscription;

  ProfileBloc() : super(PlayerStateInitial()) {
    on<SubscribedPlayerEvent>(_playerSubscribedHandler);
    on<UpdatedPlayerEvent>(_playerUpdatedHandler);
  }

  void _playerSubscribedHandler(SubscribedPlayerEvent e, Emitter emit) {
    _playerSubscription?.cancel();
    _imageSubscription?.cancel();

    final (playerStream, profileImageStream) = listenForPlayer(e.playerId);

    Player? currentPlayer;
    ImageProvider<Object>? currentImage;

    _playerSubscription = playerStream.listen((player) {
      currentPlayer = player;
      if (currentImage != null) {
        add(UpdatedPlayerEvent(currentPlayer!, currentImage!));
      }
    });

    // Subscribe to image stream
    _imageSubscription = profileImageStream.listen((image) {
      currentImage = image;
      // Send update event if we have both pieces of data
      if (currentPlayer != null) {
        add(UpdatedPlayerEvent(currentPlayer!, currentImage!));
      }
    });
  }


  void _playerUpdatedHandler(UpdatedPlayerEvent e, Emitter emit) {
    emit(PlayerLoadSuccess(e.player, e.profileImage));
  }

  (Stream<Player>, Stream<ImageProvider<Object>>) listenForPlayer(String playerId) {
    final playerStream = Stream.fromFuture(getPlayer(playerId));
    final profilePicture = Stream.fromFuture(fetchProfileImage(playerId));

    return (playerStream, profilePicture);
  }

  @override
  Future<void> close() {
    _playerSubscription?.cancel();
    _imageSubscription?.cancel();
    return super.close();
  }
}
