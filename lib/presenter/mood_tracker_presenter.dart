import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stress_managment_app/model/mood_tracker_model.dart';
import 'package:stress_managment_app/firebase_logic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MoodTrackerPresenter {

  late CollectionReference moodCollection;

  Future<void> initilizeUserMoodCollection() async {
    final userDocRef = await getUserDocument();
    moodCollection = userDocRef.collection('Mood');
  }
  MoodTrackerPresenter();

  // SAVE MOOD TO DATABASE
  Future<void> saveMood(Mood mood) async{
    await moodCollection.add(mood.toMap());
  }

  // GET ALL MOOD DATA FROM FIRESTORE
  Stream<List<Mood>> getMoods() async*{
    await initilizeUserMoodCollection();
    yield* moodCollection.snapshots().map((snapshot){
      return snapshot.docs
          .map((doc) => Mood.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // CLEAR ALL MOODS
  Future<void> clearAllMoods() async{
    var querySnapshot = await moodCollection.get();
    for(var doc in querySnapshot.docs){
      await doc.reference.delete();
    }
  }

}