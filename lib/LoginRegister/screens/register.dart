import 'dart:convert';
import 'package:bookmates_mobile/Ratings/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'package:bookmates_mobile/DashboardUser/screen/dashboard.dart';

void main() {
  runApp(const RegisterApp());
}

class RegisterApp extends StatelessWidget {
  const RegisterApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  bool _isTeacher = false;

  bool isPasswordStrong(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: myAppBar("Register"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.pink),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.pink),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _passwordConfirmationController,
              decoration: const InputDecoration(
                labelText: 'Password Verification',
                labelStyle: TextStyle(color: Colors.pink),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                Checkbox(
                  value: _isTeacher,
                  onChanged: (value) {
                    setState(() {
                      _isTeacher = value!;
                    });
                  },
                ),
                Text('I am a writer'),
              ],
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text;
                String password = _passwordController.text;
                String passwordConfirmation =
                    _passwordConfirmationController.text;

                if (username.isEmpty) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                      content: Text("Please enter a username."),
                    ));
                  return;
                }

                if (password != passwordConfirmation) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                        content: Text(
                            "Register failed, password verification incorrect.")));
                  return;
                }

                if (!isPasswordStrong(password)) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                      content: Text("Password must be strong and include at least 8 characters, one uppercase letter, one lowercase letter, one digit, and one special character.")));
                   return;
                }

                // print("DEBUG: $username $password");

                // Sending the registration request
                final response = await request.post(
                  "https://booksmate-d05-tk.pbp.cs.ui.ac.id/auth/register/",
                  {
                    'username': username,
                    'password': password,
                    'is_teacher': _isTeacher ? 'true' : 'false'
                  },
                );

                
                userProvider.setTeacherStatus(response['is_teacher']);
                if (response['status']) {
                  String message = response['message'];

                  // Redirecting to login page after successful registration
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("$message")));
                } else {
                  // Displaying an error dialog in case of registration failure
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Register failed.'),
                      content: Text(response['message']),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
