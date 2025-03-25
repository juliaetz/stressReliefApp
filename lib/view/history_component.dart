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
      appBar: AppBar(title: Text('Activity/Mood History')),
      body: Center(
        child: Text('History Page'),
      ),
    );
  }

}