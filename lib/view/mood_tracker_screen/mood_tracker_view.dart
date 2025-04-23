import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stress_managment_app/model/mood_tracker_model.dart';
import 'package:stress_managment_app/presenter/journal_presenter.dart';
import 'package:stress_managment_app/presenter/mood_tracker_presenter.dart';
import 'package:stress_managment_app/view/homePage_view.dart';
import 'package:stress_managment_app/view/journal_view.dart';
import 'package:stress_managment_app/view/mood_tracker_screen/mood_tracker_chart.dart';
import '../../presenter/history_presenter.dart';
import '../history_component.dart';


// MOOD OPTIONS
enum MoodType {happy, neutral, sad, angry}


class MoodTrackerView extends StatefulWidget{
  @override
  _MoodTrackerPageState createState() => _MoodTrackerPageState();
}


class _MoodTrackerPageState extends State<MoodTrackerView>{
  final MoodTrackerPresenter _presenter = MoodTrackerPresenter();


  // START SELECTED MOOD AS NULL
  MoodType? _selectedMood;


  // CLEAR ALL MOODS
  void _clearSelection(){
    setState((){
      _selectedMood = null;
    });
  }


  // CONFIRMATION TO DELETE ALL MOODS
  void _showConfirmDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("CONFIRM DELETION"),
          content: Text("Are you sure you would like to delete ALL mood data? This action CANNOT be undone!"),
          actions: [
            TextButton(
              onPressed: (){
                // CANCEL BUTTON
                Navigator.of(context).pop();
              },
              child: Text("CANCEL"),
            ),
            TextButton(
              onPressed: () async{
                // DELETE ALL MOODS AND CLOSE DIALOG BOX
                Navigator.of(context).pop();
                await _clearMoodData();
              },
              child: Text("DELETE ALL")
            ),
          ],);
      });
  }

  // CLEAR MOOD DATA FROM FIRESTORE DATABASE
  Future<void> _clearMoodData() async{
    await _presenter.clearAllMoods();
    // BAR TO NOTIFY ALL MOOD ENTRIES ARE DELETED
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("All mood entries have been cleared!")),
    );
  }




  // SAVE MOODS TO DATABASE
  void _saveMood(){
    if(_selectedMood != null){
      // CONVERT ENUM TO A STRING
      String moodString = _selectedMood.toString().split('.').last;
      String timestamp = DateTime.now().toString();

      _presenter.saveMood(Mood(mood: moodString, date: timestamp));
    }
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: buildHomeButton(),
        backgroundColor: Colors.deepPurple[200],
        title: Text("Mood Tracker"),
      ),
      body: Column(
        children: [

          // TEXT "HOW ARE YOU FEELING TODAY?"
          Padding( padding: EdgeInsets.all(3.0),
          child: Text(
            "How are you feeling today?",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.deepPurple[600]),
            ),
          ),
          SizedBox(height: 10),


          // MOOD ICONS ROW -- FACE BUTTONS
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
                  'lib/view/mood_tracker_screen/face_icons/happiness.png',
                  width: 70,
                  height: 70,
                  color: _selectedMood == MoodType.happy ? Colors.greenAccent[400] : Colors.black
                ),
              ),
              SizedBox(width: 15),


              // NEUTRAL ICON BUTTON
              GestureDetector(
                onTap: (){
                  setState((){
                    _selectedMood = MoodType.neutral;
                  });
                },
                child: 
                Image.asset(
                  'lib/view/mood_tracker_screen/face_icons/neutral-face.png',
                  width: 70,
                  height: 70,
                  color: _selectedMood == MoodType.neutral ? Colors.yellow[600] : Colors.black
                ),
              ),
              SizedBox(width: 15),


              // SAD ICON BUTTON
              GestureDetector(
                onTap: (){
                  setState((){
                    _selectedMood = MoodType.sad;
                  });
                },
                child: 
                Image.asset(
                  'lib/view/mood_tracker_screen/face_icons/sad-face.png',
                  width: 70,
                  height: 70,
                  color: _selectedMood == MoodType.sad ? Colors.cyan[700] : Colors.black
                ),
              ),
              SizedBox(width: 15),


              // ANGRY ICON BUTTON
              GestureDetector(
                onTap: (){
                  setState((){
                    _selectedMood = MoodType.angry;
                  });
                },
                child: 
                Image.asset(
                  'lib/view/mood_tracker_screen/face_icons/angry.png',
                  width: 77,
                  height: 77,
                  color: _selectedMood == MoodType.angry ? Colors.pink[700] : Colors.black
                ),
              ),
            ],
          ),


          // SAVES MOOD
          SizedBox(height: 15),
            ElevatedButton(
              onPressed: _saveMood,
              child: Text('SAVE THIS SELECTION', style: TextStyle(fontSize: 17, color: Colors.deepPurple[700])),
            ),
            SizedBox(height: 20),




          // ADDITIONAL BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [


              // BUTTON TO NAVIGATE TO JOURNAL PAGE (WILL ADD WHEN IT'S READY!)
              ElevatedButton.icon(
                icon: Icon(Icons.book_outlined, color: Colors.deepPurpleAccent[700], size: 25),
                label: Text("JOURNAL!", style: TextStyle(fontSize: 12)),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder:(context) => JournalView(presenter: JournalPresenter(),),)
                  );
                }
              ),
              SizedBox(width: 10),
              
              
              // BUTTON TO CLEAR ALL MOOD DATA
              ElevatedButton.icon(
              onPressed: _showConfirmDialog, 
              icon: Icon(Icons.delete_forever, color: Colors.red[700], size: 25),
              label: Text("CLEAR MOOD DATA", style: TextStyle(fontSize: 12)),
              ),
              

            ],
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
                return Center(child: Text("THERE'S NOTHING HERE..."));
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
          )
        ),
        SizedBox(height: 30),


        // BUTTON TO NAVIGATE TO MOOD HISTORY PAGE
        ElevatedButton.icon(
          onPressed: (){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HistoryPage(BasicHistoryPresenter(), title:'HISTORY',key: const Key('HISTORY')))
            );
          },
          icon: Icon(Icons.face_retouching_natural_sharp, color: Colors.indigo[600], size: 25),
          label: Text("VIEW YOUR HISTORY!", style: TextStyle(fontSize: 13)),
        ),
        SizedBox(height: 100),

        ],
      ),
    );
  }

  FilledButton buildHomeButton() {
    return FilledButton(
      // HOME BUTTON TO RETURN TO HOME PAGE
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder:(context) => HomePage(),)
        );
      },

      child: Icon(Icons.house, color:Colors.white),
      style: FilledButton.styleFrom(
        shape: CircleBorder(side: BorderSide(color: Colors.deepPurple.shade200, width: 8)),
        padding: EdgeInsets.all(5),
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.deepPurple.shade700,
      ),
    );


  }
}