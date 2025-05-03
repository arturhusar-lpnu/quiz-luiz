import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:fluter_prjcts/Firestore/Game/DeathRun/death_run.solo.controller.dart';
import 'package:fluter_prjcts/Firestore/Game/Moves/move.repository.dart';
import 'package:fluter_prjcts/Firestore/LeaderBoard/leaderboard.firestore.dart';
import 'package:fluter_prjcts/Firestore/Question/question.repository.dart';
import 'package:fluter_prjcts/Firestore/Topic/topic.repository.dart';
import 'package:fluter_prjcts/Models/Enums/game_mode.enum.dart';
import 'package:fluter_prjcts/Models/Enums/game_type.enum.dart';
import 'package:fluter_prjcts/Models/game.dart';
import 'package:fluter_prjcts/Models/move.dart';
import 'package:fluter_prjcts/Models/question.dart';
import 'package:fluter_prjcts/Models/answer.dart' as model;
import 'package:fluter_prjcts/Models/topic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:fluter_prjcts/Blocs/QuizBloc/quiz.bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockQuestionRepository extends Mock implements QuestionRepository {}
class MockMovesRepository extends Mock implements MoveRepository {}
class MockSoloGameController extends Mock implements DeathRunSoloPlayerController {}

Future setUpData(FakeFirebaseFirestore firestorm) async {
  final List<Topic> topics = [
    Topic(id: "id 1", title: "Topic 1", description: "description"),
    Topic(id: "id 2", title: "Topic 2", description: "description"),
    Topic(id: "id 3", title: "Topic 3", description: "description"),
  ];

  final List<Question> questions = [
    Question(content: "What is Flutter", id: "id 1", topicId: "id 1"),
    Question(content: "Who is Flutter", id: "id 2", topicId: "id 1"),
    Question(content: "Why is Flutter", id: "id 2", topicId: "id 1"),
  ];

  final List<model.Answer> answers = [
    model.Answer(id: "1", content: "Framework", questionId: "id 1", isCorrect: true),
    model.Answer(id: "2", content: "Language", questionId: "id 1", isCorrect: false),
    model.Answer(id: "3", content: "React", questionId: "id 1", isCorrect: false),
  ];

  final Set<String> topicIds = Set.from(topics.map((t) => t.id));
  final gameSetup = Game(id: 'gameId', type: GameType.ranked, mode: GameMode.death_run);

  await firestorm.collection("games").doc(gameSetup.id).set({
    'type': gameSetup.type.name.toLowerCase(),
    'mode': gameSetup.mode.name.toLowerCase(),
  });

  final hostId = "host";

  final List<Move> moves = [
    Move(id: "id-1", gameId: gameSetup.id, playerId: hostId, questionId: "id 1", answerId: "1", isCorrect: true),
    Move(id: "id-2", gameId: gameSetup.id, playerId: hostId, questionId: "id 1", answerId: "2", isCorrect: false),
  ];


  // Perform async setup
  for (final topic in topics) {
    await firestorm.collection("topics").doc(topic.id).set({
      'title': topic.title,
      'description': topic.description,
    });
  }

  for (final question in questions) {
    await firestorm.collection("questions").doc(question.id).set({
      'topicId': question.topicId,
      'content': question.content,
    });
  }

  for (final answer in answers) {
    await firestorm.collection("answers").doc(answer.id).set({
      'questionId': answer.questionId,
      'content': answer.content,
      'isCorrect': answer.isCorrect,
    });
  }
  final topicRepo = TopicRepository(firestore: firestorm);
  final movesRepo = MoveRepository(firestore: firestorm);

  for (final move in moves) {
    await movesRepo.makeMove(move.gameId, move.playerId, move.questionId, move.answerId);
  }

  return DeathRunSoloPlayerController(
    firestore: firestorm,
    gameSetup: gameSetup,
    topicIds: topicIds,
    hostId: hostId,
    movesRepository: movesRepo,
    topicRepository: topicRepo,
    leaderBoardRepository: LeaderBoardRepository(firestore: firestorm),
  );
}


