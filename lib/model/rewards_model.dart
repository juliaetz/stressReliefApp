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

  //Initialize Rewards (Called from constructor)
  List<RewardData> getRewards() {
    List<RewardData> rewards = [];
    rewards.add(RewardData(label: 'Bronze Mood Tracking', iconShape: UniconsLine.award_alt, iconColor: Colors.brown, maxProgress: 10));
    rewards.add(RewardData(label: 'Silver Mood Tracking', iconShape: UniconsLine.award, iconColor: Colors.grey, maxProgress: 30));
    rewards.add(RewardData(label: 'Gold Mood Tracking', iconShape: UniconsLine.medal, iconColor: Colors.yellow, maxProgress: 50));
    rewards.add(RewardData(label: 'Diamond Mood Tracking', iconShape: UniconsLine.diamond, iconColor: Colors.cyanAccent, maxProgress: 100));

    rewards.add(RewardData(label: 'Bronze Activity Logging', iconShape: UniconsLine.award_alt, iconColor: Colors.brown, maxProgress: 5));
    rewards.add(RewardData(label: 'Silver Activity Logging', iconShape: UniconsLine.award, iconColor: Colors.grey, maxProgress: 15));
    rewards.add(RewardData(label: 'Gold Activity Logging', iconShape: UniconsLine.medal, iconColor: Colors.yellow, maxProgress: 25));
    rewards.add(RewardData(label: 'Diamond Activity Logging', iconShape: UniconsLine.diamond, iconColor: Colors.cyanAccent, maxProgress: 50));

    rewards.add(RewardData(label: 'Bronze Self Care Finding', iconShape: UniconsLine.award_alt, iconColor: Colors.brown, maxProgress: 1));
    rewards.add(RewardData(label: 'Silver Streak Finding', iconShape: UniconsLine.award, iconColor: Colors.grey, maxProgress: 5));
    rewards.add(RewardData(label: 'Gold Streak Finding', iconShape: UniconsLine.medal, iconColor: Colors.yellow, maxProgress: 10));
    return rewards;
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
  bool isUnlocked = false;

  late Icon icon;
  IconData iconShape;
  Color iconColor;

  int currentProgress = 0;
  int maxProgress;

  RewardData({required this.label, required this.iconShape, required this.iconColor, required this.maxProgress}) {
    icon = Icon(iconShape, color: iconColor);
  }
}