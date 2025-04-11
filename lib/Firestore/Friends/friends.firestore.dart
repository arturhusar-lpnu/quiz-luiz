import 'package:cloud_firestore/cloud_firestore.dart';

Future<Set<String>> getFriends(String playerId) async {
  final fireStore = FirebaseFirestore.instance.collection("friends");

  //added friends by player
  final addedFriends = await fireStore.where("friendId", isEqualTo: playerId).get();

  //player of friends
  final addedPlayer = await fireStore.where("playerId", isEqualTo: playerId).get();

  final friendIds = <String>{};

  for(var doc in addedFriends.docs) {
    friendIds.add(doc["playerId"] as String);
  }

  for(var doc in addedPlayer.docs) {
    friendIds.add(doc["friendId"] as String);
  }

  return friendIds;
}