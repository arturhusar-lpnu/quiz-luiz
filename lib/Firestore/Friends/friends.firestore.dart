import 'package:cloud_firestore/cloud_firestore.dart';

Future<Set<String>> getFriends(String playerId) async {
  final fireStore = FirebaseFirestore.instance.collection("friends");

  final addedFriends = await fireStore.where("friendId", isEqualTo: playerId).get();

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

Future addNewFriend(String playerId, String friendId) async {
  final fireStore = FirebaseFirestore.instance.collection("friends");
  try {
    await fireStore.add({
      "playerId" : playerId,
      "friendId" : friendId,
    });
  } catch(e) {
    throw Exception('Api Error: $e');
  }
}
