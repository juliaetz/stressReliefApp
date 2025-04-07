import 'package:stress_managment_app/model/rewards_model.dart';

class RewardsPresenter {
  final RewardsModel model;
  final Function(int) onStreakChange;
  final Function(List<RewardButtonData>) onRewardsChange;

  RewardsPresenter({required this.model, required this.onStreakChange, required this.onRewardsChange}) {
    updateStreak();
    updateRewards();
  }

  void updateStreak() {
    onStreakChange(model.streakCounter);
  }

  void updateRewards() {
    onRewardsChange(model.rewardButtons);
  }

  void onStreakButtonPressed() {
    model.streakCounter = model.streakCounter + 1;
    updateStreak();
  }

  void onRewardButtonPressed(int index) {
    print('Button ${index + 1} pressed');
  }
}