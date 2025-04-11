import 'package:cloud_firestore/cloud_firestore.dart';

Future<int> getStreak(String playerId) async {
    final now = DateTime.now().toUtc();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("streaks")
        .where("playerId", isEqualTo: playerId)
        .get();


    if(snapshot.docs.isEmpty) {
      await FirebaseFirestore.instance.collection("streaks").add({
        "playerId" : playerId,
        "currentStreak" : 0,
        "longestStreak" : 0,
        "lastLogin" : now.toIso8601String()
      });

      return 0;
    }

    final playerStreakDoc = snapshot.docs.first;
    final data = playerStreakDoc.data() as Map<String, dynamic>;
    final lastLogin = DateTime.parse(data['lastLogin'] ?? now);
    final hoursDifference = now.difference(lastLogin).inHours;

    int currentStreak = data['currentStreak'] ?? 0;
    int longestStreak = data['longestStreak'] ?? 0;

    //If today then return the current
    if(hoursDifference < 24) return currentStreak;

    //If within 1 day current + 1 else 0
    if(hoursDifference < 48) {
      currentStreak++;
    } else {
      currentStreak = 0;
    }

    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }

    await playerStreakDoc.reference.update({
      'lastLogin' : now.toIso8601String(),
      "currentStreak" : currentStreak,
      "longestStreak" : longestStreak,
    });

    return currentStreak;
}