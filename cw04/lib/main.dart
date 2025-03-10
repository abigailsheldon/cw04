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
  * User can either create a new plan or edit existing plan
  *
  */
  void _showPlanDialog({Plan? existingPlan}) {
    String name = existingPlan?.name ?? '';
    String description = existingPlan?.description ?? '';
    DateTime selectedDate = existingPlan?.date ?? DateTime.now();
    String selectedPriority = existingPlan?.priority ?? 'Low';

    TextEditingController nameController =
        TextEditingController(text: name);
    TextEditingController descriptionController =
        TextEditingController(text: description);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              // Create plan if no existing plan passed
              // Otherwise, edit plan
              title: Text(existingPlan == null ? 'Create Plan' : 'Edit Plan'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Plan Name'),
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          InputDecoration(labelText: 'Description'),
                      onChanged: (value) {
                        description = value;
                      },
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      child: Text("Select Date"),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setStateDialog(() {
                            selectedDate = date;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    // Dropdown to select priority 
                    DropdownButton<String>(
                      value: selectedPriority,
                      items: <String>['Low', 'Medium', 'High']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        // Updates the selected priority value
                        setStateDialog(() {
                          selectedPriority = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                // Button to cancel
                // CLoses without making changes
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  // If no existing plan, creates new plan
                  // Adds plan to list
                  // If existing plan, updates
                  child: Text(existingPlan == null ? 'Create' : 'Update'),
                  onPressed: () {
                    if (existingPlan == null) {
                      setState(() {
                        plans.add(Plan(
                          id: DateTime.now().toString(),
                          name: nameController.text,
                          description: descriptionController.text,
                          date: selectedDate,
                          priority: selectedPriority,
                        ));
                        // Sort plans from high to low priority
                        plans.sort((a, b) =>
                            _priorityValue(b.priority)
                                .compareTo(_priorityValue(a.priority)));
                      });
                    } else {
                      setState(() {
                        existingPlan.name = nameController.text;
                        existingPlan.description =
                            descriptionController.text;
                        existingPlan.date = selectedDate;
                        existingPlan.priority = selectedPriority;
                        plans.sort((a, b) =>
                            _priorityValue(b.priority)
                                .compareTo(_priorityValue(a.priority)));
                      });
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  /*
  * Template to create a new plan.
  * Template is draggable.
  */
  Widget _buildDraggableTemplate() {
    // Makes template draggable, carries info about new plan
    return Draggable<Plan>(
      // Plan object, attached as draggable data
      data: Plan(
        id: DateTime.now().toString(),
        name: 'New Plan',
        description: 'Plan descrip.',
        date: DateTime.now(),
      ),
      feedback: Material(
        child: Container(
          padding: EdgeInsets.all(8),
          color: Colors.blueAccent,
          child: Text('New Plan'),
        ),
      ),
      childWhenDragging: Container(
        padding: EdgeInsets.all(8),
        color: Colors.grey,
        child: Text('Drag to add plan'),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        color: Colors.blue,
        child: Text('Drag to add plan'),
      ),
    );
  }


  /*
  * Main build method
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Travel Planner"),
      ),
      body: Column(
        children: [
          // Calendar
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: DateTime.now(),
            onDaySelected: (selectedDay, focusedDay) {
              // Filters plans
            },
          ),
          // Draggable template widget
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDraggableTemplate(),
          ),
          Expanded(
            child: DragTarget<Plan>(
              onAcceptWithDetails: (DragTargetDetails<Plan> details) {
                final droppedPlan = details.data;
                setState(() {
                  plans.add(droppedPlan);
                  plans.sort((a, b) => _priorityValue(b.priority)
                      .compareTo(_priorityValue(a.priority)));
                });
              },
              builder: (context, candidateData, rejectedData) {
                return ListView.builder(
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return Dismissible(
                      key: Key(plan.id),
                      background: Container(
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.check, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: Colors.green,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.undo, color: Colors.white),
                      ),
                      // Change completion status
                      onDismissed: (direction) {
                        setState(() {
                          plan.completed = !plan.completed;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(plan.completed
                                ? 'Plan marked as completed'
                                : 'Plan marked as pending'),
                          ),
                        );
                      },
                      // Displays plan details
                      child: TravelPlanCard(
                        plan: plan,
                        onEdit: () => _showPlanDialog(existingPlan: plan),
                        onDelete: () {
                          setState(() {
                            plans.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Plan deleted')),
                          );
                        },
                        onToggleComplete: () {
                          setState(() {
                            plan.completed = !plan.completed;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(plan.completed
                                  ? 'Plan completed'
                                  : 'Plan pending'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Button to create new plan
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showPlanDialog(),
      ),
    );
  }
}
