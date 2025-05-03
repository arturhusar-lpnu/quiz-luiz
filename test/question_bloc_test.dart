import 'package:bloc_test/bloc_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:fluter_prjcts/Firestore/Question/question.repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluter_prjcts/Blocs/QuestionBloc/question_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockQuestionRepository extends Mock implements QuestionRepository {}
class QuestionEventFake extends Fake implements QuestionEvent {}
class QuestionStateFake extends Fake implements QuestionState {}
void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late QuestionRepository repository;
  const testTopicId = 'test_topic';

  setUp(() async {
    registerFallbackValue(QuestionEventFake());
    registerFallbackValue(QuestionStateFake());

    fakeFirestore = FakeFirebaseFirestore();
    await fakeFirestore.collection('questions').add({'topicId': testTopicId, 'content': 'What is Flutter?'});
    await fakeFirestore.collection('questions').add({'topicId': testTopicId, 'content': 'What is Dart?'});

    repository = QuestionRepository(firestore: fakeFirestore);
  });

  blocTest<QuestionBloc, QuestionState>(
    'emits [QuestionsLoadSuccess] with loaded questions for topic',
    build: () => QuestionBloc(repository: repository),
    act: (bloc) => bloc.add(SubscribeQuestions(testTopicId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      isA<QuestionsLoadSuccess>().having(
            (state) => state.questions.length,
        'number of questions',
        2,
      ),
    ],
  );

  blocTest<QuestionBloc, QuestionState>(
    'emits [QuestionsLoadSuccess] with empty list when no questions exist',
    build: () => QuestionBloc(repository: repository),
    act: (bloc) => bloc.add(SubscribeQuestions('')),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      isA<QuestionsLoadSuccess>().having(
            (state) => state.questions,
        'empty question list',
        isEmpty,
      ),
    ],
  );

  blocTest<QuestionBloc, QuestionState>(
    'emits [QuestionAddedSuccess] and refreshes questions on AddNewQuestion',
    build: () => QuestionBloc(repository: repository),
    act: (bloc) => bloc.add(AddNewQuestion(topicId: testTopicId, content: 'New question')),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      isA<QuestionAddedSuccess>(),
      isA<QuestionsLoadSuccess>().having(
            (state) => state.questions.map((q) => q.content),
        'question contents',
        contains('New question'),
      ),
    ],
  );

  blocTest<QuestionBloc, QuestionState>(
    'emits [QuestionAddFailure] when adding fails',
    build: () {
      final repository = MockQuestionRepository();
      when(() => repository.addQuestion(any(), any()))
          .thenThrow(Exception('DB error'));
      return QuestionBloc(repository: repository);
    },
    act: (bloc) => bloc.add(AddNewQuestion(topicId: testTopicId, content: 'Fails')),
    expect: () => [
      isA<QuestionAddFailure>().having((state) => state.message, "error message", contains("Failed to add the question"))
    ],
  );
}