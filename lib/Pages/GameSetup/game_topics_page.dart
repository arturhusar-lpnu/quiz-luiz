import 'package:fluter_prjcts/Models/answer.dart';
import 'package:fluter_prjcts/Models/question.dart';
import 'package:flutter/material.dart';
import '../../Models/topic.dart';
import '../../Widgets/Cards/topic_card.dart';

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

  List<Color> topicColors = [Color(0xFF5DD39E), Color(0xFF7173FF), Colors.amber, Colors.white24, Colors.orange];
  Map<String, Color> topicColorsMap = {};
  @override
  void initState() {
    super.initState();
    selectedTopics = widget.selectedTopics.toSet();
    _assignColors();
  }

  List<Topic> _getAllTopics() {
    return [
      Topic(
        id: "1",
        title: "AC/DC",
        description: "A topic about legendary band",
        questions: [
          Question(
            content: "1st Question",
            answerOptions: [
              Answer(content: "False", isCorrect: false),
              Answer(content: "Correct", isCorrect: true),
            ],
          )
        ],
      ),
      Topic(
        id: "2",
        title: "Oppenheimer",
        description: "A topic about a guy",
        questions: [
          Question(
            content: "1st Question",
            answerOptions: [
              Answer(content: "False", isCorrect: false),
              Answer(content: "Correct", isCorrect: true),
            ],
          ),
          Question(
            content: "2nd Question",
            answerOptions: [
              Answer(content: "False", isCorrect: false),
              Answer(content: "Correct", isCorrect: true),
            ],
          ),
          Question(
            content: "3rd Question",
            answerOptions: [
              Answer(content: "False", isCorrect: false),
              Answer(content: "Correct", isCorrect: true),
            ],
          ),
        ],
      ),
      Topic(
        id: "3",
        title: "Star wars",
        description: "A topic about a guy",
        questions: [
          Question(
            content: "1st Question",
            answerOptions: [
              Answer(content: "False", isCorrect: false),
              Answer(content: "Correct", isCorrect: true),
            ],
          ),
          Question(
            content: "2nd Question",
            answerOptions: [
              Answer(content: "False", isCorrect: false),
              Answer(content: "Correct", isCorrect: true),
            ],
          ),
          Question(
            content: "3rd Question",
            answerOptions: [
              Answer(content: "False", isCorrect: false),
              Answer(content: "Correct", isCorrect: true),
            ],
          ),
        ],
      ),
      Topic(
        id: "4",
        title: "Avengers",
        description: "A topic about a guy",
        questions: [
          Question(
            content: "1st Question",
            answerOptions: [
              Answer(content: "False", isCorrect: false),
              Answer(content: "Correct", isCorrect: true),
            ],
          ),
          Question(
            content: "2nd Question",
            answerOptions: [
              Answer(content: "False", isCorrect: false),
              Answer(content: "Correct", isCorrect: true),
            ],
          ),
          Question(
            content: "3rd Question",
            answerOptions: [
              Answer(content: "False", isCorrect: false),
              Answer(content: "Correct", isCorrect: true),
            ],
          ),
        ],
      ),
      Topic(
        id: "5",
        title: "Gugo",
        description: "A topic about a guy",
        questions: [
          Question(
            content: "1st Question",
            answerOptions: [
              Answer(content: "False", isCorrect: false),
              Answer(content: "Correct", isCorrect: true),
            ],
          ),
          Question(
            content: "2nd Question",
            answerOptions: [
              Answer(content: "False", isCorrect: false),
              Answer(content: "Correct", isCorrect: true),
            ],
          ),
          Question(
            content: "3rd Question",
            answerOptions: [
              Answer(content: "False", isCorrect: false),
              Answer(content: "Correct", isCorrect: true),
            ],
          ),
        ],
      ),
      Topic(
        id: "6",
        title: "Winston Churchill",
        description: "A topic about a guy",
        questions: [
          Question(
            content: "1st Question",
            answerOptions: [
              Answer(content: "False", isCorrect: false),
              Answer(content: "Correct", isCorrect: true),
            ],
          ),
          Question(
            content: "2nd Question",
            answerOptions: [
              Answer(content: "False", isCorrect: false),
              Answer(content: "Correct", isCorrect: true),
            ],
          ),
          Question(
            content: "3rd Question",
            answerOptions: [
              Answer(content: "False", isCorrect: false),
              Answer(content: "Correct", isCorrect: true),
            ],
          ),
        ],
      ),
    ];
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

  @override
  Widget build(BuildContext context) {

    List<Topic> filteredTopics = _getAllTopics().where((topic) {
      return topic.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    if (searchQuery.isEmpty) {
      // Pin selected topics to the top if search query is empty
      filteredTopics.sort((a, b) {
        bool aSelected = selectedTopics.contains(a.id);
        bool bSelected = selectedTopics.contains(b.id);

        // Selected topics come first, while keeping the relative order of selected and unselected topics
        if (aSelected && !bSelected) {
          return -1; // a comes before b
        } else if (!aSelected && bSelected) {
          return 1;  // b comes before a
        } else {
          return 0;  // keep the relative order of a and b
        }
      });
    }

    final selectedTopicsList = _getAllTopics().where((t) => selectedTopics.contains(t.id)).toList();
    final totalQuestions = selectedTopicsList.fold(0, (sum, topic) => sum + topic.questions.length);

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
          Text("Selected ${selectedTopics.length} game topic(s).\n$totalQuestions total questions", style: TextStyle(color: Colors.white, fontSize: 20,), textAlign: TextAlign.center,),
          const SizedBox(height: 10),
          // Search Bar
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

          // Topics List
          Expanded(
            child: ListView.builder(
              itemCount: filteredTopics.length,
              itemBuilder: (context, index) {
                final topic = filteredTopics[index];
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