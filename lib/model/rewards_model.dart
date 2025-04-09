import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class RewardsModel{

  //Constructor
  RewardsModel() {
    rewards = getRewardButtons();
  }

  //Variable Initialization
  int streakCounter = 0;
  List<RewardData> rewards = [];

  //Initialize Reward Buttons (Called from constructor)
  List<RewardData> getRewardButtons() {
    List<RewardData> initialRewardButtons = [];
    for (int i = 1; i <= 7; i++) {
      initialRewardButtons.add(RewardData(
        label: 'Unlocked Reward \n$i',
        icon: Icon(Icons.star),
        isUnlocked: true,
      ));
    }
    initialRewardButtons.add(RewardData(
      label: 'Locked Reward',
      icon: Icon(UniconsLine.award_alt),
      isUnlocked: false,
    ));
    initialRewardButtons.add(RewardData(
      label: 'Locked Reward',
      icon: Icon(UniconsLine.award),
    ));
    initialRewardButtons.add(RewardData(
      label: 'Locked Reward',
      icon: Icon(UniconsLine.medal),
    ));
    return initialRewardButtons;
  }

  List<RewardData> getUnlockedRewards() {
    List<RewardData> unlockedRewards = [];
    for (RewardData reward in rewards) {
      if (reward.isUnlocked) {
        unlockedRewards.add(reward);
      }
    }
    return unlockedRewards;
  }
  List<RewardData> getLockedRewards() {
    List<RewardData> lockedRewards = [];
    for (RewardData reward in rewards) {
      if (!reward.isUnlocked) {
        lockedRewards.add(reward);
      }
    }
    return lockedRewards;
  }

}

class RewardData {
  String label;
  Icon icon;
  bool isUnlocked;

  RewardData({required this.label, required this.icon, this.isUnlocked=false});
}