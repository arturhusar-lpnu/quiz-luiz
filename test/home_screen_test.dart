import 'package:fluter_prjcts/Actions/Buttons/play_button.dart';
import 'package:fluter_prjcts/Blocs/LeaderboardBLoC/leaderboard_bloc.dart';
import 'package:fluter_prjcts/Blocs/RecentTopicsBloc/recent_topics_bloc.dart';
import 'package:fluter_prjcts/Blocs/StreakBloc/streak_bloc.dart';
import 'package:fluter_prjcts/Firestore/Player/current_player.dart';
import 'package:fluter_prjcts/Models/player.dart';
import 'package:fluter_prjcts/Models/ranked_player.dart';
import 'package:fluter_prjcts/Models/topic.dart';
import 'package:fluter_prjcts/Screens/home_screen.dart';
import 'package:fluter_prjcts/Widgets/Other/screen_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStreak extends Mock implements StreakBloc {}
class MockRecentTopics extends Mock implements RecentTopicsBloc {}
class MockLeaderBoard extends Mock implements LeaderBoardBloc {}
class StreakEventDummy extends Fake implements StreakEvent {}
class RecentTopicsEventDummy extends Fake implements RecentTopicsEvent {}
class LeaderBoardEventDummy extends Fake implements LeaderBoardEvent {}

void main() {
  late MockStreak streakMock;
  late MockRecentTopics recentTopicsMock;
  late MockLeaderBoard leaderBoardMock;
  late Player mockPlayer;

  setUpAll(() {
    streakMock = MockStreak();
    registerFallbackValue(StreakEventDummy());

    recentTopicsMock = MockRecentTopics();
    registerFallbackValue(RecentTopicsEventDummy());

    leaderBoardMock = MockLeaderBoard();
    registerFallbackValue(LeaderBoardEventDummy());

    mockPlayer = Player(id: "mock id", username: "Mock", email: "email");
    CurrentPlayer.setPlayer(mockPlayer);


    when(() => streakMock.add(any())).thenAnswer((_) {});
    when(() => recentTopicsMock.add(any())).thenAnswer((_) {});
    when(() => leaderBoardMock.add(any())).thenAnswer((_) {});
  });


  group("Test Home Screen Widgets", (){
    testWidgets("Test Home Screen", (tester) async {
      when(() => streakMock.state).thenAnswer((_) => StreakLoadSuccess(3));
      when(() => streakMock.stream).thenAnswer((_) => Stream.value(StreakLoadSuccess(3)));

      when(() => recentTopicsMock.state).thenAnswer((_) => RecentTopicLoadSuccess(
        [
          Topic(id: "id", title: "Math", description: "description"),
          Topic(id: "id", title: "History", description: "description"),
        ]
      ));
      when(() => recentTopicsMock.stream).thenAnswer((_) => Stream.value(
          RecentTopicLoadSuccess([
            Topic(id: "id", title: "Math", description: "description"),
            Topic(id: "id", title: "History", description: "description"),
          ])
      ));

      final players = [
        RankedPlayer(playerId: "playerId-1", username: "Monika", points: 10),
        RankedPlayer(playerId: "playerId-2", username: "Gabriel", points: 7),
        RankedPlayer(playerId: "playerId-3", username: "Newby", points: 3),
        RankedPlayer(playerId: "mock id", username: "Mock", points: 2),
      ];
      for(int i = 0; i < players.length; i++) {
        players[i].rank = i + 1;
      }

      when(() => leaderBoardMock.state).thenAnswer((_) => LeaderBoardLoadSuccess(players));
      when(() => leaderBoardMock.stream).thenAnswer((_) => Stream.value(
          LeaderBoardLoadSuccess(players)
      ));
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      await tester.pumpWidget(
        MultiBlocProvider(
            providers: [
              BlocProvider<StreakBloc>.value(value: streakMock),
              BlocProvider<RecentTopicsBloc>.value(value: recentTopicsMock),
              BlocProvider<LeaderBoardBloc>.value(value: leaderBoardMock)
            ],
            child: MaterialApp(
              home:  HomeScreen(),
            ),
        ),
      );

      expect(find.byType(ScreenTitle), findsOneWidget);
      expect(find.text('Quiz Luiz'), findsOneWidget);
      expect(find.text('3 Days Streak'), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);
      expect(find.text('Recent Topics'), findsOneWidget);
      expect(find.text('Math'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);

      expect(find.text('LeaderBoard'), findsOneWidget);
      expect(find.text('You'), findsOneWidget);
      expect(find.byType(PlayButton), findsOneWidget);
      expect(find.text('Play'), findsOneWidget);
    });
  });
}