import 'dart:async';
import 'package:flutter/material.dart';
import 'package:partial_tourbuddy/login_page.dart';
import 'package:partial_tourbuddy/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  static const String KEYLOGIN = 'login';

  @override
  void initState() {
    super.initState();
    WhereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100], // Set background color to orange
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add loading animation with an airplane
            Image.asset(
              'assets/flying_plane1.gif', // Replace 'assets/airplane.png' with the path to your airplane image asset
              width: 100,
              height: 100,
              color: Colors.blue[300], // Set airplane color to blue
            ),
            SizedBox(height: 20),
            // Add "TourBuddy" text with custom style
            const Text(
              "TourBuddy",
              style: TextStyle(
                fontSize: 50,
                //fontStyle: FontStyle.italic,
                color: Colors.blue, // Set text color to white
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void WhereToGo() async {
    var sharepref = await SharedPreferences.getInstance();
    var islogin = sharepref.getBool(KEYLOGIN);

    Timer(const Duration(seconds: 2), () {
      if(islogin != null) {
        if(islogin) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const main_page()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const login_page()));
        }
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const login_page()));
      }
    });
  }
}