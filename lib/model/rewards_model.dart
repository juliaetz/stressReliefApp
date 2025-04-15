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

    // Mood Tracking
    List<String> trackedDates = [];
    final moodSnapshot = await firestore.collection('Mood').get();
    for (var doc in moodSnapshot.docs) {
      String date = doc['date'];
      String month = date.substring(5, 7); //6th and 7th
      String day = date.substring(8, 10); //9th and 10th
      String formattedDate = "$month-$day";
      if (!trackedDates.contains(formattedDate)) {
        trackedDates.add(formattedDate);
      }
    }
    streakCounter = trackedDates.length;
    for (int i = 0; i <= 3; i++) {
      rewards[i].setCurrentProgress(streakCounter);
    }

    // Activity Logging
    int eventCounter = 0;
    final eventSnapshot = await firestore.collection('events').get();
    for (var doc in eventSnapshot.docs) {
      print(doc['events']);
      List events = doc['events'];
      print(events);
      eventCounter += events.length;
      print(eventCounter);
    }
    for (int i = 4; i <= 7; i++) {
      rewards[i].setCurrentProgress(eventCounter);
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