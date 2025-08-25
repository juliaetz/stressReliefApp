import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stress_managment_app/model/selfcare_model.dart';
import 'package:stress_managment_app/view/selfcare_component.dart';
import 'package:stress_managment_app/view/selfcare_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class SelfcarePresenter {
  void updatePage(int index){}
  void updateCurrentIdea(){}
  void updateFilter(String value){}
  void updateFavoritesList(){}
  void removeFavorite(String idea){}
  void makeUserFavorite(String idea){}
  void scheduleIdea(String idea, DateTime date, TimeOfDay time){}
  set selfcareView(SelfcareView value){}
}

class BasicSelfcarePresenter extends SelfcarePresenter{
  late SelfcareModel _viewModel;
  late SelfcareView _view;

  BasicSelfcarePresenter() {
    this._viewModel = SelfcareModel();
    updateDatabase();
    _loadInitial();
  }

  // loads some of the initial values for view in the model (page index, filter view, etc)
  void _loadInitial() async {
    _viewModel.pageIndex = 0;
    _viewModel.filterType = "No Filter";
    _viewModel.heartIcon = Icons.favorite_border;
  }


  @override
  set selfcareView(SelfcareView value) {
    _view = value;
    initializeIdea(); // page waits to render until the first page is loaded
  }

  // loads the database, favorite ideas from previous uses, first random idea, and ideas page
  void initializeIdea() async {
    await updateDatabase(); // Wait for ideas to load
    await createFavorites();
    _view.updateFavorites(_viewModel.favoritesList);
    _viewModel.pageIndex = 0;

    int initialIdeaIndex = getRandomIndex();
    _viewModel.currentIdeaIndex = initialIdeaIndex;

    String idea = _viewModel.ideasList[initialIdeaIndex].get("Idea");
    _view.updateIdea(idea);

    _view.updateSelectedIndex(_viewModel.pageIndex);
    updatePage(_viewModel.pageIndex);
  }

  // initializes a list of favorite ideas based on what the user has added in previous uses
  Future<void> createFavorites() async {
    final QuerySnapshot snapshot = await _viewModel.favoritesDatabaseReference.get();
    final List<DocumentSnapshot> documents = snapshot.docs;
    documents.forEach((document) {
      _viewModel.favoritesList.add(document.get("Idea"));
    });
  }


  @override
  void updatePage(int index){
    if(index != _viewModel.pageIndex){
      _viewModel.pageIndex = index;
      _view.updateSelectedIndex(_viewModel.pageIndex);
    }

    Widget page;
    if(_viewModel.pageIndex == 0){
      page = _view.IdeasPage();
    } else {
      page = _view.FavoritesPage();
    }

    _view.updatePage(page);
  }


  // METHODS USED TO GENERATE NEW SELF CARE IDEAS
  // if the next button is hit, update the view idea
  @override
  Future<void> updateCurrentIdea()async{
    // update the available self care ideas to choose from if elements have been
    // favorited, filters changed, or there are no ideas
    if(_viewModel.ideasList.length != _viewModel.databaseSize || _viewModel.filterType != "No Filter" || _viewModel.ideasList.length == 0){
      await updateDatabase();
    }
    if(_viewModel.heartIcon != Icons.favorite_border){
      _viewModel.heartIcon = Icons.favorite_border;
      _view.updateHeartIcon(_viewModel.heartIcon);
    }

    String idea;
    // generate a random idea if there are ideas to be generated
    if(_viewModel.ideasList.isEmpty){
      idea = "No more ideas under this filter";
    } else {
      int newIdeaIndex = getRandomIndex();
      _viewModel.currentIdeaIndex = newIdeaIndex;
      idea = _viewModel.ideasList.elementAt(newIdeaIndex).get("Idea");
      _viewModel.currentIdea = idea;
    }

    // update view
    _view.updateIdea(idea);
    updatePage(_viewModel.pageIndex);
  }

  Future<void> updateDatabase()async{
    final QuerySnapshot snapshot;
    if(_viewModel.filterType != "No Filter"){
      snapshot = await _viewModel.ideasDatabaseReference.where("Filter", isEqualTo: _viewModel.filterType).get();
    } else {
      snapshot = await _viewModel.ideasDatabaseReference.get();
    }
    _viewModel.ideasList = snapshot.docs;
    _viewModel.databaseSize = _viewModel.ideasList.length;
  }

  int getRandomIndex(){
    Random random = new Random();
    int randomNumber = random.nextInt(_viewModel.ideasList.length);
    return randomNumber;
  }
  // END OF METHODS USED TO GENERATE NEW SELF CARE IDEAS


  // method to handle filter changes, updates the displayed idea after
  @override
  void updateFilter(String value)async{
    if(value != _viewModel.filterType){
      _viewModel.filterType = value;
    }
    _view.updateFilter(_viewModel.filterType);
    updateCurrentIdea();
  }



