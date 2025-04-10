import 'package:flutter/material.dart';

//Google Gemini Assisted
class RewardPopUp extends StatelessWidget {
  final IconData iconShape;
  final Color iconColor;
  final String rewardName;
  final double progressValue;

  // Constructor for pop up (Should not be called directly)
  const RewardPopUp({
    Key? key,
    required this.iconShape,
    required this.iconColor,
    required this.rewardName,
    required this.progressValue,
  }) : super(key: key);

  // Method to set up pop-up information and show it (Should be called directly)
  static void show(
      BuildContext context, {
        required IconData iconShape,
        required Color iconColor,
        required String rewardName,
        required double progressValue,
      }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RewardPopUp(
          iconShape: iconShape,
          iconColor: iconColor,
          rewardName: rewardName,
          progressValue: progressValue,
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
              height: 10,
              child: LinearProgressIndicator(value: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}