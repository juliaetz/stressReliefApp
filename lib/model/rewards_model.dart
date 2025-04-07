class RewardsModel{
  //Variable Initialization
  int _StreakCounter = 0;
  int get StreakCounter => _StreakCounter;
  set StreakCounter(int newStreakNum) {
    _StreakCounter = newStreakNum;
  }
  //Constructor
  RewardsModel();
}