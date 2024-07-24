import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDataFetched = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  TaskProvider() {
    // Fetch tasks from the server when the provider is initialized
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    if (!_isDataFetched) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? tasksString = prefs.getString('tasks');
        if (tasksString != null) {
          final List<dynamic> data = jsonDecode(tasksString);
          _tasks = data.map((taskJson) => Task.fromJson(taskJson)).toList();
        } else {
          final response = await http.get(Uri.parse('https://dummyjson.com/todos'));
          if (response.statusCode == 200) {
            final List<dynamic> data = jsonDecode(response.body)['todos'];
            _tasks = data.map((taskJson) => Task.fromJson(taskJson)).toList();
            await saveTasks();
          } else {
            throw Exception('Failed to load tasks');
          }
        }
        _isDataFetched = true;
      } catch (e) {
        _errorMessage = e.toString();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }


  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      final List<dynamic> data = jsonDecode(tasksString);
      _tasks = data.map((taskJson) => Task.fromJson(taskJson)).toList();
    }
    notifyListeners();
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tasksString = jsonEncode(_tasks.map((task) => task.toJson()).toList());
    prefs.setString('tasks', tasksString);
  }

  Future<void> addTask(String title, String subtitle, int id, String completed) async {
    _tasks.add(Task(id: id, todo: title, completed: completed, userId: 0));
    await saveTasks(); // Await saving tasks to ensure it's completed before notifying listeners
    notifyListeners();
  }

  Future<void> editTask(int id, String newTitle, String newCompleted) async {
    final task = _tasks.firstWhere((task) => task.id == id);
    task.todo = newTitle;
    task.completed = newCompleted;
    await saveTasks(); // Await saving tasks to ensure it's completed before notifying listeners
    notifyListeners();
  }

  Future<void> deleteTask(int id) async {
    _tasks.removeWhere((task) => task.id == id);
    await saveTasks(); // Await saving tasks to ensure it's completed before notifying listeners
    notifyListeners();
  }
} 