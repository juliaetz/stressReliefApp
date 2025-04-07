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

  @override
  void initState() {
    presenter = RewardsPresenter(model: RewardsModel(), onStreakChange: (newStreak) {
      setState(() {
        _streakCounter = newStreak;
      });
    },);
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
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                padding: EdgeInsets.all(50),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.purple[200]),
                child: Text('$_streakCounter', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
            ),
          ),
          ElevatedButton(onPressed: presenter.onButtonPressed, child: Text("Increment Streak Counter"))
        ],
      )
    );
  }
}