import 'package:flutter/material.dart';
import "package:fluter_prjcts/Models/topic.dart";
import "package:fluter_prjcts/Router/router.dart";
import "package:fluter_prjcts/Actions/Buttons/action_button.dart";
import "package:fluter_prjcts/Models/player.dart";

class GameResultScreen extends StatelessWidget {
  final String result;
  final String score;
  final Player host;
  final List<Topic> solvedTopics;

  const GameResultScreen({
    super.key,
    required this.result,
    required this.score,
    required this.host,
    required this.solvedTopics,
  });

  Widget buildTopicList(BuildContext context, List<Topic> topics) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final t = topics[index];
          return TopicCard(
            topic: t,
          );
        },
      );
  }


  @override
  Widget build(BuildContext context) {
    Color topColor = Colors.deepPurpleAccent;
    if(result == "Win") {
      topColor = Colors.greenAccent;
    } else if (result == "Loss") {
      topColor = Colors.redAccent;
    }

    final String title = "${host.username}: $result";
    final isSolvedTopics = solvedTopics.isNotEmpty;

    return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    body: SingleChildScrollView(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40,),
          Center(
            child: Text(
              title,
              style: TextStyle(
                color: topColor,
                fontSize: 32,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Container(
          //   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          //   decoration: BoxDecoration(
          //     color: topColor,
          //     borderRadius: const BorderRadius.only(
          //       topLeft: Radius.circular(20),
          //       topRight: Radius.circular(20),
          //     ),
          //   ),
          //   child:
          // ),
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
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Center(
                  child: Text(
                    "Solved Topics: ${solvedTopics.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                if(isSolvedTopics)
                  buildTopicList(context, solvedTopics),
                Center(
                  child: ActionButton(
                      text: "Ok",
                      textColor: Colors.white,
                      onPressed: () {
                        router.go("/");
                      },
                      color: Colors.deepPurpleAccent,
                      width: 100,
                      height: 50
                  ),
                ),
              ],
            ),

          ),
        ],
      ),
    )
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