import 'planner_model.dart';

class PlannerPresenter {
  final PlannerModel model;

  PlannerPresenter(this.model);

  String fetchPlannerData() {
    return model.getPlannerData();
  }
}
