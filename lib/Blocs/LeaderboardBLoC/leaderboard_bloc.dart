import 'dart:async';
import 'package:fluter_prjcts/Firestore/LeaderBoard/leaderboard.firestore.dart';
import 'package:fluter_prjcts/Models/ranked_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'leaderboard_state.dart';
part 'leaderboard_event.dart';

class LeaderBoardBloc extends Bloc<LeaderBoardEvent, LeaderBoardState> {
  StreamSubscription? _subscription;
  LeaderBoardBloc() : super(LeaderBoardInitial()) {
    on<SubscribeLeaderBoardEvent>(_boardSubscribeHandler);
    on<UpdatedLeaderBoardEvent>(_boardUpdatedHandler);
  }

  Future<void> _boardSubscribeHandler(
      SubscribeLeaderBoardEvent e, Emitter emit) async{
    _subscription?.cancel();
    _subscription = listenToRankedPlayers().listen(
          (players) => add(UpdatedLeaderBoardEvent(players)),
      onError: (error) => emit(LeaderBoardLoadFailure(error.toString())),
    );
  }

  void _boardUpdatedHandler(UpdatedLeaderBoardEvent e, Emitter emit) {
    emit(LeaderBoardLoadSuccess(e.players));
  }

  Stream<List<RankedPlayer>> listenToRankedPlayers() {
    return Stream.fromFuture(fetchRankedPlayers());
  }
}