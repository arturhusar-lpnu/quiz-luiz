import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Blocs/QuestionBloc/question_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Models/topic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleTopicCard extends StatefulWidget {
  final Topic topic;
  final Color mainColor;
  final TextStyle titleStyle;
  final TextStyle questionsStyle;
  final VoidCallback onCardTapped;
  final double headerWidth;

  const SimpleTopicCard({
    super.key,
    required this.topic,
    required this.mainColor,
    required this.titleStyle,
    required this.questionsStyle,
    required this.onCardTapped,
    this.headerWidth = 100,
  });

  @override
  State<SimpleTopicCard> createState() => _SimpleTopicCardState();
}

class _SimpleTopicCardState extends State<SimpleTopicCard> {
  late QuestionBloc qBloc;

  @override
  void initState() {
    super.initState();
    final firestore = FirebaseFirestore.instance;
    qBloc = QuestionBloc(firestore: firestore);
    qBloc.add(SubscribeQuestions(widget.topic.id));
  }

  Widget _buildContent(BuildContext context) {
    return BlocProvider.value(
      value: qBloc,
      child: BlocBuilder<QuestionBloc, QuestionState>(
          builder: (context, state) {
            if(state is QuestionsLoadSuccess) {
              final questionsCount = state.questions.length;
              String questionsText = "$questionsCount questions";
              if(questionsCount == 0) {
                questionsText = "No questions";
              }
              return IntrinsicHeight(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 80),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3D4D),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      ///Header
                      Container(
                        width: widget.headerWidth,
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                        decoration: BoxDecoration(
                          color: widget.mainColor,
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                        ),
                        child: Text(
                          widget.topic.title,
                          style: widget.titleStyle,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// Questions Count
                      Expanded(
                        child: Text(
                          questionsText,
                          style: widget.questionsStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12)
                    ],
                  ),
                ),
              );
            }
            return Column(
              children: [
                const Center(
                    child: Text(
                        "Loading...")
                ),
                CircularProgressIndicator()
              ],
            );
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onCardTapped,
      child: _buildContent(context),
    );
  }
}
