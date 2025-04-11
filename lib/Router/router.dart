import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Screens/waiting_room.screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluter_prjcts/Models/game_data.dart';
import "package:fluter_prjcts/Screens/main_screen.dart";
import 'package:fluter_prjcts/Pages/TopicSetup/add_question.page.dart';
import 'package:fluter_prjcts/Screens/create_topic.screen.dart';
import 'package:fluter_prjcts/Screens/game_setup_screen.dart';
import 'package:fluter_prjcts/Screens/join_game_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:fluter_prjcts/Pages/TopicSetup/question_list.page.dart';
import 'package:fluter_prjcts/Screens/sign_in.screen.dart';
import 'package:fluter_prjcts/Screens/sign_up.screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/sign-in',
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isLoggingIn = state.matchedLocation == '/sign-in' || state.matchedLocation == '/sign-up';

    if (!isLoggedIn && !isLoggingIn) {
      return '/sign-in';
    }

    if (isLoggedIn && isLoggingIn) {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/sign-in', builder: (context, state) => const SignInScreen()),
    GoRoute(path: '/sign-up', builder: (context, state) => const SignUpScreen()),
    GoRoute(path: '/', builder: (context, state) => MainScreen(index: ScreensEnum.homeScreen.index)),
    GoRoute(path: '/games', builder: (context, state) => MainScreen(index: ScreensEnum.gamesScreen.index)),
    GoRoute(path: '/topics', builder: (context, state) => MainScreen(index: ScreensEnum.topicScreen.index)),
    GoRoute(path: '/stats', builder: (context, state) => MainScreen(index: ScreensEnum.statsScreen.index)),
    GoRoute(path: '/profile', builder: (context, state) => MainScreen(index: ScreensEnum.profileScreen.index)),
    GoRoute(path: '/create-game', builder: (context, state) => GameSetupScreen()),
    GoRoute(
      name: "/join-game",
      path: "/join-game",
      builder: (context, state) {
        final gameData = state.extra as GameData;
        return JoinGameScreen(gameData: gameData);
      },
    ),
    GoRoute(path: '/create-topic', builder: (context, state) => CreateTopicScreen()),
    GoRoute(
      name: "/question-list",
      path: "/question-list",
      builder: (context, state) {
        final topicId = state.extra as String;
        return QuestionListPage(topicId: topicId);
      },
    ),
    GoRoute(
      name: "/new-question",
      path: "/new-question",
      builder: (context, state) {
        final topicId = state.extra as String;
        return AddQuestionPage(topicId: topicId);
      },
    ),
    GoRoute(
      path: "/waiting-room",
      builder: (context, state) {
        final gameData = state.extra as GameData;
        return WaitingRoomScreen(gameData : gameData);
      }
    ),
  ],
);