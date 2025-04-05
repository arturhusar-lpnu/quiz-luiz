import "package:fluter_prjcts/Firestore/Topic/topic.firestore.dart";
import "package:fluter_prjcts/Models/question.dart";
import "package:fluter_prjcts/Screens/loading_screen.dart";
import "package:flutter/material.dart";
import "package:fluter_prjcts/Router/router.dart";

import "../../Actions/Buttons/back_button.dart";
import "../../Widgets/Other/screen_title.dart";

class QuestionListPage extends StatelessWidget {
  final String topicId;

  const QuestionListPage({
    super.key,
    required this.topicId,
  });

  void _addQuestion() {
    router.pushNamed("/new-question", extra: topicId);
  }
  Future<List<Question>> getQuestions() async{
    return await getTopicQuestions(topicId);
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
            Align(
                alignment: Alignment.topLeft,
                child:
                Row(
                  children: [
                    ReturnBackButton(
                        iconColor: Colors.amber,
                    ),
                    SizedBox(width: 70),
                    Center(
                      child: ScreenTitle(title: "Questions"),
                    ),
                  ],
                )
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
                future: getQuestions,
                builder: (context, List<Question> questions) {
                  // Display a message if no questions are available
                  if (questions.isEmpty) {
                    return Center(
                      child: Text("No questions available.", style: TextStyle(fontSize: 18)),
                    );
                  }

                  return ListView(
                    children: questions.map((q) => Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ListTile(title: Text(q.content)),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              router.pushNamed("/answers", extra: q.id);
                            },
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )).toList(),
                    );
                  },
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