import 'package:flutter/material.dart';
import '../presenter/rewards_presenter.dart';

class RewardsView extends StatefulWidget {
  final RewardsPresenter presenter = RewardsPresenter();
  RewardsView({super.key});

  @override
  State<RewardsView> createState() => _RewardsViewState();
}

class _RewardsViewState extends State<RewardsView> {

int _StreakCounter = 0;

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rewards'),
        backgroundColor: Colors.deepPurple.shade200,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
            padding: EdgeInsets.all(50),
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.purple[200]),
            child: Text('$_StreakCounter', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
        ),
      )
    );
  }
}