import 'package:fluter_prjcts/Actions/Buttons/StartSoloGame/start-death-run.button.dart';
import 'package:fluter_prjcts/Actions/Buttons/StartSoloGame/start-first-to.button.dart';
import 'package:fluter_prjcts/Actions/Buttons/StartSoloGame/start-in-arow.button.dart';
import 'package:fluter_prjcts/Actions/Buttons/new_game_mode_buttons.dart';
import 'package:fluter_prjcts/Screens/games_screen.dart';
import 'package:fluter_prjcts/Widgets/Cards/match_card.dart';
import 'package:fluter_prjcts/Widgets/Other/practice_mode.dart';
import 'package:fluter_prjcts/Widgets/Other/new_game_modes.dart';
import 'package:fluter_prjcts/Widgets/Other/screen_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('GamesScreen renders and switches tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: GamesScreen(),
      ),
    );
    expect(find.byType(ScreenTitle), findsOneWidget);
    expect(find.text('QuizLuiz'), findsOneWidget);

    expect(find.text('Solo Mode'), findsOneWidget);
    expect(find.text('Multiplayer'), findsOneWidget);

    expect(find.byType(SoloMode), findsOneWidget);
    expect(find.byType(NewGameModes), findsNothing);

    await tester.tap(find.text('Multiplayer'));
    await tester.pumpAndSettle(); // wait for animation to complete

    expect(find.byType(NewGameModes), findsOneWidget);
    expect(find.byType(SoloMode), findsNothing);
  });

  testWidgets("New Game Modes test", (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: NewGameModes(),
      ),
    );
    expect(find.text('Online modes'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
    expect(find.text('Spectate'), findsOneWidget);
    expect(find.byType(MatchCard), findsWidgets);
    expect(find.byType(SpectateGameButton), findsOneWidget);
    expect(find.byType(CreateGameButton), findsOneWidget);
  });

  testWidgets("New Game Modes test", (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: NewGameModes(),
      ),
    );
    expect(find.text('Online modes'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
    expect(find.text('Spectate'), findsOneWidget);
    expect(find.byType(MatchCard), findsWidgets);
    expect(find.byType(SpectateGameButton), findsOneWidget);
    expect(find.byType(CreateGameButton), findsOneWidget);
  });

  testWidgets("Solo Modes test", (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SoloMode(),
      ),
    );
    expect(find.text('Start'), findsWidgets);
    expect(find.text('Death Run'), findsWidgets);
    expect(find.text('First To 15'), findsWidgets);
    expect(find.text('5 in a Row'), findsWidgets);

    expect(find.byType(MatchCard), findsWidgets);

    expect(find.byType(StartDeathRunSoloButton), findsOneWidget);
    expect(find.byType(StartFirstToSoloButton), findsOneWidget);
    expect(find.byType(StartInArowSoloButton), findsOneWidget);
  });
}
