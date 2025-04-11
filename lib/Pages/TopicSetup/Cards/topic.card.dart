import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Models/topic.dart';
import 'package:fluter_prjcts/Actions/RadioButtons/select_radio_button.dart';
import 'package:fluter_prjcts/Firestore/Topic/topic.firestore.dart';

class TopicCard extends StatefulWidget {
  final Topic topic;
  final Color mainColor;
  final bool isSelected;
  final TextStyle titleStyle;
  final TextStyle questionsStyle;
  final VoidCallback onSelectionTapped;
  final VoidCallback onCardTapped;
  final double headerWidth;

  const TopicCard({
    super.key,
    required this.topic,
    required this.mainColor,
    required this.onSelectionTapped,
    required this.isSelected,
    required this.titleStyle,
    required this.questionsStyle,
    required this.onCardTapped,
    this.headerWidth = 100,
  });

  @override
  State<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> {
    bool _isLoading = true;
    int _questionsCount = 0;

    @override
    void initState() {
      super.initState();
      _loadQuestions();
    }

    Future<void> _loadQuestions() async {
      setState(() {
        _isLoading = true;
      });

      try {
        final questions = await getTopicQuestions(widget.topic.id);

        if (mounted) {
          setState(() {
            _questionsCount = questions.length;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        throw Exception('Error loading questions: $e');
      }
    }

    Widget _buildContent(BuildContext context) {
      return IntrinsicHeight(
        child: Container(
          constraints: const BoxConstraints(minHeight: 80),
          decoration: BoxDecoration(
            color: const Color(0xFF3A3D4D),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              ///Header
              Container(
                width: widget.headerWidth,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                decoration: BoxDecoration(
                  color: widget.mainColor,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                ),
                child: Text(
                  widget.topic.title,
                  style: widget.titleStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: 12),

              /// Questions Count
              Expanded(
                child: _isLoading
                    ? const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Loading...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
                    : Text(
                  "$_questionsCount questions",
                  style: widget.questionsStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              SelectRadioButton(
                isSelected: widget.isSelected,
                onTap: widget.onSelectionTapped,
                color: widget.mainColor,
              ),
              const SizedBox(width: 12)
            ],
          ),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: widget.onCardTapped,
        child: _buildContent(context),
      );
    }
  }