  // BEGINNING OF METHODS USED TO FAVORITE SELF CARE IDEAS
  @override
  void updateFavoritesList(){
    if (_viewModel.heartIcon == Icons.favorite_border) { // an idea has been favorited
      // grabs a database doc for the current idea (the one the user wants to favorite)
      DocumentSnapshot currDoc = _viewModel.ideasList[_viewModel.currentIdeaIndex];
      String id = currDoc.id;
      swapFaveAndIdea(id, currDoc, _viewModel.favoritesDatabaseReference, _viewModel.ideasDatabaseReference);

      // adds the current idea to the favorites list
      _viewModel.favoritesList.add(_viewModel.ideasList[_viewModel.currentIdeaIndex].get("Idea")); // adding the idea string
      // lists the idea as the most recent favorite
      _viewModel.mostRecentFave = _viewModel.ideasList.elementAt(_viewModel.currentIdeaIndex);
      // removes the current idea from the list that can be displayed
      _viewModel.ideasList.removeAt(_viewModel.currentIdeaIndex);

      // updates the heart icon
      _viewModel.heartIcon = Icons.favorite;
    } else { // the user unfavorites the curr idea
      swapFaveAndIdea(_viewModel.mostRecentFave?.id, _viewModel.mostRecentFave, _viewModel.ideasDatabaseReference, _viewModel.favoritesDatabaseReference);
      // removes the curr idea (most recent) from favorites
      _viewModel.favoritesList.removeLast();

      // updates heart icon
      _viewModel.heartIcon = Icons.favorite_border;
    }

    // handles back-end updates and view updates
    updateAfterFavoritesHandle();
  }

  // if the curr idea is being favorited: remove from the idea collection and add to the favorites collection
  // if the curr idea is being unfavorited: remove from the favorites collection and add to the ideas collection
  void swapFaveAndIdea(String? id, DocumentSnapshot? currDoc, CollectionReference refAdd, CollectionReference refRemove){
    refAdd.doc(id).set(
        {
          "Idea": currDoc?.get("Idea"),
          "Filter": currDoc?.get("Filter"),
        });

    refRemove.doc(id).delete();
  }

  // back-end a view updates needed when an idea is (un)favorited
  void updateAfterFavoritesHandle(){
    // update the list of ideas that can be randomly generated, the heart icon in
    // the list of the view, the favorites list that the view will display
    // and the page to display these changes
    updateDatabase();
    _view.updateHeartIcon(_viewModel.heartIcon);
    _view.updateFavorites(_viewModel.favoritesList);
    updatePage(_viewModel.pageIndex);
  }
  // END OF METHODS USED TO FAVORITE SELF CARE IDEAS


  // method to remove an idea from the favorites page, uses additional methods used
  // to add favorites
  @override
  void removeFavorite(String idea) async {
    DocumentSnapshot? currDoc; // to get the current document
    // gets the document that matches the idea the user wants to unfavorite
    await _viewModel.favoritesDatabaseReference.get().then((results){
      for(DocumentSnapshot docs in results.docs){
        if(docs.get("Idea") == idea){
          currDoc = docs;
        }
      }
    });
    String? id = currDoc?.id;

    // adds idea back to the ideas collection, removes from favorites list
    if(currDoc?.get("Filter") != "User made") {
      swapFaveAndIdea(id, currDoc, _viewModel.ideasDatabaseReference,
          _viewModel.favoritesDatabaseReference);
    }
    _viewModel.favoritesList.remove(idea);

    // if the deleted favorite is the current generated idea, update the heart icon
    if(_viewModel.mostRecentFave?.get("Idea") == idea){
      _viewModel.heartIcon = Icons.favorite_border;
    }

    // update back-end and view page
    updateAfterFavoritesHandle();
  }


  // method to make user favorites, adds to database/favorites list and updates view
  @override
  void makeUserFavorite(String idea) async {
    _viewModel.favoritesDatabaseReference.doc().set(
      {
        "Idea": idea,
        "Filter": 'User made',
      });
    _viewModel.favoritesList.add(idea);

    _view.updateFavorites(_viewModel.favoritesList);
    updatePage(_viewModel.pageIndex);
  }


  // method to schedule ideas, formats and adds event to event database
  @override
  void scheduleIdea(String idea, DateTime date, TimeOfDay time){
    String formattedDate = "${date.year}-${date.month}-${date.day}";
    Map<String, int> timeData = {'hour': time.hour, 'minute': time.minute};

    _viewModel.eventsDatabaseReference.doc(formattedDate).set({
      'date': Timestamp.fromDate(date),
      'events': FieldValue.arrayUnion([
        {'time': timeData, 'description': idea}
      ])
    }, SetOptions(merge: true));
  }
}