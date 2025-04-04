import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:fluter_prjcts/Models/player.dart";

Future<String?> fetchUsername(String uid) async {
  DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if (userDoc.exists) {
    return userDoc['username'];
  }
  return null;
}

Future<List<Player>> getAllPlayers() async{
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('players')
      .where("id", isNotEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .get();

  return snapshot.docs.map((doc) => Player.fromFirestore(doc)).toList();
}

Future<Player?> getCurrentPlayer() async{
  return await getPlayer(FirebaseAuth.instance.currentUser!.uid);
}

Future<Player> getPlayer(String playerId) async {
  var docSnapshot = await FirebaseFirestore.instance.collection("players").doc(playerId).get();
    if (!docSnapshot.exists || docSnapshot.data() == null) {
      throw Exception("Player not found");
    }
    return Player.fromFirestore(docSnapshot);
}
