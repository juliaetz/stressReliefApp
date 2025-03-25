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
  }

  String _dropdownValue = 'Activity History';
  String _history = "";

  @override
  void updateHistory(String option){
    if(option == 'Activity History'){
      _history = 'This will give your daily activity history';
    } else if (option == 'Mood History'){
      _history = 'This will give your daily mood history';
    }
  }


  @override
  Widget build(BuildContext Context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: FilledButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.house, color:Colors.white),
          style: FilledButton.styleFrom(
            shape: CircleBorder(side: BorderSide(color: Colors.white, width: 8)),
            padding: EdgeInsets.all(5),
            backgroundColor: Colors.amber,
            foregroundColor: Colors.amber,
          ),
        ),
        title: Text('Daily Activity and Mood History'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/history_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            historySelectionRow(),
            Padding(padding: EdgeInsets.all(10)),
            Container(
              child: Text(_history),
            )
          ],
        )
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
                underline: Container(height: 2, color: Colors.amber),
                items: <String>['Activity History', 'Mood History'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _dropdownValue = newValue!;
                    updateHistory(newValue);
                  });
                },
              ),
            ],
          );
  }

}