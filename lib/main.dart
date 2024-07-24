import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/login_provider.dart';
import 'package:task_manager_app/login_screen.dart';
import 'package:task_manager_app/task_list_screen.dart';
import 'package:task_manager_app/task_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'TASK MANAGER APP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<LoginProvider>(
          builder: (context, loginProvider, _) {
            // Check if user is logged in
            if (loginProvider.isLoggedIn) {
              return TaskListScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}





