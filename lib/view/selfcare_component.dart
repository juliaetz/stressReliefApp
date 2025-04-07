import 'package:flutter/material.dart';
import 'selfcare_view.dart';
import 'package:stress_managment_app/presenter/selfcare_presenter.dart';
import 'homePage_view.dart';


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
    this.widget.presenter.selfcareView = this;
  }

  int _selectedIndex = 0;
  String _filterValue = "No Filter";
  Widget _page = HomePage();
  String _currentIdea = "Loading...";
  bool _isLoading = true;
  IconData _heart = Icons.favorite_border;
  List<String> _favorites = [];

  void handlePageChange(int index){
    this.widget.presenter.updatePage(index);
  }

  void handleNext(){
    this.widget.presenter.updateCurrentIdea();
  }

  void handleFavorite(){
    this.widget.presenter.updateFavoritesList();
  }

  void handleFilterValueChanged(String? newValue){
    this.widget.presenter.updateFilter(newValue!);
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
      _isLoading = false;
    });
  }

  @override
  void updateIdea(String idea){
    setState(() {
      _currentIdea = idea;
    });
  }

  @override
  void updateFilter(String filter) {
    setState(() {
      _filterValue = filter;
    });
  }

  @override
  void updateHeartIcon(IconData icon){
    setState(() {
      _heart = icon;
    });
  }

  @override
  void updateFavorites(List<String> faves){
    setState(() {
      _favorites = faves;
    });
  }
  

  @override
  Widget build(BuildContext Context) {
    //Widget page;
    return Scaffold(
      appBar: _isLoading ? null : AppBar(
        toolbarHeight: 80,
        leading: buildHomeButton(),
        title: Text('Selfcare Ideas'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade200,
      ),


      body: Center(
        child: _page,
      ),


      bottomNavigationBar: _isLoading ? null : BottomNavigationBar(
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
        currentIndex: _selectedIndex,
        onTap: (int index){
          setState(() {
            handlePageChange(index);
          });
        },
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



  @override
  Container IdeasPage(){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/purple_background.jpg"),
          fit: BoxFit.fill,
        ),
      ),


      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          DropdownButton<String>(
            value: _filterValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            underline: Container(height: 2, color: Colors.deepPurple.shade700),
            items: <String>['No Filter', 'Physical', 'Mental', 'Emotional', 'Social'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _filterValue = newValue!;
                handleFilterValueChanged(newValue);
                //updateScreen();
              });
            },
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildIdeaCard(),
                SizedBox(height: 5.0),
                buildButtonRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Card buildIdeaCard() {
    return Card(
        color: Colors.deepPurple.shade700,
        margin: EdgeInsets.only(left: 40.0, right: 40.0),
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              _currentIdea,
              //'RANDOM SELF CARE IDEA HERE',
              style: TextStyle(fontSize: 25.0, color: Colors.white,),
              textAlign: TextAlign.center,
            )
        )
    );
  }

  Row buildButtonRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            handleFavorite();
          },
          icon: Icon(_heart, size: 20.0,),
          label: Text('Love', style: TextStyle(fontSize: 18.0)),
        ),
        SizedBox(width: 10.0),
        ElevatedButton(
          onPressed: (){
              handleNext();
              //handlePageChange(_selectedIndex);
          },
          child: Text('Next', style: TextStyle(fontSize: 18.0)),
        )
      ],
    );
  }

  @override
  Container FavoritesPage(){
    return Container(
      child: Column(
        children: [
          for(String faveIdea in _favorites)
            Text(faveIdea),
        ]
      )
    );
  }

}