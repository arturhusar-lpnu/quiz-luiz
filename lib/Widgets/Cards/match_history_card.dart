import "package:fluter_prjcts/Models/match_history_details.dart";
import "package:flutter/material.dart";

const Map matchResultHeaderColors = {
  MatchResult.Draw :  Color(0xFF929292),
  MatchResult.Win : Color(0xFF5DD39E),
  MatchResult.Loss : Color(0xFFD66C6C)
};

class MatchHistoryCard extends StatelessWidget {
  final MatchHistoryDetails matchDetails;
  final double width;
  final double height;
  final Color headerBackColor;
  final Color bodyBackColor;

  const MatchHistoryCard({
    super.key,
    required this.matchDetails,
    required this.width,
    required this.height,
    required this.headerBackColor,
    this.bodyBackColor = const Color(0xFF30323D),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bodyBackColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// **Header Section**
          MatchCardHeader(
            title: matchDetails.result.name,
            icon : Icon(Icons.account_circle, color: Colors.black,),
            backgroundColor: matchResultHeaderColors[matchDetails.result],
          ),

          /// **Body Section**
          MatchCardBody(
            type: matchDetails.type,
            topics: matchDetails.topics,
          ),
        ],
      ),
    );
  }
}

/// **Header Widget (Image(Icon for now TODO image of user profile later) + Title)**
class MatchCardHeader extends StatelessWidget {
  final String title;
  final Icon icon;
  final Color backgroundColor;

  const MatchCardHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          icon,
          // CircleAvatar(
          //   radius: 20,
          //   child: icon,
          // ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

/// **Body Widget (Match Details)**
class MatchCardBody extends StatelessWidget {
  final String type;
  final String topics;

  const MatchCardBody({
    super.key,
    required this.type,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Type: $type",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Topic${topics.length > 1 ? 's' : ''}: ${topics.substring(0, 4)}...",
            style: TextStyle(
              color: Color(0xFF929292),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
