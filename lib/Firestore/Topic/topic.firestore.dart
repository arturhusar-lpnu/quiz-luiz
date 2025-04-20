import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Models/question.dart';
import 'package:fluter_prjcts/Models/topic.dart';

Future<String> addTopic(String title, String description) async{
  try {
    DocumentReference docRef = await FirebaseFirestore.instance.collection("topics").add({
      'title' : title,
      'description': description,
    });
    return docRef.id;
  } catch(e) {
    throw Exception("Api fail: could not add new topic");
  }
}

Future<Topic> getTopic(String topicId) async {
  var snapshot = await FirebaseFirestore.instance.collection('topics').doc(topicId).get();
  return Topic.fromFirestore(snapshot);
}

Future<List<Topic>> getAllTopics() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('topics').get();
  return snapshot.docs.map((doc) => Topic.fromFirestore(doc)).toList();
}

Future<List<Question>> getTopicQuestions(String topicId) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('questions')
      .where('topicId', isEqualTo: topicId)
      .get();

  return snapshot.docs.map((doc) => Question.fromFirestore(doc)).toList();
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
    throw Exception("API Error: $e");
  }
}

Future<List<Topic>> getSolvedTopics(String playerId) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('solved-topics')
      .where('playerId', isEqualTo: playerId)
      .get();
  if(snapshot.docs.isEmpty) return [];
  List<Topic> topics = [];

  for(final doc in snapshot.docs) {
    final topicId = doc["topicId"];
    topics.add(await getTopic(topicId));
  }
  return topics;
}

Future<List<Topic>> getUnsolvedTopics(String playerId) async {
  final allTopics = await getAllTopics();
  final solved = await getSolvedTopics(playerId);

  final solvedIds = solved.map((t) => t.id).toSet();

  return allTopics.where((topic) => !solvedIds.contains(topic.id)).toList();
}

Future<void> addSolvedTopics(String playerId, List<String> topicIds) async {
  for(final topicId in topicIds) {
    await FirebaseFirestore.instance
        .collection('solved-topics')
        .add({
      "playerId" : playerId,
      "topicId" : topicId
    });
  }
}