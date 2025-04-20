import "dart:math";

import "package:fluter_prjcts/Models/topic.dart";
import "package:flutter/material.dart";
import "package:fluter_prjcts/Router/router.dart";

import "../../Actions/Buttons/action_button.dart";
import "../../Models/player.dart";


Future<void> showGameResultDialog(BuildContext context, {
  required String result,
  required String score,
  required Player host,
  required List<Topic> solvedTopics
}) async {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: const Color.fromRGBO(0, 0, 0, 0.5),
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: _ResultPopup(
            result: result,
            score: score,
            host: host,
            solvedTopics: solvedTopics,
        ),
      );
    },
  );
}

class _ResultPopup extends StatelessWidget {
  final String result;
  final String score;
  final  Player host;
  final List<Topic> solvedTopics;
  const _ResultPopup({
    required this.result,
    required this.score,
    required this.host,
    required this.solvedTopics,
  });


  Widget buildTopicList(BuildContext context, List<Topic> topics) {
    double listHeight = min(solvedTopics.length * 70.0, 300.0);
    return SizedBox(
      height: listHeight,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final t = topics[index];
          return TopicCard(
            topic: t,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color topColor = result == "Win" ? Color(0xFF7173FF) : Colors.amber;
    final String title = "${host.username}: $result";
    final isSolvedTopics = solvedTopics.isNotEmpty;
    return SingleChildScrollView (
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            decoration: BoxDecoration(
              color: topColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            decoration: const BoxDecoration(
              color: Color(0xFF30323d),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Center(
                  child: Text(
                    score,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Center(
                  child: Text(
                    "Solved Topics: ${solvedTopics.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                if(isSolvedTopics)
                  buildTopicList(context, solvedTopics),
                Center(
                  child: ActionButton(
                      text: "Ok",
                      textColor: Colors.black,
                      onPressed: () {
                        router.go("/");
                      },
                      color: topColor,
                      width: 100,
                      height: 50
                  ),
                ),
              ],
            ),

          ),
        ],
      ),
    );

  }
}

class TopicCard extends StatelessWidget {
  final Topic topic;

  const TopicCard({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF3A3D49),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                topic.title,
                style: const TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.check_circle,
              color: Colors.greenAccent,
            )
          ],
        ),
      ),
    );
  }
}