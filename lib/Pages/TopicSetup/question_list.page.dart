import "package:fluter_prjcts/Firestore/Question/question.firestore.dart";
import "package:fluter_prjcts/Firestore/Topic/topic.firestore.dart";
import "package:fluter_prjcts/Models/answer.dart";
import "package:fluter_prjcts/Models/question.dart";
import "package:fluter_prjcts/Screens/loading_screen.dart";
import "package:flutter/material.dart";
import "package:fluter_prjcts/Router/router.dart";
import "../../Actions/Buttons/back_button.dart";
import "../../Models/topic.dart";
import "../../Widgets/Other/screen_title.dart";

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
  String? expandedQuestionId;
  Map<String, List<Answer>> answerCache = {};

  void _addQuestion() {
    router.pushNamed("/new-question", extra: widget.topicId);
  }

  Future<Map<String, dynamic>> fetchData() async{
    final topic = await getTopic(widget.topicId);
    final questions = await getTopicQuestions(widget.topicId);

    return { "topic": topic, "questions": questions };
  }

  Future<List<Answer>> _getAnswers(String questionId) async{
    if(answerCache.containsKey(questionId)) return answerCache[questionId]!;

    final answers = await getAnswers(questionId);
    answerCache[questionId] = answers;
    return answers;
  }

  Widget _buildAnswerList(List<Answer> answers) {
    return Column(
      children: answers.map((answer) {
        return Card(
          color: const Color(0xFF4D5061),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: ListTile(
            title: Text(
              answer.content,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Icon(
              answer.isCorrect ? Icons.check_circle : Icons.cancel,
              color: answer.isCorrect ? Colors.greenAccent : Colors.redAccent,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuestionList(BuildContext context, data) {
    final topic = data["topic"] as Topic;
    final questions = data["questions"] as List<Question>;

    if (questions.isEmpty) {
      return const Center(
        child: Text(
          "No questions available.",
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
      );
    }

    return ListView.separated(
      itemCount: questions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final q = questions[index];
        final isExpanded = q.id == expandedQuestionId;
        return Column(
          children: [
            Card( color: const Color(0xFF3A3D49),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${topic.title}: ${q.content}",
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if(isExpanded) {
                          setState(() => expandedQuestionId = null);
                        } else {
                          await _getAnswers(q.id);
                          setState(() => expandedQuestionId = q.id);
                        }
                      },
                      icon: Icon(
                        isExpanded ? Icons.expand_less: Icons.expand_more),
                      color: Colors.amber,
                    ),
                  ],
                ),
              ),
            ),
            if(isExpanded && answerCache.containsKey(q.id))
              _buildAnswerList(answerCache[q.id]!),
          ],
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
              child: Center(
                child: LoadingScreen(
                  future: fetchData,
                  builder: _buildQuestionList,
                  loadingText: "Getting questions...",
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}