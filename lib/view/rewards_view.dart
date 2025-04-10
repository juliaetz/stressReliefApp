import 'package:flutter/material.dart';
import 'package:stress_managment_app/model/rewards_model.dart';
import '../presenter/rewards_presenter.dart';
import '../view/reward_pop_up.dart';
import 'package:unicons/unicons.dart';

class RewardsView extends StatefulWidget {
  RewardsView({super.key});

  @override
  State<RewardsView> createState() => _RewardsViewState();
}

class _RewardsViewState extends State<RewardsView> {

  late RewardsPresenter presenter;
  late int _streakCounter;
  late List<RewardData> _rewards;

  @override
  void initState() {
    presenter = RewardsPresenter(
      model: RewardsModel(),
      streakUpdate: (int newStreak) {
        setState(() {
          _streakCounter = newStreak;
        });
      },
      rewardsUpdate: (List<RewardData> newRewards) {
        setState(() {
          _rewards = newRewards;
        });
      },
      showRewardPopUp: (BuildContext context, RewardData reward) {
        RewardPopUp.show(
          context,
          iconShape: reward.iconShape,
          iconColor: reward.iconColor,
          rewardName: reward.label,
          progressValue: 0.5,
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rewards'),
        backgroundColor: Colors.deepPurple.shade200,
      ),
      body: Column(
        children: [

          //Streak Counter UI
          Align(
            alignment: Alignment.center,
            child: Container(
                padding: EdgeInsets.all(50),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.purple[200]),
                child: Text('$_streakCounter', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
            ),
          ),

          //Update Streak Counter Button (Just for Testing)
          ElevatedButton(onPressed: presenter.onStreakButtonPressed, child: Text("Increment Streak Counter")),

          //Unlocked/All/Locked Rewards Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(onPressed: presenter.onUnlockedButtonPressed, icon: Icon(UniconsLine.unlock), label: Text("Unlocked")),
              Padding(padding: EdgeInsets.all(10)),
              ElevatedButton.icon(onPressed: presenter.onAllRewardsButtonPressed, icon: Icon(Icons.list), label: Text("All")),
              Padding(padding: EdgeInsets.all(10)),
              ElevatedButton.icon(onPressed: presenter.onLockedButtonPressed, icon: Icon(Icons.lock), label: Text("Locked")),
            ],
          ),

          //Rewards Grid
          //Google Gemini Assisted
          Expanded(
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3
                    ),
                    padding: const EdgeInsets.all(12),
                    itemCount: _rewards.length,
                    itemBuilder: (BuildContext context, int index) {
                      final reward = _rewards[index];
                      return AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () => presenter.onRewardButtonPressed(context, reward),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: reward.isUnlocked
                                  ? Colors.purple[200]
                                  : Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      reward.icon,
                                      Text(reward.label, textAlign: TextAlign.center)
                                    ],
                                ),
                            )
                        ),
                      );
                    },
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}