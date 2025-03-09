import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TravelPlanner(),
    );
  }
}

class Plan {
  final String id;
  String name;
  String description;
  DateTime date;
  bool completed;
  String priority; // 'Low', 'Medium', 'High'

  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    this.completed = false,
    this.priority = 'Low',
  });
}


class TravelPlanner extends StatefulWidget {
  @override
  _TravelPlannerState createState() => _TravelPlannerState();
}

class _TravelPlannerState extends State<TravelPlanner> {
  List<Plan> plans = [];

  /*
  * Converts priority to a numeric value
  */
  int _priorityValue(String priority) {
    switch (priority) {
      case 'High':
        return 3;
      case 'Medium':
        return 2;
      case 'Low':
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text('Travel Plans'),
      ),
      body: Center(
        
        child: Column(         
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}
