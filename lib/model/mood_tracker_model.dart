class Mood {
  final String mood;
  final String timeStamp;

  Mood({required this.mood, required this.timeStamp});


  // CONVERT MOOD OBJECT INTO MAP FOR DATABASE
  Map<String, dynamic> toMap(){
    return{
      'mood': mood,
      'timestamp': timeStamp,
    };
  }


  // CREATE MOOD OBJECT FROM DATABASE
  factory Mood.fromMap(Map<String, dynamic> map){
    return Mood(
      mood: map['mood']??'',
      timeStamp: map['timestamp']??'',
    );
  }
}