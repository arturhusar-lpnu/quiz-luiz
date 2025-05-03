import 'package:fluter_prjcts/Blocs/QuestionBloc/question_bloc.dart';
import 'package:fluter_prjcts/Models/question.dart';
import 'package:fluter_prjcts/Pages/TopicSetup/Cards/simple_topic.card.dart';
import 'package:fluter_prjcts/Pages/TopicSetup/List/simple_topic.list.dart';
import 'package:fluter_prjcts/Screens/topics.screen.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Actions/Buttons/help_button.dart';
import 'package:fluter_prjcts/Blocs/TopicBloc/topic_bloc.dart';
import 'package:fluter_prjcts/Models/topic.dart';
import 'package:fluter_prjcts/Widgets/Other/screen_title.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTopicBloc extends Mock implements TopicBloc {}
class TopicEventDummy extends Fake implements TopicEvent {}
class MockQuestionBloc extends Mock implements QuestionBloc {}
void main() {
  late MockTopicBloc topicMock;
  late MockQuestionBloc questionMock;
  late List<Topic> topics;
  late List<Question> questions;
  setUpAll((){
    topicMock = MockTopicBloc();
    registerFallbackValue(TopicEventDummy());
    questionMock = MockQuestionBloc();

    topics = [
      Topic(id: "id-1", title: "Math", description: "description"),
      Topic(id: "id-2", title: "History", description: "description"),
      Topic(id: "id-3", title: "Flutter", description: "description"),
      Topic(id: "id-4", title: "Objects", description: "description"),
    ];
    questions = [
      Question(content: "content-1", id: "id-1", topicId: "id-1"),
      Question(content: "content-2", id: "id-2", topicId: "id-1"),
    ];


    when(() => topicMock.state).thenAnswer((_) => TopicLoadSuccess(topics));
    when(() => topicMock.stream).thenAnswer((_) => Stream.value(TopicLoadSuccess(topics)));

    when(() => questionMock.state).thenAnswer((_) => QuestionsLoadSuccess(questions));
    when(() => questionMock.stream).thenAnswer((_) => Stream.value(QuestionsLoadSuccess(questions)));

  });

  testWidgets("Test Screen Load", (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<TopicBloc>.value(value: topicMock),
          BlocProvider<QuestionBloc>.value(value: questionMock),
        ],
        child: MaterialApp(
          home:  TopicsScreen(),
        ),
      ),
    );
    expect(find.byType(ScreenTitle), findsOneWidget);
    expect(find.text('Topics'), findsOneWidget);
    expect(find.byType(HelpButton), findsOneWidget);

  });


  testWidgets("Test Screen Load", (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<TopicBloc>.value(value: topicMock),
          BlocProvider<QuestionBloc>.value(value: questionMock),
        ],
        child: MaterialApp(
          home:  TopicsScreen(),
        ),
      ),
    );

    expect(find.byType(SearchBar), findsOneWidget);
    expect(find.text('Search topics...'), findsOneWidget);
    expect(find.byType(SimpleTopicsList), findsOneWidget);
  });


  testWidgets("Test Screen Load", (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<TopicBloc>.value(value: topicMock),
          BlocProvider<QuestionBloc>.value(value: questionMock),
        ],
        child: MaterialApp(
          home:  TopicsScreen(),
        ),
      ),
    );
    expect(find.byType(SimpleTopicCard), findsNWidgets(topics.length));

    expect(find.text('Math'), findsOneWidget);
    expect(find.text("${questions.length} questions"), findsWidgets);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}