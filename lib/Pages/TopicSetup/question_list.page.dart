import "package:cloud_firestore/cloud_firestore.dart";
import "package:fluter_prjcts/Blocs/QuestionBloc/question_bloc.dart";
import "package:fluter_prjcts/Firestore/Question/question.repository.dart";
import "package:fluter_prjcts/Models/question.dart";
import "package:fluter_prjcts/Widgets/PopUp/error.popup.dart";
import "package:fluter_prjcts/context_extension.dart";
import "package:flutter/material.dart";
import "package:fluter_prjcts/Router/router.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:fluter_prjcts/Actions/Buttons/back_button.dart";
import "package:fluter_prjcts/Blocs/AnswersBloc/answer_bloc.dart";
import "package:fluter_prjcts/Widgets/Other/screen_title.dart";

class QuestionListPage extends StatefulWidget {
  final String topicId;
  const QuestionListPage({
    super.key,
    required this.topicId,
  });

  @override
  State<QuestionListPage> createState() => QuestionListState();
}


class QuestionListState extends State<QuestionListPage> {
  late QuestionBloc qBloc;
  @override
  void initState() {
    super.initState();
    qBloc = context.maybeRead<QuestionBloc>() ?? QuestionBloc(repository: QuestionRepository(firestore: FirebaseFirestore.instance));
    qBloc.add(SubscribeQuestions(widget.topicId));
  }

  void _addQuestion() {
    router.pushNamed("/new-question", extra: widget.topicId);
  }

  Widget _buildQuestionList(BuildContext context, List<Question> questions) {
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final q = questions[index];
        return QuestionCard(
          question: q,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40,),
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ReturnBackButton(iconColor: Colors.amber),
                ),
                Center(child: ScreenTitle(title: "Questions")),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _addQuestion,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.amber,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text("New Question+", style: TextStyle(fontSize: 24)),
              ),
            ),

            Expanded(
              child: BlocListener<QuestionBloc, QuestionState>(
                listener: (context, state) {
                  if (state is QuestionsLoadFailed) {
                    showErrorDialog(
                      context: context,
                      title: "Error",
                      message: state.message,
                      icon: Icons.error,
                      onRetry: () {}, // or retry logic
                    );
                  }
                },
                  child: BlocProvider.value(
                      value: qBloc,
                      child: BlocBuilder<QuestionBloc, QuestionState>(
                          builder: (context, questionState) {
                            if(questionState is QuestionsLoadSuccess) {
                              final q = questionState.questions;
                              if(q.isEmpty) {
                                return const Center(child: Text("No questions"));
                              } else {
                                return _buildQuestionList(context, questionState.questions);
                              }
                            } else if(questionState is QuestionsLoading) {
                              return const Center(child:
                                  Column(
                                    children: [
                                      Text("Loading questions"),

                                      SizedBox(height: 20,),

                                      CircularProgressIndicator()
                                    ],
                                  )
                              );
                            } else if (questionState is QuestionsLoadFailed) {
                               showErrorDialog(
                                  context: context,
                                  title: "Error",
                                  message: "Failed to load questions",
                                  icon: Icons.error,
                                  onRetry: () {}
                              );
                               return Center();
                            }
                            return const Center();
                          }
                      ),
                  ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionCard extends StatefulWidget {
  final Question question;

  const QuestionCard({
    super.key,
    required this.question,
  });

  @override
  State<StatefulWidget> createState() => _QuestionCardState();
}
class _QuestionCardState extends State<QuestionCard> {
  bool isExpanded = false;
  late Question question;
  @override
  void initState() {
    super.initState();
    question = widget.question;
  }

  void toggleExpand(BuildContext context) {
    setState(() {
      isExpanded = !isExpanded;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Card(
              color: const Color(0xFF3A3D49),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        question.content,
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        toggleExpand(context);
                      },
                      icon: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                      ),
                      color: Colors.amber,
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded)
              AnswersListWidget(questionId: question.id),
          ],
        );
  }
}


class AnswersListWidget extends StatefulWidget {
  const AnswersListWidget({
    super.key,
    required this.questionId,
  });

  final String questionId;

  @override
  State<StatefulWidget> createState() => _AnswersListState();

}

class _AnswersListState extends State<AnswersListWidget> {
  late AnswersBloc _answersBloc;

  @override
  void initState() {
    super.initState();
    final firestore = FirebaseFirestore.instance;
    _answersBloc = AnswersBloc(firestore: firestore);
    _answersBloc.add(SubscribeAnswers(widget.questionId));
  }

  @override
  void dispose() {
    _answersBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      BlocProvider.value(
        value: _answersBloc,
        child: BlocBuilder<AnswersBloc, AnswerState>(
          builder: (context, answersState) {
            if(answersState is AnswerLoadSuccess) {
              final answers = answersState.answers;
              if (answers.isEmpty) {
                return const Text("No answers");
              } else {
                return Column(
                  children: answers.map((answer) {
                    return Card(
                      color: const Color(0xFF4D5061),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius
                          .circular(12)),
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 12),
                      child: ListTile(
                        title: Text(
                          answer.content,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          answer.isCorrect ? Icons.check_circle : Icons.cancel,
                          color: answer.isCorrect ? Colors.greenAccent : Colors
                              .redAccent,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            }
            return CircularProgressIndicator();
          }
      )
    );
  }
}
