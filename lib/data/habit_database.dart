import 'package:hive_flutter/hive_flutter.dart';
import 'package:weight/datetime/date_time.dart';

final _myBox = Hive.box("Habit_Database");

class HabitDatabase {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};
  List<Map<String, dynamic>> weightList = []; // Correcting the data structure

  /// Creates default habit data and saves the start date
  void createDefaultData() {
    todaysHabitList = [
      ["Run", false],
      ["Read", false],
    ];
    _myBox.put("START_DATE", todaysDateFormatted());
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);
    updateDatabase();
  }

  /// Load weight data from Hive
  void loadDataWeight() {
    weightList = List<Map<String, dynamic>>.from(_myBox.get("WEIGHT_LIST", defaultValue: []));
  }

  /// Load daily habit list for today
  void loadData() {
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = List.from(_myBox.get("CURRENT_HABIT_LIST"));
      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false; 
      }
    } else {
      // Load data for today
      todaysHabitList = List.from(_myBox.get(todaysDateFormatted()));
    }
  }

  /// Save habit list and weight list to the Hive database
  void updateDatabase() {
    _myBox.put(todaysDateFormatted(), todaysHabitList); // Save today's data
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList); // Save current habit list
    _myBox.put("WEIGHT_LIST", weightList); // Save weight list
    calculateHabitPercentages();
    loadHeatMap();
  }

  /// Save weight with today's date in the weight list
  void saveWeight(String weight) {
  String today = todaysDateFormatted();
  
  // Check if today's weight entry already exists and update it
  int index = weightList.indexWhere((entry) => entry['date'] == today);
  
  if (index != -1) {
    // If weight entry exists, update it
    weightList[index]['weight'] = weight;
  } else {
    // If no entry exists for today, add a new one
    weightList.add({
      "date": today,
      "weight": weight,
    });
  }

  updateDatabase(); // Ensure the database is updated after saving
}


  /// Calculate the percentage of completed habits
  void calculateHabitPercentages() {
    int countCompleted = todaysHabitList.where((habit) => habit[1] == true).length;
    String percent = todaysHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todaysHabitList.length).toStringAsFixed(1);
    
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  /// Load the heat map data based on habit completion percentages
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
