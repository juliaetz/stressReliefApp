import 'package:flutter/material.dart';
import 'package:stress_managment_app/model/selfcare_model.dart';
import 'package:stress_managment_app/view/selfcare_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class SelfcarePresenter {
}

class BasicSelfcarePresenter extends SelfcarePresenter{
  late SelfcareModel _viewModel;
  late SelfcareView _view;

  BasicHistoryPresenter() {
    this._viewModel = SelfcareModel();

  }

}