import 'package:flutter/material.dart';
import 'history_view.dart';
import 'package:stress_managment_app/presenter/history_presenter.dart';
import 'homePage_view.dart';


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
  int _selectedIndex = 0;
  Widget _page = Placeholder();
  bool _onMoodTracker = false;

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
    void updateOnMoodTracker(bool value){
      setState(() {
        _onMoodTracker = value;
      });
    }



  @override
  Widget build(BuildContext Context) {
    return Scaffold(
      appBar: _onMoodTracker ? null:AppBar(
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
            icon: Icon(Icons.pie_chart),
            label: 'Mood Graph'
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (int index){
          setState(() {
            handlePageChange(index);
          });
        },
      ),
    );
  }

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

  @override
  Container ActivityGraph(){
    return Container(
      width: double.infinity,
      decoration: addBackground(),

      child: Column(
        children: [
          Text('this will be the graph'),
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

      /*
        // RETURNS TO PREVIOUS PAGE
        onPressed: () {
          Navigator.pop(context);
        },
       */

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

  BoxDecoration addBackground() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/purple_background.jpg"),
        fit: BoxFit.fill,
      ),
    );
  }

}