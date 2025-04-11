import 'package:fluter_prjcts/Firestore/Topic/topic.firestore.dart';
import 'package:fluter_prjcts/Models/topic.dart';
import 'package:fluter_prjcts/Pages/TopicSetup/List/simple_topic.list.dart';
import 'package:fluter_prjcts/Screens/loading_screen.dart';
import 'package:flutter/material.dart';
import '../Actions/Buttons/back_button.dart';
import '../Pages/TopicSetup/Buttons/save_topic.button.dart';
import '../Router/router.dart';
import '../Widgets/Other/screen_title.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => TopicsState();
}

class TopicsState extends State<TopicsScreen> {

  late TextEditingController _searchController;
  String searchQuery = "";
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

  void _addTopic() {
    router.push("/create-topic");
  }

  void _onSearch(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  Future<List<Topic>> fetchTopics() async {
    return await getTopics();
  }

  Widget _buildTopicsList(BuildContext context, List<Topic> topics) {
    List<Topic> filteredTopics = topics.where((topic) =>
        topic.title.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();

    return SimpleTopicsList(
      topics: filteredTopics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ReturnBackButton(iconColor: Colors.amber),
            ),
            Center(child: ScreenTitle(title: "Topics")),
          ],
        ),

        const SizedBox(height: 50),
        SearchBar(
          controller: _searchController,
          leading: const Icon(Icons.search),
          onChanged: _onSearch,
          hintText: "Search topics...",
        ),
        const SizedBox(height: 50),
        Expanded(child: LoadingScreen(
            future: fetchTopics,
            builder: _buildTopicsList,
            loadingText: "Almost there",
            backgroundColor: Theme
                .of(context)
                .scaffoldBackgroundColor
          ),
        ),

        const SizedBox(height: 50),
        SaveTopicButton(
          text: "Add Topic",
          color: Color(0xFF6E3DDA),
          width: double.infinity,
            height: 90,
            onPressed: _addTopic,
          ),
          ],
        ),
      ),
    );
  }
}