import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class RewardsModel{

  //Constructor
  RewardsModel() {
    rewards = getRewards();
  }

  //Variable Initialization
  int streakCounter = 0;
  List<RewardData> rewards = [];

  //Initialize Reward Buttons (Called from constructor)
  List<RewardData> getRewards() {
    List<RewardData> initialRewards = [];
    initialRewards.add(RewardData(label: 'Bronze Mood Tracking', iconShape: UniconsLine.award_alt, iconColor: Colors.brown));
    initialRewards.add(RewardData(label: 'Silver Mood Tracking', iconShape: UniconsLine.award, iconColor: Colors.grey));
    initialRewards.add(RewardData(label: 'Gold Mood Tracking', iconShape: UniconsLine.medal, iconColor: Colors.yellow));
    initialRewards.add(RewardData(label: 'Diamond Mood Tracking', iconShape: UniconsLine.diamond, iconColor: Colors.cyanAccent));

    initialRewards.add(RewardData(label: 'Bronze Streak', iconShape: UniconsLine.award_alt, iconColor: Colors.brown));
    initialRewards.add(RewardData(label: 'Silver Streak', iconShape: UniconsLine.award, iconColor: Colors.grey));
    initialRewards.add(RewardData(label: 'Gold Streak', iconShape: UniconsLine.medal, iconColor: Colors.yellow));
    initialRewards.add(RewardData(label: 'Diamond Streak', iconShape: UniconsLine.diamond, iconColor: Colors.cyanAccent));

    initialRewards.add(RewardData(label: 'Bronze Streak', iconShape: UniconsLine.award_alt, iconColor: Colors.brown));
    initialRewards.add(RewardData(label: 'Silver Streak', iconShape: UniconsLine.award, iconColor: Colors.grey));
    initialRewards.add(RewardData(label: 'Gold Streak', iconShape: UniconsLine.medal, iconColor: Colors.yellow));
    return initialRewards;
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
  bool isUnlocked;

  late Icon icon;
  IconData iconShape;
  Color iconColor;

  RewardData({required this.label, this.isUnlocked=false, required this.iconShape, required this.iconColor,}) {
    icon = Icon(iconShape, color: iconColor);
  }
}