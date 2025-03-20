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
        child: Center(
            child: Text("History Page"),
        ), /* add child content here */
      ),
    );
  }

}