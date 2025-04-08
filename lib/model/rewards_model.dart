import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class RewardsModel{
  //Variable Initialization
  int streakCounter = 0;
  List<RewardButtonData> rewardButtons = [];

  List<RewardButtonData> getRewardButtons() {
    List<RewardButtonData> initialRewardButtons = [];
    for (int i = 1; i <= 7; i++) {
      initialRewardButtons.add(RewardButtonData(
        label: 'Unlocked Reward \n$i',
        icon: Icon(Icons.star),
        isUnlocked: true,
      ));
    }
    initialRewardButtons.add(RewardButtonData(
      label: 'Locked Reward',
      icon: Icon(UniconsLine.award_alt),
      isUnlocked: false,
    ));
    initialRewardButtons.add(RewardButtonData(
      label: 'Locked Reward',
      icon: Icon(UniconsLine.award),
    ));
    initialRewardButtons.add(RewardButtonData(
      label: 'Locked Reward',
      icon: Icon(UniconsLine.medal),
    ));
    return initialRewardButtons;
  }

  //Constructor
  RewardsModel() {
    rewardButtons = getRewardButtons();
  }
}

class RewardButtonData {
  String label;
  Icon icon;
  bool isUnlocked;

  RewardButtonData({required this.label, required this.icon, this.isUnlocked=false});
}