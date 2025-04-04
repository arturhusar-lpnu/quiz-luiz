import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addTopic(String title, String description) async{
  try {
    await FirebaseFirestore.instance.collection("topics").add({
      'title' : title,
      'description': description,
    });
  } on FirebaseException catch(e) {
    print(e.message);
  }
}

Future<List<Map<String, dynamic>>> getTopics() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('topics').get();

  return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}

Future<List<Map<String, dynamic>>> getQuestions(String topicId) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('questions')
      .where('topicId', isEqualTo: topicId)
      .get();

  return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}

Future<void> updateTopic(String topicId, String? title, String? description) async {
  try {
    final topicRef = FirebaseFirestore.instance.collection("topics").doc(topicId);

    var topicSnapshot = await topicRef.get();
    if(!topicSnapshot.exists) {
      throw Exception("Error: Topic with ID $topicId does not exist.");
    }

    Map<String, dynamic> updateQuery = {};

    if (title != null) {
      updateQuery["title"] = title;
    }

    if (description != null) {
      updateQuery["description"] = description;
    }

    if(updateQuery.isNotEmpty) {
      await topicRef.update(updateQuery);
    }
  } catch(e) {
    print(e);
  }
}
