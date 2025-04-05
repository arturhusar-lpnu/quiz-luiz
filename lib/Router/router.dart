import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluter_prjcts/Pages/TopicSetup/add_answers.page.dart';
import 'package:fluter_prjcts/Pages/TopicSetup/add_question.page.dart';
import 'package:fluter_prjcts/Screens/create_topic.screen.dart';
import 'package:fluter_prjcts/Screens/game_setup_screen.dart';
import 'package:fluter_prjcts/Screens/join_game_screen.dart';
import 'package:go_router/go_router.dart';
import '../Pages/TopicSetup/question_list.page.dart';
import '../Screens/main_screen.dart';
import '../Screens/sign_in.screen.dart';


final GoRouter router = GoRouter(
  initialLocation: '/sign-in',
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isLoggingIn = state.matchedLocation == '/sign-in';

    if (!isLoggedIn && !isLoggingIn) {
      print(1);
      print(!isLoggedIn && !isLoggingIn);
      return '/sign-in';
    }

    if (isLoggedIn && isLoggingIn) {
      print(2);
      print(isLoggedIn && isLoggingIn);
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/sign-in', builder: (context, state) => const SignInScreen()),
    GoRoute(path: '/', builder: (context, state) => MainScreen(index: 0)),
    GoRoute(path: '/games', builder: (context, state) => MainScreen(index: 1)),
    GoRoute(path: '/stats', builder: (context, state) => MainScreen(index: 2)),
    GoRoute(path: '/profile', builder: (context, state) => MainScreen(index: 3)),
    GoRoute(path: '/create-game', builder: (context, state) => GameSetupScreen()),
    GoRoute(
      name: "/join-game",
      path: "/join-game",
      builder: (context, state) {
        final gameId = state.extra as String;
        return JoinGameScreen(gameId: gameId);
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
      name: "/add-answers",
      path: "/add-answers",
      builder: (context, state) {
        final questionId = state.extra as String;
        return AddAnswersPage(questionId: questionId);
      }
    )
  ],
);