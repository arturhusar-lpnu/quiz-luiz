import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluter_prjcts/Firestore/FCM/notification.firestore.dart';
import "package:fluter_prjcts/Firestore/LeaderBoard/leaderboard.firestore.dart";

Future<User> signUpPlayer(String username, String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;
    if (user != null) {
      await FirebaseFirestore.instance.collection("players").doc(user.uid).set({
        "username": username,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });
      await addToLeaderBoard(user.uid);
    }


    return user!;
  } catch (e) {
    throw ("Error registering user: $e");
  }
}

Future<User?> signInPlayer(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    await initFCMToken();

    return userCredential.user;
  } catch (e) {
    throw Exception("Error signing in: $e");
  }
}
