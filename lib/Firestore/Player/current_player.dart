import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluter_prjcts/Firestore/Player/player.firestore.dart';
import 'package:fluter_prjcts/Models/player.dart';

class CurrentPlayer {
  static Player? _player;

  static Future<void> init() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _player = await getCurrentPlayer();
    }
  }

  static Player? get player => _player;
}