import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adoption & Travel Plans',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlanManagerScreen(),
    );
  }
}

class Plan {
  final String id;
  String name;
  String description;
  DateTime date;
  bool completed;
  String priority; // e.g., 'Low', 'Medium', 'High'

  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    this.completed = false,
    this.priority = 'Low',
  });
}


class PlanManagerScreen extends StatefulWidget {
  @override
  _PlanManagerScreenState createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  List<Plan> plans = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        // the App.build method, and use it to set our appbar title.
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
