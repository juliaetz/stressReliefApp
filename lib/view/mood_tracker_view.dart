import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stress_managment_app/model/mood_tracker_model.dart';
import 'package:stress_managment_app/presenter/mood_tracker_presenter.dart';
import 'package:stress_managment_app/view/mood_tracker_chart.dart';


// MOOD OPTIONS
enum MoodType {happy, sad, neutral, angry}


class MoodTrackerView extends StatefulWidget{
  @override
  _MoodTrackerPageState createState() => _MoodTrackerPageState();
}


class _MoodTrackerPageState extends State<MoodTrackerView>{
  final MoodTrackerPresenter _presenter = MoodTrackerPresenter(firestore: FirebaseFirestore.instance);
  
  // START SELECTED MOOD AS NULL
  MoodType? _selectedMood;


  void _saveMood(){
    if(_selectedMood != null){
      // CONVERT ENUM TO A STRING
      String moodString = _selectedMood.toString().split('.').last;
      String timestamp = DateTime.now().toString();

      // SAVE TO DATABASE
      _presenter.saveMood(Mood(mood: moodString, timeStamp: timestamp));
    }
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text("MOOD TRACKER",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
      ),
      body: Column(
        children: [
          Padding( padding: EdgeInsets.all(3.0),
          child: Text(
            "How are you feeling today?",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.deepPurple[600]),
            ),
          ),
          SizedBox(height: 10),   // SPACING

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // HAPPY ICON BUTTON
              GestureDetector(
                onTap: (){
                  setState((){
                    _selectedMood = MoodType.happy;
                  });
                },
                child: 
                Image.asset(
                  'lib/presenter/moodTrack_components/face_icons/happiness.png',
                  width: 70,
                  height: 70,
                  color: _selectedMood == MoodType.happy ? Colors.greenAccent[400] : Colors.grey
                ),
              ),

              SizedBox(width: 20),   // SPACING


              // NEUTRAL ICON BUTTON
              GestureDetector(
                onTap: (){
                  setState((){
                    _selectedMood = MoodType.neutral;
                  });
                },
                child: 
                Image.asset(
                  'lib/presenter/moodTrack_components/face_icons/neutral-face.png',
                  width: 70,
                  height: 70,
                  color: _selectedMood == MoodType.neutral ? Colors.yellow[600] : Colors.grey
                ),
              ),

              SizedBox(width: 20),    // SPACING


              // SAD ICON BUTTON
              GestureDetector(
                onTap: (){
                  setState((){
                    _selectedMood = MoodType.sad;
                  });
                },
                child: 
                Image.asset(
                  'lib/presenter/moodTrack_components/face_icons/sad-face.png',
                  width: 70,
                  height: 70,
                  color: _selectedMood == MoodType.sad ? Colors.cyan[700] : Colors.grey
                ),
              ),

              SizedBox(width: 20),  // SPACING


              // ANGRY ICON BUTTON
              GestureDetector(
                onTap: (){
                  setState((){
                    _selectedMood = MoodType.angry;
                  });
                },
                child: 
                Image.asset(
                  'lib/presenter/moodTrack_components/face_icons/angry.png',
                  width: 75,
                  height: 75,
                  color: _selectedMood == MoodType.angry ? Colors.pink[700] : Colors.grey
                ),
              ),


            ],),

            // SAVES MOOD
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _saveMood,
                child: Text('SAVE THIS SELECTION'),
              ),


              // DISPLAY THE SAVED MOODS
              Expanded(
                child: StreamBuilder(
                  stream: _presenter.getMoods(), 
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator());
                    }
                    if(!snapshot.hasData || snapshot.data!.isEmpty){
                      return Center(child: Text("No moods saved yet!"));
                    }

                    final moods = snapshot.data!;


                    // COUNT THE NUMBER OF TIMES USER CLICKS ON A MOOD
                    int happyCount = 0;
                    int neutralCount = 0;
                    int sadCount = 0;
                    int angryCount = 0;

                    for(var mood in moods){
                      if(mood.mood == 'happy'){
                        happyCount++;
                      } else if (mood.mood == 'neutral'){
                        neutralCount++;
                      } else if (mood.mood == 'sad'){
                        sadCount++;
                      } else if (mood.mood == 'angry'){
                        angryCount++;
                      }
                    }


                    // DISPLAY THE CHART
                    return MoodTrackerChart(
                      happyCount: happyCount, 
                      neutralCount: neutralCount, 
                      sadCount: sadCount, 
                      angryCount: angryCount
                    );
                  }
                )),


        ],)
    );
  }
}