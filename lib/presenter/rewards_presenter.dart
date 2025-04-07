import 'package:stress_managment_app/view/rewards_view.dart';
import 'package:stress_managment_app/model/rewards_model.dart';

class RewardsPresenter {
RewardsModel model = RewardsModel();
  void UpdateStreak(int newStreakNum){
    model.StreakCounter = newStreakNum;
  }
  int get getStreakCount => model.StreakCounter;

}