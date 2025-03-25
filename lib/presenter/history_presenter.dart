import 'package:stress_managment_app/model/history_model.dart';
import 'package:stress_managment_app/view/history_view.dart';

class HistoryPresenter {
  set historyView(HistoryView value){}
}

class BasicHistoryPresenter extends HistoryPresenter{
  late HistoryModel _viewModel;
  late HistoryView _view;

  BasicPresenter() {
    this._viewModel = HistoryModel();
  }
}