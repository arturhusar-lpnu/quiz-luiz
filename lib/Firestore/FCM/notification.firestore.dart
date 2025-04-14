import "dart:convert";
import "package:http/http.dart" as http;
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:fluter_prjcts/Models/game_data.dart";

Future<void> initFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if(token != null && uid != null) {
      await FirebaseFirestore.instance.collection('players').doc(uid).update({
        'fcmToken': token,
      });
    }
}


Future<void> sendGameInviteNotification(String playerId, GameData gameData) async {
  const String apiUrl = "https://quiz-luiz-api-1.onrender.com/sendGameInviteNotification"; //apiUrl : https://quiz-luiz-api-1.onrender.com/

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'playerId': playerId,
      'title': 'Quiz-Luiz Game Invite',
      'body': 'You are invited for a game with ${gameData.hostPlayer.username}',
      'gameData': gameData.toJson(),
      'type' : "game-invite",
    }),
  );
  if(response.statusCode == 200) {
    print("Notification sent");
  } else if(response.statusCode == 500) {
    print("Error sending notification");
  }
}

Future<void> sendFriendInviteNotification(String playerId, String friendId) async {
  const String apiUrl = "https://quiz-luiz-api-1.onrender.com/sendFriendInviteNotification"; //apiUrl : https://quiz-luiz-api-1.onrender.com/

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'playerId': playerId,
      'title': 'Quiz-Luiz Friend Invite',
      'body': 'New friend is waiting',
      'friendId': friendId,
      'type' : "friend-invite",
    }),
  );
  if(response.statusCode == 200) {
    print("[Friend-Invite] Notification sent");
  } else if(response.statusCode == 500) {
    print("[Friend-Invite] Error sending notification");
  }
}