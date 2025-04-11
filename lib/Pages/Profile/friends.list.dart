import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Screens/loading_screen.dart';
import "package:fluter_prjcts/Firestore/Player/player.firestore.dart";
import "package:fluter_prjcts/Widgets/user_image.helper.dart";
import 'package:fluter_prjcts/Actions/AnimatedButton/invite_player.button.dart';
import "package:fluter_prjcts/Firestore/Friends/friends.firestore.dart";
import 'package:fluter_prjcts/Router/router.dart';

class FriendListWidget extends StatelessWidget {
  final String playerId;

  const FriendListWidget({super.key, required this.playerId});

  Future<List<Map<String, dynamic>>> _fetchFriends() async {
    Set<String> friendIds = await getFriends(playerId);

    if (friendIds.isEmpty) {
      return [];
    }

    return Future.wait(friendIds.map((id) async {
      final username = await fetchUsername(id);
      final avatar = await fetchProfileImage(id);
      return {
        'id': id,
        'username': username,
        'avatar': avatar,
      };
    }));
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen<List<Map<String, dynamic>>>(
      future: _fetchFriends,
      backgroundColor: Colors.transparent,
      loadingText: "Loading friends...",
      builder: (context, friends) {
        if (friends.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "No friends added yet",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                icon: const Icon(Icons.person_add, color: Color(0xFF7173FF)),
                label: const Text(
                  "Add Friend",
                  style: TextStyle(color: Color(0xFF7173FF)),
                ),
                onPressed: () {
                  router.pushNamed("/add-friend");
                },
              ),
            ],
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(backgroundImage: friend['avatar']),
                      title: Text(
                        friend['username'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: InviteButton(
                        width: 100,
                        height: 40,
                        fontSize: 16,
                        color: const Color(0xFF7173FF),
                        userId: playerId,
                        opponentId: friend['id'],
                        onInviteTapped: () {},
                        isSelected: false,
                      ),
                    ),
                  );
                },
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.person_add, color: Color(0xFF7173FF)),
              label: const Text(
                "Add Friend",
                style: TextStyle(color: Color(0xFF7173FF)),
              ),
              onPressed: () {
                router.pushNamed("/add-friend");
              },
            ),
          ],
        );
      },
    );
  }
}


// class FriendListWidget extends StatelessWidget {
//   final String playerId;
//
//   const FriendListWidget({super.key, required this.playerId});
//
//   Future<List<Map<String, dynamic>>> _fetchFriends() async {
//     Set<String> friendIds = await getFriends(playerId);
//
//     return Future.wait(friendIds.map((id) async {
//       final username = await fetchUsername(id);
//       final avatar = await fetchProfileImage(id);
//       return {
//         'id': id,
//         'username': username,
//         'avatar': avatar,
//       };
//     }));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white10,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Friends",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 10),
//           LoadingScreen<List<Map<String, dynamic>>>(
//             future: _fetchFriends,
//             backgroundColor: Colors.transparent,
//             loadingText: "Loading friends...",
//             builder: (context, friends) {
//               if (friends.isEmpty) {
//                 return const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 20),
//                   child: Center(
//                     child: Text(
//                       "No friends added yet",
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                   ),
//                 );
//               }
//
//               return SizedBox(
//                 height: 250, // Fixed height container
//                 child: ListView.separated(
//                   shrinkWrap: true,
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   separatorBuilder: (_, __) => const SizedBox(height: 12),
//                   itemCount: friends.length,
//                   itemBuilder: (context, index) {
//                     final friend = friends[index];
//                     return Container(
//                       decoration: BoxDecoration(
//                         color: Colors.black26,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       child: ListTile(
//                         leading: CircleAvatar(backgroundImage: friend['avatar']),
//                         title: Text(
//                           friend['username'],
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                         trailing: InviteButton(
//                           width: 100,
//                           height: 40,
//                           fontSize: 16,
//                           color: const Color(0xFF7173FF),
//                           userId: playerId,
//                           opponentId: friend['id'],
//                           onInviteTapped: () {},
//                           isSelected: false,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           ),
//           const SizedBox(height: 10),
//           Center(
//             child: TextButton.icon(
//               icon: const Icon(Icons.person_add, color: Color(0xFF7173FF)),
//               label: const Text(
//                 "Add Friend",
//                 style: TextStyle(color: Color(0xFF7173FF)),
//               ),
//               onPressed: () {
//                 // Implement navigation to add friend screen
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }