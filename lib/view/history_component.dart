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
  List<Widget> _entries = [];

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
          shape: CircleBorder(side: BorderSide(color: Colors.white, width: 8)),
          padding: EdgeInsets.all(5),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.amber,
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