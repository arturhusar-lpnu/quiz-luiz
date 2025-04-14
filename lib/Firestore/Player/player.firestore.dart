import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:fluter_prjcts/Models/player.dart";

Future<String?> fetchUsername(String uid) async {
  DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('players').doc(uid).get();
  if (userDoc.exists) {
    return userDoc['username'];
  }
  return null;
}


Future<List<Player>> getAllPlayers() async{
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('players').get();
  List<Player> players = snapshot.docs
      .where((doc) => doc.id != FirebaseAuth.instance.currentUser?.uid)
      .map((doc) => Player.fromFirestore(doc))
      .toList();

  return players;
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

Future<void> checkUsername(String username) async{
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('players').get();
  bool taken = snapshot.docs
      //.where((doc) => doc.id != FirebaseAuth.instance.currentUser?.uid)
      .map((doc) => Player.fromFirestore(doc))
      .any((p) => p.username == username);
  if(taken) {
    throw Exception("username $username is taken.\nTry another one");
  }
}