import 'package:flutter/material.dart';
import 'history_view.dart';
import 'package:stress_managment_app/presenter/history_presenter.dart';


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

    //DELETE THIS BEFORE MERGE: TEST FUNCTION CALL
    fetchEventCounts();
  }

  //DELETE THIS BEFORE MERGE: TEST FUNCTION
  void fetchEventCounts() async {
    // Call the function that gets the event counts and logs them to the console
    Map<String, int> eventCounts = await widget.presenter.getEventCountsByDay();
    print("Event Counts: $eventCounts");
  }

  String _dropdownValue = 'Activity History';
  String _history = "";
  List<Widget> _entries = [];


  //DELETE THIS BEF0RE MERGE: TEST FUNCTION
  @override
  void showEventCounts(Map<String, int> dayCounts) {
    // Log the event counts to the console
    print("Event Counts by Day:");
    dayCounts.forEach((day, count) {
      print('$day: $count');
    });
  }

  void handleHistoryValueChanged(String? value){
    this.widget.presenter.onOptionChanged(value!);
  }

  void updateScreen(){
    this.widget.presenter.updateScreen();
  }

  @override
  void updateHistory(String value){
      setState(() {
        _history = "This is the $value page";
      });
    }

    @override
    void updateEntries(List<Widget> entries){
      setState(() {
        _entries = entries;
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/purple_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),

        child: Column(
          children: [
            historySelectionRow(),
            Padding(padding: EdgeInsets.all(10)),
            buildHistoryScrollable(),
          ],
        ),
      ),
    );
  }

  FilledButton buildHomeButton() {
    return FilledButton(
        onPressed: () {
          Navigator.pop(context);
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

  Row historySelectionRow() {
    return Row(
            //child: Text("History Page"),
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

}