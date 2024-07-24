import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/login_provider.dart';
import 'package:task_manager_app/task_list_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return SafeArea(  
    child: Scaffold(
      appBar: AppBar(
        title: Text('TASK MANAGER APP'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
         decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      gradient: LinearGradient(
        colors: [
          Color(0xFFc9d6ff), // Convert hexadecimal color code to Flutter Color
          Color(0xFFe2e2e2), // Convert hexadecimal color code to Flutter Color
        ], // Define your gradient colors
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 30),
                    if (loginProvider.isLoading)
                      CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: () async {
                          await loginProvider.login(
                            _usernameController.text,
                            _passwordController.text,
                          );

                          if (loginProvider.errorMessage == null) {
                            // Navigate to TaskListScreen on successful login
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => TaskListScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text(loginProvider.errorMessage ?? 'Error'),
                              ),
                            );
                          }
                        },
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          textStyle: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    )
    );
  }
}
