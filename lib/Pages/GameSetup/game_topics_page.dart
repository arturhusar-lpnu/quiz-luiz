import 'package:fluter_prjcts/Router/router.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Models/topic.dart';
import 'package:fluter_prjcts/Screens/loading_screen.dart';
import 'package:fluter_prjcts/Pages/TopicSetup/Cards/topic.card.dart';
import "package:fluter_prjcts/Firestore/Topic/topic.firestore.dart";

class GameTopicsPage extends StatefulWidget {
  final Set<String> selectedTopics;
  final Function(String) onSelectedTopic;

  const GameTopicsPage({
    super.key,
    required this.selectedTopics,
    required this.onSelectedTopic,
  });

  @override
  State<GameTopicsPage> createState() => _GameTopicsPageState();
}

class _GameTopicsPageState extends State<GameTopicsPage> {
  String searchQuery = "";
  List<Topic> cachedTopics = [];
  bool initialLoadComplete = false;
  late TextEditingController _searchController;
  int totalQuestions = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  void _addTopic() {
    router.push("/create-topic");
  }

  Future<void> fetchTopics() async {
    if (!initialLoadComplete) {
      cachedTopics = await getTopics();
      initialLoadComplete = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Select topic(s) of the game",
                style: TextStyle(color: Colors.amber, fontSize: 24),
              ),
              const SizedBox(height: 20),
              Text(
                "Selected ${widget.selectedTopics.length} game topic(s).\n$totalQuestions total questions",
                style: const TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              /// Search Field
              SearchBar(
                controller: _searchController,
                leading: const Icon(Icons.search),
                onChanged: _onSearch,
                hintText: "Search topics...",
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _addTopic,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.amber,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text("New Topic +", style: TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(height: 10),

              // Use the separate stateful TopicsList widget
              Expanded(
                child: LoadingScreen(
                  loadingText: "Picking the right ones",
                  future: fetchTopics,
                  backgroundColor: Colors.black,
                  builder: (context, _) {
                    List<Topic> filteredTopics = searchQuery.isEmpty
                        ? cachedTopics
                        : cachedTopics.where((topic) =>
                        topic.title.toLowerCase().contains(searchQuery.toLowerCase())
                    ).toList();

                    return TopicsList(
                      topics: filteredTopics,
                      selectedTopics: widget.selectedTopics,
                      onTopicSelected: widget.onSelectedTopic,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Separate stateful widget for the topic list
class TopicsList extends StatefulWidget {
  final List<Topic> topics;
  final Set<String> selectedTopics;
  final Function(String)? onTopicSelected;

  const TopicsList({
    super.key,
    required this.topics,
    required this.selectedTopics,
    required this.onTopicSelected,
  });

  @override
  State<TopicsList> createState() => _TopicsListState();
}

class _TopicsListState extends State<TopicsList> {
  // Keep a local copy of the selected topics for immediate UI updates
  late Set<String> localSelectedTopics;

  @override
  void initState() {
    super.initState();
    localSelectedTopics = Set<String>.from(widget.selectedTopics);
  }

  @override
  void didUpdateWidget(TopicsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedTopics != oldWidget.selectedTopics) {
      localSelectedTopics = Set<String>.from(widget.selectedTopics);
    }
  }

  void _updateSelection(String topicId) {
    // Update local state immediately for responsive UI
    setState(() {
      if (localSelectedTopics.contains(topicId)) {
        localSelectedTopics.remove(topicId);
      } else {
        localSelectedTopics.add(topicId);
      }
    });

    // Notify parent widget
    widget.onTopicSelected!(topicId);
  }

  Color getTopicColor(String topicId) {
    return localSelectedTopics.contains(topicId)
        ? Color(0xFF5DD39E)
        : Color(0xFF7173FF);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.topics.length,
      itemBuilder: (context, index) {
        final topic = widget.topics[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
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
            isSelected: localSelectedTopics.contains(topic.id),
            onCardTapped: () {
              router.pushNamed("/question-list", extra: topic.id);
              },
            onSelectionTapped: () => _updateSelection(topic.id),
          ),
        );
      },
    );
  }
}