import 'package:fluter_prjcts/Actions/AnimatedButton/invite_player.button.dart';
import 'package:fluter_prjcts/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserCard extends StatelessWidget {
  final User user;
  final String userId;
  final Color mainColor;
  final TextStyle usernameStyle;
  final VoidCallback onInviteTapped;
  final String selectedOpponentId;
  final double headerWidth;

  const UserCard({
    super.key,
    required this.user,
    required this.userId,
    required this.mainColor,
    required this.usernameStyle,
    required this.onInviteTapped,
    required this.selectedOpponentId,
    this.headerWidth = 100,
  });

  Future<ImageProvider> _fetchProfileImage(User user) async {
    final String imagePath = 'assets/user-profile/${user.id}.png';
    try {
      await rootBundle.load(imagePath);
      return AssetImage(imagePath);
    } catch (e) {
      return AssetImage('assets/user-profile/default.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3A3D4D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ///Header
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: headerWidth, // Fixed width to maintain consistency
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              ),
              child:
              FutureBuilder<ImageProvider>(
                  future: _fetchProfileImage(user),
                  builder: (context, snapshot) {
                    // Handling the different states of the Future
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        "Loading...",
                        style: TextStyle(fontSize: 18, color: Colors.black12),
                      );
                    } else if (snapshot.hasError) {
                      return const Text(
                        "Error fetching data",
                        style: TextStyle(fontSize: 18, color: Colors.black12),
                      );
                    } else if (snapshot.hasData) {
                      return Image(
                        image: snapshot.data!,
                        width: 50,
                        height: 50,
                      );
                    } else {
                      return const Text(
                        "No Data Available",
                        style: TextStyle(fontSize: 18, color: Colors.black12),
                      );
                    }
                  },
              ),
            ),
          ),


          const SizedBox(width: 12), // Spacing between sections

          /// Username
          Expanded(
            child:
            Text(
              user.username,
              style: usernameStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          InviteButton(
              width: 110,
              height: 50,
              fontSize: 20,
              color: mainColor,
              userId: userId,
              opponentId: user.id,
              onInviteTapped: onInviteTapped,
              isSelected: selectedOpponentId.isNotEmpty && selectedOpponentId == user.id
          ),
          const SizedBox(width: 12)
        ],
      ),
    );
  }
}
