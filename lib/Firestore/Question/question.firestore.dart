import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addQuestion(String topicId, String title, String description) async{
  try {
    await FirebaseFirestore.instance.collection("questions").add({
      'topicId' : topicId,
      'title' : title,
      'description': description,
    });
  } on FirebaseException catch(e) {
    print(e.message);
  }
}

Future<List<Map<String, dynamic>>> getAnswers(String questionId) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('answers')
      .where('questionId', isEqualTo: questionId)
      .get();

  return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}
