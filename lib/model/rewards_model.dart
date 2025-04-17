import 'package:cloud_firestore/cloud_firestore.dart';
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
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
    rewards.add(RewardData(label: 'Silver Self Care Finding', iconShape: UniconsLine.award, iconColor: Colors.grey, maxProgress: 5));
    rewards.add(RewardData(label: 'Gold Self Care Finding', iconShape: UniconsLine.medal, iconColor: Colors.yellow, maxProgress: 10));
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

  // Google Gemini created from outline of tasks
  Future<void> updateProgressFromDatabase() async {

    // Mood Tracking (Altered after Gemini)
    List<DateTime> trackedDates = [];
    final moodSnapshot = await firestore.collection('Mood').get();
    for (var doc in moodSnapshot.docs) {
      int year = int.parse(doc['date'].substring(0, 4));
      int month = int.parse(doc['date'].substring(5, 7));
      int day = int.parse(doc['date'].substring(8, 10));
      DateTime date = DateTime(year, month, day);
      if (!trackedDates.contains(date)) {
        trackedDates.add(date);
      }
    }
    trackedDates.sort((b, a) => a.compareTo(b)); //Sort dates from most recent to oldest
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime yesterday = today.subtract(Duration(days: 1));
    //Check that streak is still active
    DateTime mostRecentDate = trackedDates[0];
    if (mostRecentDate == today || mostRecentDate == yesterday) {
      //Iterate through days to check how long streak is
      DateTime lastDateChecked = mostRecentDate;
      for (var date in trackedDates) {
        //Keeps increasing streak as long as dates are consecutive and stops once it finds a day that was missed
        if (date == (lastDateChecked.subtract(Duration(days: 1))) || date == mostRecentDate) {
          streakCounter++;
          lastDateChecked = date;
        } else {
          break;
        }
      }
    }
    for (int i = 0; i <= 3; i++) {
      rewards[i].setCurrentProgress(streakCounter);
    }

    // Activity Logging
    int activityCounter = 0;
    final activitySnapshot = await firestore.collection('Activities').get();
    for (var doc in activitySnapshot.docs) {
      List activities = doc['Activities'].split(',');
      activityCounter += activities.length;
    }
    for (int i = 4; i <= 7; i++) {
      rewards[i].setCurrentProgress(activityCounter);
    }

    // Self Care Finding
    final selfCareSnapshot = await firestore.collection('Favorite_Ideas').get();
    for (int i = 8; i <= 10; i++) {
      rewards[i].setCurrentProgress(selfCareSnapshot.docs.length);
    }
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

  void setCurrentProgress(int progress) {
    currentProgress = progress;
    if (progress >= maxProgress) {
      isUnlocked = true;
    }
  }

  RewardData({required this.label, required this.iconShape, required this.iconColor, required this.maxProgress}) {
    icon = Icon(iconShape, color: iconColor);
  }
}