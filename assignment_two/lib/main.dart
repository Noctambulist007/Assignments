import 'package:flutter/material.dart';

void main() => runApp(MoodTrackerApp());

class MoodTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Tracker',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.tealAccent, 
            overlayColor: Colors.black, 
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), 
            ),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: MoodTrackerHomePage(),
    );
  }
}

class MoodTrackerHomePage extends StatefulWidget {
  @override
  _MoodTrackerHomePageState createState() => _MoodTrackerHomePageState();
}

class _MoodTrackerHomePageState extends State<MoodTrackerHomePage> {
  double _moodRating = 3;
  bool _hasExercised = false;
  bool _hasMeditated = false;
  String _selectedActivity = 'None';
  double _sleepHours = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Mood Tracker'),
        centerTitle: true, 
        elevation: 10, 
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('How are you feeling today?'),
              _buildMoodSlider(),
              SizedBox(height: 20),
              _buildTitle('Did you exercise today?'),
              _buildSwitchTile(_hasExercised, 'Exercised', (value) {
                setState(() {
                  _hasExercised = value;
                });
              }),
              SizedBox(height: 20),
              _buildTitle('Did you meditate today?'),
              _buildCheckboxTile(_hasMeditated, 'Meditated', (value) {
                setState(() {
                  _hasMeditated = value ?? false;
                });
              }),
              SizedBox(height: 20),
              _buildTitle('What was your main activity today?'),
              _buildRadioOptions(),
              SizedBox(height: 20),
              _buildTitle('How many hours did you sleep last night?'),
              _buildSleepSlider(),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  child: Text('Save Daily Log',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Daily log saved!')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.tealAccent),
    );
  }

  Widget _buildMoodSlider() {
    return Slider(
      value: _moodRating,
      min: 1,
      max: 5,
      divisions: 4,
      activeColor: Colors.tealAccent,
      inactiveColor: Colors.teal.shade700,
      label: _moodRating.round().toString(),
      onChanged: (value) {
        setState(() {
          _moodRating = value;
        });
      },
    );
  }

  Widget _buildSwitchTile(bool value, String label, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(label, style: TextStyle(fontSize: 18)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.tealAccent,
    );
  }

  Widget _buildCheckboxTile(bool value, String label, ValueChanged<bool?>? onChanged) {
    return CheckboxListTile(
      title: Text(label, style: TextStyle(fontSize: 18)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.tealAccent,
    );
  }


  Widget _buildRadioOptions() {
    return Column(
      children: ['Work', 'Study', 'Relaxation', 'Social', 'None']
          .map((activity) => RadioListTile(
        title: Text(activity),
        value: activity,
        groupValue: _selectedActivity,
        onChanged: (value) {
          setState(() {
            _selectedActivity = value.toString();
          });
        },
      ))
          .toList(),
    );
  }

  Widget _buildSleepSlider() {
    return Slider(
      value: _sleepHours,
      min: 0,
      max: 12,
      divisions: 12,
      activeColor: Colors.tealAccent,
      inactiveColor: Colors.teal.shade700,
      label: _sleepHours.toString(),
      onChanged: (value) {
        setState(() {
          _sleepHours = value;
        });
      },
    );
  }
}
