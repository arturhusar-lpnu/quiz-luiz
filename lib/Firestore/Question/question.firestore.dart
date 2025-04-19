import 'package:cloud_firestore/cloud_firestore.dart';
import "package:fluter_prjcts/Models/answer.dart";

import '../../Models/question.dart';

Future<String> addQuestion(String topicId, String content) async{
  try {
    var docRef = await FirebaseFirestore.instance.collection("questions").add({
      'topicId' : topicId,
      'content' : content,
    });
    return docRef.id;
  } catch(e) {
    throw Exception("Api fail: could not add question");
  }
}

Future<List<Answer>> getAnswers(String questionId) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('answers')
      .where('questionId', isEqualTo: questionId)
      .get();

  return snapshot.docs.map((doc) => Answer.fromFirestore(doc)).toList();
}

Future<Question> getQuestion(String id) async{
  try {
    var docRef = await FirebaseFirestore.instance
        .collection("questions")
        .doc(id).get();

    return Question.fromFirestore(docRef);
  } catch (e) {
    rethrow;
  }
}