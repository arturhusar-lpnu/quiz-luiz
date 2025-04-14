import 'dart:async';
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
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;
  bool _isScrolling = true;

  @override
  void initState() {
    super.initState();
    final currPlayer = CurrentPlayer.player;
    context.read<RecentTopicsBloc>().add(SubscribeRecentTopics(currPlayer!.id));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    const scrollDuration = Duration(milliseconds: 40);
    const scrollAmount = 1.0;

    _scrollTimer = Timer.periodic(scrollDuration, (_) {
      if (!_isScrolling || !_scrollController.hasClients) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;

      // If we're near the end, loop back to start with an overlap
      if (currentScroll >= maxScroll) {
        _scrollController.jumpTo(0 + scrollAmount);
      } else {
        _scrollController.jumpTo(currentScroll + scrollAmount);
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
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

              if(topics.isNotEmpty)
                SizedBox(
                  height: 55,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTapDown: (_) => setState(() => _isScrolling = false),
                          onTapUp: (_) => setState(() => _isScrolling = true),
                          onHorizontalDragStart: (_) => setState(() => _isScrolling = false),
                          onHorizontalDragEnd: (_) => setState(() => _isScrolling = true),
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.transparent,
                                  Colors.white,
                                  Colors.white,
                                  Colors.transparent
                                ],
                                stops: const [0.0, 0.05, 0.95, 1.0],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: ListView.builder(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: topics.length * 3,
                              itemBuilder: (context, index) {
                                final topic = topics[index % topics.length];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: _RecentTopicWidget(topic: topic),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
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
