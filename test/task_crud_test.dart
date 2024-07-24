import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:task_manager_app/task_provider.dart';

class MockHttpClient extends Mock implements http.Client {}

// Global variables for the dependencies
MockHttpClient? mockHttpClient;
SharedPreferences? sharedPreferences;

void main() {
  setUp(() async {
    mockHttpClient = MockHttpClient();
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
  });

  group('TaskProvider', () {

    test('add task', () async {
      final taskProvider = TaskProvider();
      await taskProvider.addTask('New Task', 'false', 2, '0');
      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks.first.todo, 'New Task');
    });

    test('edit task', () async {
      final taskProvider = TaskProvider();
      await taskProvider.addTask('New Task', 'false', 2, '0');
      await taskProvider.editTask(2, 'Updated Task', 'true');

      expect(taskProvider.tasks.first.todo, 'Updated Task');
      expect(taskProvider.tasks.first.completed, 'true');
    });

    test('delete task', () async {
      final taskProvider = TaskProvider();
      await taskProvider.addTask('New Task', 'false', 2, '0');
      await taskProvider.deleteTask(2);

      expect(taskProvider.tasks.length, 0);
    });
  });
}

