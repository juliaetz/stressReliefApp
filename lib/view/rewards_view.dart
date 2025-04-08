import 'package:flutter/material.dart';
import 'package:stress_managment_app/model/rewards_model.dart';
import '../presenter/rewards_presenter.dart';

class RewardsView extends StatefulWidget {
  RewardsView({super.key});

  @override
  State<RewardsView> createState() => _RewardsViewState();
}

class _RewardsViewState extends State<RewardsView> {

  late RewardsPresenter presenter;
  late int _streakCounter;
  late List<RewardButtonData> _rewardButtons;

  @override
  void initState() {
    presenter = RewardsPresenter(
      model: RewardsModel(),
      onStreakChange: (int newStreak) {
        setState(() {
          _streakCounter = newStreak;
        });
      },
      onRewardsChange: (List<RewardButtonData> newButtons) {
        setState(() {
          _rewardButtons = newButtons;
        });
      },
    );
    presenter.updateStreak();
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

          //Update Streak Counter (Just for Testing)
          ElevatedButton(onPressed: presenter.onStreakButtonPressed, child: Text("Increment Streak Counter")),

          //Rewards Grid UI
          //Google Gemini Assisted
          Expanded(
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _rewardButtons.length,
                    itemBuilder: (BuildContext context, int index) {
                      final button = _rewardButtons[index];
                      return AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: button.isUnlocked
                              ? () {
                                presenter.onRewardButtonPressed(index);
                              }
                              : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: button.isUnlocked
                                  ? Colors.purple[200]
                                  : Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Center(child: Text(button.label)),
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