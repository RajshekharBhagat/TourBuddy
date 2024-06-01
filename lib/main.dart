import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:partial_tourbuddy/forget_password.dart';
import 'package:partial_tourbuddy/login_page.dart';
import 'package:partial_tourbuddy/main_page.dart';
import 'package:partial_tourbuddy/pages/home_page.dart';
import 'package:partial_tourbuddy/pages/splash_screen.dart';
import 'package:partial_tourbuddy/register_page.dart';

void main()async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    initialRoute:'splash',
    routes: {
      'register':(context)=>const register_page(),
      'login': (context)=>const login_page(),
      'home':(context)=> const home_page(),
      'main':(context)=>const main_page(),
      'forgot_password':(context)=>const forgot_password(),
      // 'show_detail':(context)=>const show_detail(),
      'splash':(context)=> SplashScreen()
    },
  ));
}
// class User{
//   String id;
//   final String name;
//   final String email;
//   final String password;
//
//   User({
//     this.id='',
//     required this.name,
//     required this.email,
//     required this.password,
//   });
//   Map<String,dynamic>toJson() => {
//     'id':id,
//     'name':name,
//     'email':email,
//     'password':password,
//   };
//
// }