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
    rewards.add(RewardData(label: 'Bronze Mood Tracking', iconShape: UniconsLine.award_alt, iconColor: Colors.brown, isUnlocked: true));
    rewards.add(RewardData(label: 'Silver Mood Tracking', iconShape: UniconsLine.award, iconColor: Colors.grey, isUnlocked: true));
    rewards.add(RewardData(label: 'Gold Mood Tracking', iconShape: UniconsLine.medal, iconColor: Colors.yellow));
    rewards.add(RewardData(label: 'Diamond Mood Tracking', iconShape: UniconsLine.diamond, iconColor: Colors.cyanAccent));

    rewards.add(RewardData(label: 'Bronze Activity Logging', iconShape: UniconsLine.award_alt, iconColor: Colors.brown));
    rewards.add(RewardData(label: 'Silver Activity Logging', iconShape: UniconsLine.award, iconColor: Colors.grey));
    rewards.add(RewardData(label: 'Gold Activity Logging', iconShape: UniconsLine.medal, iconColor: Colors.yellow));
    rewards.add(RewardData(label: 'Diamond Activity Logging', iconShape: UniconsLine.diamond, iconColor: Colors.cyanAccent));

    rewards.add(RewardData(label: 'Bronze Self Care Finding', iconShape: UniconsLine.award_alt, iconColor: Colors.brown));
    rewards.add(RewardData(label: 'Silver Streak Finding', iconShape: UniconsLine.award, iconColor: Colors.grey));
    rewards.add(RewardData(label: 'Gold Streak Finding', iconShape: UniconsLine.medal, iconColor: Colors.yellow));
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
  bool isUnlocked;

  late Icon icon;
  IconData iconShape;
  Color iconColor;

  RewardData({required this.label, this.isUnlocked=false, required this.iconShape, required this.iconColor,}) {
    icon = Icon(iconShape, color: iconColor);
  }
}