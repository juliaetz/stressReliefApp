import 'package:stress_managment_app/model/history_model.dart';
import 'package:stress_managment_app/view/history_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class HistoryPresenter {
  set historyView(HistoryView value){}
  void onOptionChanged(String value) {}
}

class BasicHistoryPresenter extends HistoryPresenter{
  late HistoryModel _viewModel;
  late HistoryView _view;

  BasicHistoryPresenter() {
    this._viewModel = HistoryModel();
    _loadUnit();
  }

  void _loadUnit() async {
    _viewModel.historyType = "na";
    _view.updateHistory(_viewModel.historyType);
  }

  @override
  set historyView(HistoryView value) {
    _view = value;
    _view.updateHistory(_viewModel.historyType);
  }

  @override
  void onOptionChanged(String value){
    if (value != _viewModel.historyType) {
      _viewModel.historyType = value;
      _view.updateHistory(_viewModel.historyType);
    }
  }

  void addBlock(String date, String data){
    
  }
}