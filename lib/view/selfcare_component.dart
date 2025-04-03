import 'package:flutter/material.dart';
import 'selfcare_view.dart';
import 'package:stress_managment_app/presenter/selfcare_presenter.dart';


class SelfcarePage extends StatefulWidget {
  final SelfcarePresenter presenter;

  SelfcarePage(this.presenter, {required Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _SelfcarePageState createState() => _SelfcarePageState();
}



class _SelfcarePageState extends State<SelfcarePage> implements SelfcareView {
  @override
  void initState() {
    super.initState();
    //this.widget.presenter.selfcareView = this;
  }


  @override
  Widget build(BuildContext Context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: buildHomeButton(),
        title: Text('Selfcare Ideas'),
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
            Text("this is the self care idea page"),
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

}