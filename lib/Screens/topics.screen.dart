import 'package:fluter_prjcts/Models/topic.dart';
import 'package:fluter_prjcts/Pages/TopicSetup/List/simple_topic.list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluter_prjcts/Actions/Buttons/back_button.dart';
import 'package:fluter_prjcts/Blocs/TopicBloc/topic_bloc.dart';
import 'package:fluter_prjcts/Actions/Buttons/help_button.dart';
import 'package:fluter_prjcts/Router/router.dart';
import 'package:fluter_prjcts/Widgets/Other/screen_title.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsState();
}

class _TopicsState extends State<TopicsScreen> {
  late TextEditingController _searchController;
  String searchQuery = "";
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<TopicBloc>().add(SubscribeTopics());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  void _addTopic() => router.push("/create-topic");

  void _onSearch(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  List<Topic> filterTopics(List<Topic> topics) {
    return topics.where((topic) =>
        topic.title.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
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

              Align(
                alignment: Alignment.centerRight,
                child: const HelpButton()
              )

            ],
          ),

          const SizedBox(height: 50),
          SearchBar(
            controller: _searchController,
            leading: const Icon(Icons.search),
            onChanged: _onSearch,
            hintText: "Search topics...",
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<TopicBloc, TopicState>(
              builder: (context, state) {
                if(state is TopicLoadSuccess) {
                  final filteredTopics = filterTopics(state.topics);
                  return SimpleTopicsList(topics: filteredTopics);
                }

                return const Center( child: CircularProgressIndicator(),);
              },
            )
          ),

          Align(
            alignment: Alignment.bottomRight,
            child:
            FloatingActionButton(
              onPressed: _addTopic,
              backgroundColor: const Color(0xFF7173FF),
              tooltip: 'Add Topic',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28
              ),
            ),
            // FloatingActionButton.extended(
            //   onPressed: _addTopic,
            //   backgroundColor: const Color(0xFF6E3DDA),
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(30),
            //   ),
            //   label: const Text('Add Topic'),
            //   icon: const Icon(Icons.add, color: Colors.white, size: 28
            //   ),
            // ),
          )
        ],
        ),
      ),
    );
  }
}