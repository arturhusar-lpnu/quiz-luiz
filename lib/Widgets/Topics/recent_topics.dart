import 'package:fluter_prjcts/Firestore/Player/current_player.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Router/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluter_prjcts/Blocs/RecentTopicsBloc/recent_topics_bloc.dart';

class RecentTopicsWidget extends StatefulWidget {
  const RecentTopicsWidget({super.key});

  @override
  State<RecentTopicsWidget> createState() => _RecentTopicsWidgetState();
}

class _RecentTopicsWidgetState extends State<RecentTopicsWidget> {
  @override
  void initState() {
    super.initState();
    final currPlayer = CurrentPlayer.player;
    context.read<RecentTopicsBloc>().add(SubscribeRecentTopics(currPlayer!.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentTopicsBloc, RecentTopicsState>(
      builder: (context, state) {
        final topics = state is RecentTopicLoadSuccess ? state.topics : [];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF3A3D4D),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Recent Topics", style: TextStyle(fontSize: 18, color: Colors.amber)),
              const SizedBox(height: 12),
              if (topics.isEmpty)
                const Text("No recent topics", style: TextStyle(color: Colors.white70)),

              if (topics.isNotEmpty)
                SizedBox(
                  height: 55,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: topics.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final topic = topics[index];
                            return _RecentTopicWidget(topic: topic);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => router.push("/topics"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                          foregroundColor: const Color(0xFFFDFDFD),
                          backgroundColor: const Color(0xFF7173FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Icon(Icons.more_horiz, color: Colors.white),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _RecentTopicWidget extends StatelessWidget {
  const _RecentTopicWidget({
    required this.topic,
  });

  final dynamic topic;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => router.push("/topics"),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        foregroundColor: const Color(0xFF444545),
        backgroundColor: const Color(0xFF5DD39E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Text(topic.title, style: const TextStyle(fontSize: 14)),
    );
  }
}
