import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addAnswer(String questionId, String content, bool isCorrect) async{
  try {
    await FirebaseFirestore.instance.collection("answers").add({
      'questionId' : questionId,
      'content' : content,
      'isCorrect': isCorrect,
    });
  } on FirebaseException catch(e) {
    print(e.message);
  }
}