import 'package:flutter/material.dart';

//Rewards Pop-up takes in a build context and an individual reward and displays the reward's data
//Google Gemini Assisted
class RewardPopUp extends StatelessWidget {
  final IconData iconShape;
  final Color iconColor;
  final String rewardName;
  final int currentProgress;
  final int maxProgress;

  // Constructor for pop up (Should not be called directly)
  const RewardPopUp({
    super.key,
    required this.iconShape,
    required this.iconColor,
    required this.rewardName,
    required this.currentProgress,
    required this.maxProgress,
  });

  // Method to set up pop-up information and show it (Should be called directly)
  static void show(
      BuildContext context, {
        required IconData iconShape,
        required Color iconColor,
        required String rewardName,
        required int currentProgress,
        required int maxProgress,
      }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RewardPopUp(
          iconShape: iconShape,
          iconColor: iconColor,
          rewardName: rewardName,
          currentProgress: currentProgress,
          maxProgress: maxProgress,
        );
      },
    );
  }

  //The rewards Pop-Up
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4, // height of the pop-up
        width: MediaQuery.of(context).size.width * 0.9, // width of the pop-up
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconShape, size: 100, color: iconColor),
            Text(rewardName, style: TextStyle(fontSize: 25)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                children: [
                  LinearProgressIndicator(value: (currentProgress.toDouble() / maxProgress.toDouble()), minHeight: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(currentProgress.toString()),
                      Text(maxProgress.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}