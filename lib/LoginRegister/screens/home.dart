import 'package:bookmates_mobile/LoginRegister/screens/login.dart';
import 'package:bookmates_mobile/LoginRegister/screens/register.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.pink.shade200, // Set the background color to pink
        child: Center(
          child: SingleChildScrollView(
          child: Row(
            children: [
               const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:  EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                        'Hi',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Kavoon',
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                      ),
                      Text(
                          'There!',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Kavoon',
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                          ),
                        ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  width: double.infinity,
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Row(
                        children: [
                          Expanded(
                            child: Center(
                            child: Text(
                        "Let's get",
                        style: TextStyle(
                          color: Color(0xFFFF6B6C),
                          fontFamily: 'Kavoon',
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                          ),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Expanded(
                            child: Center(
                            child: Text(
                        "started",
                        style: TextStyle(
                          color: Color(0xFFFF6B6C),
                          fontFamily: 'Kavoon',
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                          ),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Expanded(
                            child: Center( 
                            child: Text(
                        "shall we?",
                        style: TextStyle(
                          color: Color(0xFFFF6B6C),
                          fontFamily: 'Kavoon',
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                          ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the register page
                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) => RegisterPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF6B6C),
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                        child: Center(
                          child: Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Colors.pink.shade200,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                        ),
                        ),
                      ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the login page
                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade200,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
