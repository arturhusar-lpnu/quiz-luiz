import "package:fluter_prjcts/Actions/Buttons/action_button.dart";
import "package:fluter_prjcts/Models/match_details.dart";
import "package:flutter/material.dart";

class MatchCard extends StatelessWidget {
  final double width;
  final double height;
  final MatchDetails matchDetails;
  final Color headerBackColor;
  final Color bodyBackColor;
  final Color titleColor;
  final ActionButton button;

  const MatchCard({
    super.key,
    required this.matchDetails,
    required this.width,
    required this.height,
    required this.headerBackColor,
    this.titleColor = Colors.black,
    this.bodyBackColor = const Color(0xFF30323D),
    required this.button,
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
              //Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: headerBackColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Center(
                  child: Text(
                    matchDetails.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                ),
              ),

              //Body
              Row (
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Type: ${matchDetails.type}",
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 4,),
                        // const SizedBox(height: 4, width:),
                        Text(
                          "Topics: ${matchDetails.topics}",
                          style: TextStyle(
                            color: Color(0xFF929292),
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 20,),
                  button
                ],
              ),
            ],
        ),
    );
  }
}
