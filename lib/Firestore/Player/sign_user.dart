import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<User> signUpUser(String username, String email, String password) async {
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
    }
    return user!;
  } catch (e) {
    throw ("Error registering user: $e");
  }
}

Future<User?> signInUser(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } catch (e) {
    print("Error signing in: $e");
    return null;
  }
}

