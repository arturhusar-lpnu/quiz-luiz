import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Models/topic.dart';
import 'package:fluter_prjcts/Screens/loading_screen.dart';
import 'package:fluter_prjcts/Widgets/Cards/topic_card.dart';
import "package:fluter_prjcts/Firestore/Topic/topic.firestore.dart";

class GameTopicsPage extends StatefulWidget {
  final Set<String> selectedTopics;
  final Function(String) onTopicSelected;

  const GameTopicsPage({
    super.key,
    required this.selectedTopics,
    required this.onTopicSelected,
  });

  @override
  _GameTopicsState createState() => _GameTopicsState();
}

class _GameTopicsState extends State<GameTopicsPage> {
  Set<String> selectedTopics = {};
  Set<Topic> topics = {};
  String searchQuery = "";
  int totalQuestions = 0;

  List<Color> topicColors = [Color(0xFF5DD39E), Color(0xFF7173FF), Colors.amber, Colors.white24, Colors.orange];
  Map<String, Color> topicColorsMap = {};
  @override
  void initState() {
    super.initState();
    selectedTopics = widget.selectedTopics.toSet();
    _assignColors();
    _updateQuestionCount();
  }

  void _updateSelection(String topicId) {
    setState(() {
      if (selectedTopics.contains(topicId)) {
        selectedTopics.remove(topicId);
        topicColorsMap.remove(topicId);
      } else {
        selectedTopics.add(topicId);
        _assignColors();
      }
    });
    widget.onTopicSelected(topicId);
    _updateQuestionCount();
  }

  Future<void> _updateQuestionCount() async {
    int count = 0;
    for (String topicId in selectedTopics) {
      final questions = await getTopicQuestions(topicId);
      count += questions.length;
    }

    setState(() {
      totalQuestions = count;
    });
  }

  void _assignColors() {
    int index = 0;
    for (var topicId in selectedTopics) {
      topicColorsMap[topicId] = topicColors[index % topicColors.length];
      index++;
    }
  }

  Color getTopicColor(String topicId) {
    return topicColorsMap[topicId] ?? Color(0xFF6E3DDA); // Default color if unselected
  }

  Future<List<Topic>> fetchTopics() async {
    final allTopics = await getTopics();
    allTopics.where((topic) {
      return topic.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return allTopics.where((topic) {
      return topic.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen<List<Topic>>(
      future: fetchTopics,
      builder: _buildContent,
    );
  }



  Widget _buildContent(BuildContext context, List<Topic> topicsList) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4D5061),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text("Select topic(s) of the game", style: TextStyle(color: Colors.amber, fontSize: 24)),
          const SizedBox(height: 20),
          Text(
            "Selected ${selectedTopics.length} game topic(s).\n$totalQuestions total questions",
            style: const TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          SearchBar(
            leading: const Icon(Icons.search),
            hintText: "Search topics...",
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: topicsList.length,
              itemBuilder: (context, index) {
                final topic = topicsList[index];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: TopicCard(
                    headerWidth: 120,
                    topic: topic,
                    mainColor: getTopicColor(topic.id),
                    titleStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF30323D),
                    ),
                    questionsStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    isSelected: selectedTopics.contains(topic.id),
                    onSelectionTapped: () => _updateSelection(topic.id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}