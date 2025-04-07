class RewardsModel{
  //Variable Initialization
  int streakCounter = 0;
  List<RewardButtonData> rewardButtons = [];

  List<RewardButtonData> getRewardButtons() {
    List<RewardButtonData> initialRewardButtons = [];
    for (int i = 1; i <= 7; i++) {
      initialRewardButtons.add(RewardButtonData(
        label: 'Unlocked Reward \n$i',
        isUnlocked: true,
      ));
    }
    initialRewardButtons.add(RewardButtonData(
        label: 'Locked Reward',
        isUnlocked: false,
    ));
    initialRewardButtons.add(RewardButtonData(
        label: 'Locked Reward',
        isUnlocked: false,
    ));
    initialRewardButtons.add(RewardButtonData(

        label: 'Locked Reward',
        isUnlocked: false,
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
  bool isUnlocked;

  RewardButtonData({required this.label, required this.isUnlocked});
}