import 'package:flutter/material.dart';
import 'package:stress_managment_app/model/selfcare_model.dart';
import 'package:stress_managment_app/view/selfcare_component.dart';
import 'package:stress_managment_app/view/selfcare_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class SelfcarePresenter {
  void updatePage(int index){}
  set selfcareView(SelfcareView value){}
}

class BasicSelfcarePresenter extends SelfcarePresenter{
  late SelfcareModel _viewModel;
  late SelfcareView _view;

  BasicSelfcarePresenter() {
    this._viewModel = SelfcareModel();
    _loadPageIndex();
  }

  void _loadPageIndex() async {
    _viewModel.pageIndex = 0;
    _view.updateSelectedIndex(_viewModel.pageIndex);
  }

  @override
  set selfcareView(SelfcareView value) {
    _view = value;
    _view.updateSelectedIndex(_viewModel.pageIndex);
    updatePage(_viewModel.pageIndex);
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
      //page = FavoritesPage();
      page = _view.FavoritesPage();
    }

    _view.updatePage(page);
  }

}