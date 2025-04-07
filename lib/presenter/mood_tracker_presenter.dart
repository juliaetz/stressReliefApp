import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stress_managment_app/model/mood_tracker_model.dart';

class MoodTrackerPresenter {
  final FirebaseFirestore firestore;

  MoodTrackerPresenter({required this.firestore});

  // SAVE MOOD TO DATABASE
  Future<void> saveMood(Mood mood) async{
    await firestore.collection('Mood').add(mood.toMap());
  }

  // GET ALL MOOD DATA FROM FIRESTORE
  Stream<List<Mood>> getMoods(){
    return firestore.collection('Mood').snapshots().map((snapshot){
      return snapshot.docs
        .map((doc)=>Mood.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  // CLEAR ALL MOODS
  Future<void> clearAllMoods() async{
    var querySnapshot = await firestore.collection('Mood').get();
    for(var doc in querySnapshot.docs){
      await doc.reference.delete();
    }
  }


}