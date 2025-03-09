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


/*
* Widget to display a plan in a Card format
*/
class TravelPlanCard extends StatelessWidget {
  final Plan plan;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;

  const TravelPlanCard({
    Key? key,
    required this.plan,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Long press to edit plan
      onLongPress: onEdit,
      // Double-tap to delete plan
      onDoubleTap: onDelete,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: plan.completed
              ? Colors.grey[400]
              : (plan.priority == 'High'
                  ? Colors.red[200]
                  : (plan.priority == 'Medium'
                      ? Colors.orange[200]
                      : Colors.green[200])),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(
            plan.name,
            style: TextStyle(
                decoration: plan.completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
          subtitle: Text(
            "${plan.description}\nDate: ${plan.date.toLocal().toString().split(' ')[0]}\nPriority: ${plan.priority}",
          ),
          trailing: IconButton(
            icon: Icon(
              plan.completed ? Icons.undo : Icons.check,
              color: Colors.black,
            ),
            onPressed: onToggleComplete,
          ),
        ),
      ),
    );
  }
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

  /*
  * Main build method
  */
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
