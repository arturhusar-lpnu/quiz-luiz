import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:fluter_prjcts/Firestore/LeaderBoard/leaderboard.firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Blocs/LeaderboardBLoC/leaderboard_bloc.dart';
import 'package:fluter_prjcts/Screens/stats_screen.dart';


class MockLeaderBoardBloc extends MockBloc<LeaderBoardEvent, LeaderBoardState> implements LeaderBoardBloc {}

void main() {
  group("LeaderBoard Screen", () {
    testWidgets('displays leaderboard from state', (tester) async {
      final firestorm = FakeFirebaseFirestore();
      await firestorm.collection('players').doc('1').set({'username': 'Alice'});
      await firestorm.collection('leaderboard').add({'playerId': '1', 'points': 100});
      final repo = LeaderBoardRepository(firestore: firestorm);

      await tester.pumpWidget(
        MaterialApp(
          home:  Material(child: StatsScreen(injectRepo: repo,)),
        ),
      );

      await tester.pumpAndSettle();

      // Ensure that the widget is found and that the text "Alice" appears
      expect(find.text('Alice'), findsOneWidget);
    });
  });
}