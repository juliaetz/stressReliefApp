import 'package:stress_managment_app/view/rewards_view.dart';
import 'package:stress_managment_app/model/rewards_model.dart';

class RewardsPresenter {
final RewardsModel model;
final Function(int) onStreakChange;
RewardsPresenter({required this.model, required this.onStreakChange});

void updateStreak() {
  onStreakChange(model.StreakCounter);
}

void onButtonPressed() {
  model.StreakCounter = model.StreakCounter + 1;
  updateStreak();
}
}