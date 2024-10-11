import 'package:hive_flutter/hive_flutter.dart';
import 'package:weight/datetime/date_time.dart';

final _myBox = Hive.box("Habit_Database");

class HabitDatabase {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};
  List<Map<String, dynamic>> weightList = []; 

  void createDefaultData() {
    todaysHabitList = [
      ["Run", false],
      ["Read", false],
    ];
    _myBox.put("START_DATE", todaysDateFormatted());
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);
    updateDatabase();
  }
  

  void loadDataWeight() {
    weightList = List<Map<String, dynamic>>.from(_myBox.get("WEIGHT_LIST", defaultValue: []));
  }


  void loadData() {
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = List.from(_myBox.get("CURRENT_HABIT_LIST"));
      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false; 
      }
    } else {
      todaysHabitList = List.from(_myBox.get(todaysDateFormatted()));
    }
  }

  void updateDatabase() {
    _myBox.put(todaysDateFormatted(), todaysHabitList); 
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList); 
    _myBox.put("WEIGHT_LIST", weightList); 
    calculateHabitPercentages();
    loadHeatMap();
  }

  void saveWeight(String weight) {
  String today = todaysDateFormatted();
  
  int index = weightList.indexWhere((entry) => entry['date'] == today);
  
  if (index != -1) {
    weightList[index]['weight'] = weight;
  } else {
    weightList.add({
      "date": today,
      "weight": weight,
    });
  }

  updateDatabase(); 
}


  void calculateHabitPercentages() {
    int countCompleted = todaysHabitList.where((habit) => habit[1] == true).length;
    String percent = todaysHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todaysHabitList.length).toStringAsFixed(1);
    
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i <= daysInBetween; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.tryParse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      ) ?? 0.0;

      DateTime date = startDate.add(Duration(days: i));
      heatMapDataSet[date] = (10 * strengthAsPercent).toInt();
    }
  }
}
