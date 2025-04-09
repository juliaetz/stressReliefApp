import 'package:stress_managment_app/model/rewards_model.dart';

class RewardsPresenter {
  final RewardsModel model;
  final Function(int) streakUpdate;
  final Function(List<RewardData>) rewardsUpdate;

  RewardsPresenter({required this.model, required this.streakUpdate, required this.rewardsUpdate}) {
    updateStreak();
    updateRewards();
  }

  void updateStreak() {
    streakUpdate(model.streakCounter);
  }

  void updateRewards() {
    rewardsUpdate(model.rewards);
  }

  void onStreakButtonPressed() {
    model.streakCounter = model.streakCounter + 1;
    updateStreak();
  }

  void onRewardButtonPressed(int index) {
    print('Button ${index + 1} pressed');
  }

  void onUnlockedButtonPressed() {
    rewardsUpdate(model.getUnlockedRewards());
  }

  void onLockedButtonPressed() {
    rewardsUpdate(model.getLockedRewards());
  }
}