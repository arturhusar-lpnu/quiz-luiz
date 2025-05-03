import 'package:bloc_test/bloc_test.dart';
import 'package:fluter_prjcts/Firestore/Question/question.repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Blocs/QuestionBloc/question_bloc.dart';
import 'package:fluter_prjcts/Models/question.dart';
import 'package:fluter_prjcts/Pages/TopicSetup/question_list.page.dart';

class MockQuestionRepository extends Mock implements QuestionRepository {}

class MockQuestionBloc extends MockBloc<QuestionEvent, QuestionState> implements QuestionBloc {}

void main() {
  late MockQuestionBloc mockQuestionBloc;

  setUp(() {
    mockQuestionBloc = MockQuestionBloc();
  });

  group('QuestionListPage Widget Tests', () {
    testWidgets('displays loading indicator when loading questions', (tester) async {
      when(() => mockQuestionBloc.state).thenReturn(QuestionsLoading());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<QuestionBloc>.value(
            value: mockQuestionBloc,
            child: const QuestionListPage(topicId: 'test_topic_id'),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays questions when QuestionsLoadSuccess is emitted', (tester) async {
      final mockQuestions = [
        Question(id: '1', content: 'What is Flutter?', topicId: ''),
        Question(id: '2', content: 'What is Dart?', topicId: ''),
      ];
      when(() => mockQuestionBloc.state).thenReturn(QuestionsLoadSuccess(mockQuestions));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<QuestionBloc>.value(
            value: mockQuestionBloc,
            child: const QuestionListPage(topicId: 'test_topic_id'),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('What is Flutter?'), findsOneWidget);
      expect(find.text('What is Dart?'), findsOneWidget);
    });

    testWidgets('displays message when no questions are available', (tester) async {
      when(() => mockQuestionBloc.state).thenReturn(QuestionsLoadSuccess([]));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<QuestionBloc>.value(
            value: mockQuestionBloc,
            child: const QuestionListPage(topicId: 'test_topic_id'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No questions'), findsOneWidget);
    });
  });
}
