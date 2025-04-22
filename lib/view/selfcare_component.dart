import 'package:flutter/material.dart';
import 'selfcare_view.dart';
import 'package:stress_managment_app/presenter/selfcare_presenter.dart';
import 'homePage_view.dart';
import 'package:table_calendar/table_calendar.dart';


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

  // view variables
  int _selectedIndex = 0;
  String _filterValue = "No Filter";
  Widget _page = HomePage(); // home page stays rendered until the self care page is ready to display
  String _currentIdea = "Loading...";
  bool _isLoading = true;
  IconData _heart = Icons.favorite_border;
  List<String> _favorites = [];
  final controller = TextEditingController();

  // BEGINNING OF UPDATES HANDLED BY PRESENTER
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

  void handleRemoveFavorite(String? idea){
    this.widget.presenter.removeFavorite(idea!);
  }

  void handleUserFavorite(String? idea){
    this.widget.presenter.makeUserFavorite(idea!);
  }

  void handleScheduledIdea(String? idea, DateTime? date, TimeOfDay? time){
    this.widget.presenter.scheduleIdea(idea!, date!, time!);
  }
  // END OF UPDATES HANDLED BY PRESENTER

  // presenter updates view variables
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
    return Scaffold(
      // only load the app bar if the first idea is generated
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

      // only load the nav bar if the first idea is generated
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



  // BEGINNING OF UI ELEMENTS FOR THE IDEAS PAGE
  @override
  Container IdeasPage(){
    return Container(
      width: double.infinity,
      decoration: addBackground(),


      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          createFilterDropdown(),

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

  DropdownButton<String> createFilterDropdown() {
    return DropdownButton<String>(
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
        });
        },
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
          },
          child: Text('Next', style: TextStyle(fontSize: 18.0)),
        )
      ],
    );
  }
  // END OF UI ELEMENTS FOR THE IDEAS PAGE



  // BEGINNING OF UI ELEMENTS FOR THE FAVORITES PAGE
  @override
  Container FavoritesPage(){
    return Container(
      width: double.infinity,
      decoration: addBackground(),

      child: Container(
        child: Column(
          children: [
            createFavorites(),
            Align(
              alignment: Alignment.bottomCenter,
              child: createUserIdeaInput(),
            ),
          ],
        ),
      ),
    );
  }

  Expanded createFavorites() {
    return Expanded(
      flex: 9,
      child: SingleChildScrollView(
        child: Column(
          children: createFavoritesRows(),
        ),
      ),
    );
  }

  List<Widget> createFavoritesRows() {
    return List.generate(_favorites.length, (index) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.all(10.0)),
          Flexible(
            fit: FlexFit.tight,
            flex: 8,
            child: Text(_favorites[index], style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () async {
                    TimeOfDay? scheduledTime;
                    DateTime? scheduledDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2100),
                    );
                    if(scheduledDate != null) {
                      scheduledTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                    }
                    if(scheduledTime != null){
                      handleScheduledIdea(_favorites[index], scheduledDate, scheduledTime);
                    }
                  },
                  icon: Icon(Icons.calendar_month, color: Colors.deepPurple.shade700, size: 30.0,),
              ),
              IconButton(
                onPressed: (){
                  handleRemoveFavorite(_favorites[index]);
                  },
                icon: Icon(Icons.delete, color: Colors.deepPurple.shade700, size: 30.0,),
              ),
            ],
          ),
        ],
      );
    });
  }

  TextField createUserIdeaInput() {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Add your own favorite idea!',
        labelStyle: TextStyle(fontSize: 25.0, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      style: TextStyle(fontSize: 25.0, color: Colors.black),
      onSubmitted: (String value) async {
        handleUserFavorite(value);
        controller.clear();
      },
    );
  }
  // END OF UI ELEMENTS FOR FAVORITES PAGE



  // BEGINNING OF MISC UI ELEMENTS
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