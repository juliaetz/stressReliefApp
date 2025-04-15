import 'package:stress_managment_app/model/rewards_model.dart';
import 'package:flutter/material.dart';

class RewardsPresenter {
  final RewardsModel model;
  final Function(int) streakUpdate;
  final Function(List<RewardData>) rewardsUpdate;
  final Function(BuildContext context, RewardData reward) showRewardPopUp;
  late Future<void> rewardsLoadedFuture;

  RewardsPresenter({required this.model, required this.streakUpdate, required this.rewardsUpdate, required this.showRewardPopUp}) {
    updateStreak();
    rewardsLoadedFuture = updateRewards();
  }

  void updateStreak() {
    streakUpdate(model.streakCounter);
  }

  Future<void> updateRewards() async {
    await model.updateRewardsProgress();
    rewardsUpdate(model.rewards);
  }

  void onStreakButtonPressed() {
    model.streakCounter = model.streakCounter + 1;
    updateStreak();
  }

  void onRewardButtonPressed(BuildContext context, RewardData reward) {
    showRewardPopUp(context, reward);
  }

  void onUnlockedButtonPressed() {
    rewardsUpdate(model.getUnlockedRewards());
  }

  void onAllRewardsButtonPressed() {
    rewardsUpdate(model.rewards);
  }

  void onLockedButtonPressed() {
    rewardsUpdate(model.getLockedRewards());
  }
}