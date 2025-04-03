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
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/purple_background.jpg"),
            fit: BoxFit.fill,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildIdeaCard(),
            SizedBox(height: 5.0),
            buildButtonRow()
          ],
        ),
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
                icon: Icon(Icons.lightbulb),
                label: 'Ideas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
      ),
    );
  }

  Row buildButtonRow() {
    return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.favorite, size: 20.0,),
                  label: Text('Love', style: TextStyle(fontSize: 18.0)),
              ),
              SizedBox(width: 10.0),
              ElevatedButton(
                  onPressed: (){},
                  child: Text('Next', style: TextStyle(fontSize: 18.0)),
              )
            ],
          );
  }

  Card buildIdeaCard() {
    return Card(
              color: Colors.deepPurple.shade700,
              margin: EdgeInsets.only(left: 40.0, right: 40.0),
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                      'RANDOM SELF CARE IDEA HERE',
                      style: TextStyle(fontSize: 25.0, color: Colors.white,),
                      textAlign: TextAlign.center,
                  )
              )
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