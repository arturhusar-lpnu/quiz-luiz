import 'package:fluter_prjcts/Models/question.dart';
import 'package:fluter_prjcts/Screens/game_setup_screen.dart';
import 'package:fluter_prjcts/Screens/join_game_screen.dart';
import 'package:go_router/go_router.dart';
import '../Pages/TopicSetup/question_list.page.dart';
import '../Screens/main_screen.dart';


final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => MainScreen(index: 0)),
    GoRoute(path: '/games', builder: (context, state) => MainScreen(index: 1)),
    GoRoute(path: '/stats', builder: (context, state) => MainScreen(index: 2)),
    GoRoute(path: '/profile', builder: (context, state) => MainScreen(index: 3)),
    GoRoute(path: '/create-game', builder: (context, state) => GameSetupScreen()),
    GoRoute(path: '/join-game', builder: (context, state) => JoinGameScreen()),
    GoRoute(
      name: "/question-list",
      path: "/question-list",
      builder: (context, state) {
        final questions = state.extra as List<Question>?; // Retrieve data
        return QuestionListPage(questions: questions ?? []);
      },
    ),
  ],
);