void main() {
  late MockSoloGameController mockController;
  late MockMovesRepository mockMoveRepo;
  late MockQuestionRepository mockQuestionRepo;
  late FakeFirebaseFirestore firestorm;
  late DeathRunSoloPlayerController controller;

  setUpAll(() async {
    firestorm = FakeFirebaseFirestore();
    controller = await setUpData(firestorm);
    await controller.init();
  });


  setUp(() async {
    mockController = MockSoloGameController();
    mockQuestionRepo = MockQuestionRepository();
    mockMoveRepo = MockMovesRepository();

    when(() => mockController.gameSetup).thenReturn(Game(id: 'gameId', type: GameType.ranked, mode: GameMode.death_run));
    when(() => mockController.hostId).thenReturn("Id");
    when(() => mockController.topicIds).thenReturn({"Id"});
  });

  void mockCommonControllerBehaviors() {
    when(() => mockController.roundSetup()).thenAnswer((_) async {});
    when(() => mockController.isGameOver()).thenReturn(false);
    when(() => mockController.getCurrentQuestionId()).thenAnswer((_) async => 'questionId');
    when(() => mockController.getScore()).thenAnswer((_) async => '100');
    when(() => mockController.getSolvedTopics()).thenAnswer(
          (_) async => [Topic(id: "1", title: "title-1", description: "desc")],
    );
  }

  void mockCommonQuestionRepoBehaviors() {
    when(() => mockQuestionRepo.getQuestion('questionId')).thenAnswer((_) async => Question(
      topicId: "topicId", id: 'questionId', content: 'What is Flutter?',
    ));

    when(() => mockQuestionRepo.getAnswers('questionId')).thenAnswer((_) async => [
      model.Answer(id: '1', content: 'Framework', isCorrect: false, questionId: 'questionId'),
      model.Answer(id: '2', content: 'Language', isCorrect: true, questionId: 'questionId'),
    ]);
  }

  group('QuizBloc Tests', () {
    blocTest<QuizBloc, QuizState>(
      'emits [QuizQuestionLoaded] when LoadNextQuestion is added',
      build: () {
        mockCommonControllerBehaviors();
        mockCommonQuestionRepoBehaviors();
        return QuizBloc(controller: mockController, questionRepo: mockQuestionRepo, moveRepo: mockMoveRepo);
      },
      act: (bloc) => bloc.add(LoadNextQuestion()),
      expect: () => [
        isA<QuizQuestionLoaded>()
            .having((state) => state.currentQuestion.content, 'question content', 'What is Flutter?')
            .having((state) => state.score, 'score', '100'),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'emits mock [QuizAnsweredCorrect] when correct answer is submitted',
      build: () {
        when(() => mockMoveRepo.makeMove(any(), any(), any(), any()))
            .thenAnswer((_) async {});

        when(() => mockMoveRepo.getQuestionMoves(any(), any(), any()))
            .thenAnswer((_) async => [
          Move(gameId: "gameId", playerId: "playerId", questionId: "questionId", answerId: "answerId", isCorrect: true, id: '')
        ]);

        when(() => mockController.checkAnswers()).thenAnswer((_) async => 'Correct');

        mockCommonControllerBehaviors();
        mockCommonQuestionRepoBehaviors();
        return QuizBloc(controller: mockController, questionRepo: mockQuestionRepo, moveRepo: mockMoveRepo);
      },
      act: (bloc) async {
        final answers = [
          model.Answer(id: '2', content: 'Language', isCorrect: true, questionId: 'questionId')
        ];
        bloc.add(AnswerSubmitted(answers, 'questionId'));
      },
      expect: () => [
        isA<QuizAnsweredCorrect>(),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'emits mock [QuizAnsweredInCorrect] when wrong answer is submitted',
      build: () {
        when(() => mockMoveRepo.makeMove(any(), any(), any(), any()))
            .thenAnswer((_) async {});

        when(() => mockMoveRepo.getQuestionMoves(any(), any(), any()))
            .thenAnswer((_) async => [
          Move(gameId: "gameId", playerId: "playerId", questionId: "questionId", answerId: "answerId", isCorrect: true, id: '')
        ]);

        when(() => mockController.checkAnswers()).thenAnswer((_) async => 'False');

        mockCommonControllerBehaviors();
        mockCommonQuestionRepoBehaviors();
        return QuizBloc(controller: mockController, questionRepo: mockQuestionRepo, moveRepo: mockMoveRepo);
      },
      act: (bloc) async {
        final answers = [
          model.Answer(id: '2', content: 'Language', isCorrect: false, questionId: 'questionId')
        ];
        bloc.add(AnswerSubmitted(answers, 'questionId'));
      },
      expect: () => [
        isA<QuizAnsweredInCorrect>(),
      ],
    );


    blocTest<QuizBloc, QuizState>(
      'emits proper [QuizAnsweredCorrect] when correct answer is submitted',
      build: () {
        final qBloc = QuizBloc(
          controller: controller,
          questionRepo: QuestionRepository(firestore: firestorm),
          moveRepo: MoveRepository(firestore: firestorm),
        )..add(LoadNextQuestion());
        return qBloc;
      },
      act: (bloc) async {
        final answers = [
          model.Answer(id: "1", content: "Framework", questionId: "id 1", isCorrect: true),
        ];
        bloc.add(AnswerSubmitted(answers, 'id 1'));
      },
      wait: const Duration(seconds: 1),
      expect: () => [
        isA<QuizQuestionLoaded>(),
        isA<QuizAnsweredCorrect>(),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'emits [QuizCompleted] when EndQuiz is added',
      build: () {
        when(() => mockController.getSolvedTopics()).thenAnswer((_) async => [
          Topic(id: "1", title: "title-1", description: "description"),
          Topic(id: "2", title: "title-2", description: "description")
        ]);
        when(() => mockController.getScore()).thenAnswer((_) async => '200');
        return QuizBloc(controller: mockController, questionRepo: mockQuestionRepo, moveRepo: mockMoveRepo);
      },
      act: (bloc) => bloc.add(EndQuiz('Win')),
      expect: () => [
        isA<QuizCompleted>()
            .having((state) => state.result, 'result', 'Win')
            .having((state) => state.score, 'score', '200')
      ],
    );
  });
}