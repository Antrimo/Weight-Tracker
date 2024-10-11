import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weight/Notification/notifi_service.dart';
import 'package:weight/components/habit_tile.dart';
import 'package:weight/components/month_summary.dart';
import 'package:weight/components/my_alert_box.dart';
import 'package:weight/data/habit_database.dart';

class WeightHomePage extends StatefulWidget {
  const WeightHomePage({super.key});

  @override
  State<WeightHomePage> createState() => _WeightHomePageState();
}

class _WeightHomePageState extends State<WeightHomePage> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");

  @override
  void initState() {
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    } else {
      db.loadData();
    }
    db.updateDatabase();
    super.initState();
  }

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatabase();
  }

  final _newHabitNameController = TextEditingController();
  final _newWeightController = TextEditingController();

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: 'Enter Exercise Name',
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  void recordWeight() {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newWeightController,
          hintText: 'Enter Weight',
          onSave: saveWeight,
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  

  void saveWeight() {
    setState(() {
      String weight = _newWeightController.text;
      db.saveWeight(weight); // Call the correct database method
    });
    _newWeightController.clear();
    Navigator.of(context).pop();
    db.updateDatabase(); // Update the database
  }

  void saveNewHabit() {
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });
    _newHabitNameController.clear();
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  void cancelDialogBox() {
    _newHabitNameController.clear();
    _newWeightController.clear();
    Navigator.of(context).pop();
  }

  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: db.todaysHabitList[index][0],
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateDatabase();
  }

  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Weight Tracker',style: TextStyle(fontStyle: FontStyle.italic),),
      ),
      endDrawer: const HomePage(),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            children: [
              MonthlySummary(
                datasets: db.heatMapDataSet,
                startDate: _myBox.get("START_DATE"),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: db.todaysHabitList.length,
                itemBuilder: (context, index) {
                  return HabitTile(
                    habitName: db.todaysHabitList[index][0],
                    habitCompleted: db.todaysHabitList[index][1],
                    onChanged: (value) => checkBoxTapped(value, index),
                    settingsTapped: (context) => openHabitSettings(index),
                    deleteTapped: (context) => deleteHabit(index),
                  );
                },
              ),
            ],
          ),
          Positioned(
            right: 10,
            bottom: 80,
            child: FloatingActionButton(
              heroTag: 'weight',
              onPressed: recordWeight,
              child: const Icon(Icons.line_weight),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 16,
            child: FloatingActionButton(
              heroTag: 'add',
              onPressed: createNewHabit,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
