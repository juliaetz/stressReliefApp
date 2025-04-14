import 'package:flutter/material.dart';
import 'package:stress_managment_app/view/mood_tracker_screen/mood_history_summary.dart';
import 'package:stress_managment_app/view/mood_tracker_screen/mood_tracker_view.dart';
import 'history_view.dart';
import 'package:stress_managment_app/presenter/history_presenter.dart';
import 'homePage_view.dart';
import 'package:fl_chart/fl_chart.dart';

class HistoryPage extends StatefulWidget {
  final HistoryPresenter presenter;

  HistoryPage(this.presenter, {required Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HistoryPageState createState() => _HistoryPageState();
}



class _HistoryPageState extends State<HistoryPage> implements HistoryView {
  @override
  void initState() {
    super.initState();
    this.widget.presenter.historyView = this;

  }

  //DELETE THIS BEFORE FINAL MERGE: TEST FUNCTION
  void fetchEventCounts() async {
    // Call the function that gets the event counts and logs them to the console
    Map<String, int> eventCounts = await widget.presenter.getEventCountsByDay();
    print("Event Counts: $eventCounts");
  }

  String _dropdownValue = 'Activity History';
  List<Widget> _entries = [];
  int _selectedIndex = 0;
  Widget _page = Placeholder();



  void handleHistoryValueChanged(String? value){
    this.widget.presenter.onOptionChanged(value!);
  }

  void updateScreen(){
    this.widget.presenter.updateScreen();
  }

  void handlePageChange(int index){
    this.widget.presenter.updatePage(index);
  }


  @override
  void updateEntries(List<Widget> entries){
    setState(() {
      _entries = entries;
    });
  }

  @override
  void updateSelectedIndex(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

    @override
    void updatePage(Widget page){
      setState(() {
        _page = page;
      });
    }


  @override
  Widget build(BuildContext Context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: buildHomeButton(),
        title: Text('Daily Activity and Mood History'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade200,
      ),

      body: Center(
        child: _page,
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple.shade700,
        iconSize: 30.0,

        selectedIconTheme: IconThemeData(color: Colors.white),
        selectedFontSize: 23.0,
        selectedItemColor: Colors.white,

        unselectedIconTheme: IconThemeData(color: Colors.deepPurple.shade200),
        unselectedFontSize: 18.0,
        unselectedItemColor: Colors.white,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Activity Graph',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Mood Graph'
          )
        ],

        currentIndex: _selectedIndex,
        onTap: (int index){
          setState(() {
            handlePageChange(index);


            if(_selectedIndex == 2){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder:(context) => MoodHistorySummary(),)
              );
            }


          });
        },
      ),
    );
  }

  // START OF FUNCTIONS RELATED TO HISTORY VIEW
  @override
  Container DailyHistoryPage(){
    return Container(
      width: double.infinity,
      decoration: addBackground(),

      child: Column(
        children: [
          historySelectionRow(),
          Padding(padding: EdgeInsets.all(10)),
          buildHistoryScrollable(),
        ],
      ),
    );
  }

  Row historySelectionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.all(8)),
        Text('Daily History:  ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        DropdownButton<String>(
          value: _dropdownValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          underline: Container(height: 2, color: Colors.deepPurple.shade700),
          items: <String>['Activity History', 'Mood History'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _dropdownValue = newValue!;
              handleHistoryValueChanged(newValue);
              updateScreen();
            });
          },
        ),
      ],
    );
  }


  Expanded buildHistoryScrollable() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: _entries,
        ),
      ),
    );
  }
  // END OF FUNCTIONS RELATED TO HISTORY VIEW


  // ACTIVITY GRAPH VIEW
  //going to need to call the getEventsByCoutns() for the map<string, int>
  @override
  Widget ActivityGraph(){
    fetchEventCounts();
    return FutureBuilder<Map<String, int>>(
      future: widget.presenter.getEventCountsByDay(),
      builder: (context, snapshot){
        if (!snapshot.hasData) {
          return const Center(child:  CircularProgressIndicator());
        }
        final data = snapshot.data!;
        final spots = <FlSpot>[];
        int index = 0;

        for (var value in data.values) {
          spots.add(FlSpot(index.toDouble(), value.toDouble()));
          index++;
      }
        return SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.deepPurpleAccent,
                )
              ],
              titlesData: FlTitlesData(show: true),
              borderData: FlBorderData(show: true),
              gridData: FlGridData(show: true)
            )
          ),
        );
    });

  }

  // START OF MISC UI ELEMENTS
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

  BoxDecoration addBackground() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/purple_background.jpg"),
        fit: BoxFit.fill,
      ),
    );
  }
  // END OF MISC UI ELEMENTS


}