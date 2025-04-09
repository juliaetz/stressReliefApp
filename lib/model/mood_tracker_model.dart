class Mood {
  final String mood;
  final String date;

  Mood({required this.mood, required this.date});


  // CONVERT MOOD OBJECT INTO MAP FOR DATABASE
  Map<String, dynamic> toMap(){
    return{
      'mood': mood,
      'date': date,
    };
  }


  // CREATE MOOD OBJECT FROM DATABASE
  factory Mood.fromMap(Map<String, dynamic> map){
    return Mood(
      mood: map['mood']??'',
      date: map['date']??'',
    );
  }
}