import 'dart:async';
import 'package:fluter_prjcts/Firestore/Player/current_player.dart';
import 'package:fluter_prjcts/Firestore/Streak/streak.firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "streak_state.dart";
part "streak_event.dart";

class StreakBloc extends Bloc<StreakEvent, StreakState> {

  StreamSubscription? subscription;

  StreakBloc() : super(StreakStateInitial()) {
    on<SubscribeStreakEvent>(_streakSubscribeHandler);
    on<UpdatedStreakEvent>(_streakUpdatedHandler);
  }

  void _streakSubscribeHandler(SubscribeStreakEvent e, Emitter emit) {
    subscription?.cancel();
    subscription = listenForStreak().listen(
          (streak) => add(UpdatedStreakEvent(streak)),
      onError: (error) => emit(StreakLoadFail(error.toString())),
    );
  }

  void _streakUpdatedHandler(UpdatedStreakEvent e, Emitter emit) {
    emit(StreakLoadSuccess(e.streak));
  }

  Stream<int> listenForStreak() {
    final currentPlayer = CurrentPlayer.player;

    return Stream.fromFuture(getStreak(currentPlayer!.id));
  }
}