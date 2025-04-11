import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addAnswer(String questionId, String content, bool isCorrect) async{
  try {
    await FirebaseFirestore.instance.collection("answers").add({
      'questionId' : questionId,
      'content' : content,
      'isCorrect': isCorrect,
    });
  } catch(e) {
    throw Exception('Api Error: $e');
  }
}

Future<void> updateAnswer(String answerId, {String? content, bool? isCorrect}) async{
  try {
    var answerRef = FirebaseFirestore.instance.collection("answers").doc(answerId);

    var answerSnapshot = await answerRef.get();
    if(!answerSnapshot.exists) {
      throw Exception("Error: Answer with ID $answerId does not exist.");
    }

    Map<String, dynamic> updates = {};

    if (content != null) updates["content"] = content;
    if (isCorrect != null) updates["isCorrect"] = isCorrect;

    if(updates.isNotEmpty) {
      await answerRef.update(updates);
    }
  } catch(e) {
    throw(Exception("API Error updating answer"));
  }
}