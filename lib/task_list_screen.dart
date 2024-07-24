import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:task_manager_app/task.dart';
import 'package:task_manager_app/task_provider.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  void _showAddTaskDialog(BuildContext context) {
    String title = '';
    String subtitle = '';
    int id = 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => title = value,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              onChanged: (value) => subtitle = value,
              decoration: InputDecoration(labelText: 'Subtitle'),
            ),
            TextField(
              onChanged: (value) => id = int.tryParse(value) ?? 0,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'ID'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .addTask(title, subtitle, id, 'false');
              Navigator.of(context).pop();
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    final TextEditingController titleController =
        TextEditingController(text: task.todo);
    final TextEditingController completedController =
        TextEditingController(text: task.completed);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: completedController,
              decoration: InputDecoration(labelText: 'Completed'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .editTask(task.id, titleController.text, completedController.text);
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Task List'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: taskProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : taskProvider.errorMessage != null
                ? Center(child: Text('Error: ${taskProvider.errorMessage}'))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 70.0), // Adjust the bottom padding
                      child: ListView.builder(
                        itemCount: taskProvider.tasks.length,
                        itemBuilder: (context, index) {
                          final task = taskProvider.tasks[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFc9d6ff),
                                    Color(0xFFe2e2e2),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(task.id.toString()),
                                ),
                                title: Text(task.todo),
                                subtitle: Text('Completed: ${task.completed}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        _showEditTaskDialog(context, task);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        taskProvider.deleteTask(task.id);
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // Handle task tap
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddTaskDialog(context),
          child: Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
        ),
      ),
    );
  }
}