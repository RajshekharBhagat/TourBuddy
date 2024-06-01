import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main_page.dart';
import 'home_page.dart';

class profilePage extends StatefulWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  late TextEditingController _usernameController;


  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    fetchUserUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue[100],
      ),
      backgroundColor:Colors.blue[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue[200],
              ),
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.only(top:10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: 150,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/profile_icon2.png'),
                        )
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              padding:EdgeInsets.all(5),
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Enter your username'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                saveUsername();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>main_page()));
              },
              child: Text('Save'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  void fetchUserUid() {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      print('User UID: $uid');
    } else {
      print('User not authenticated.');
    }
  }
  void saveUsername() {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      String username = _usernameController.text;

      FirebaseFirestore.instance.collection('users').doc(uid).get().then((doc) {
        if (doc.exists) {
          // If document exists, update it with the new username
          FirebaseFirestore.instance.collection('users').doc(uid).update({
            'Name': username,
            // You can update more fields here if needed
          }).then((value) {
            Fluttertoast.showToast(
              msg: "Profile updated",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0,
            );
          }).catchError((error) {
            print('Failed to update username: $error');
          });
        } else {
          // If document doesn't exist, create a new one with the provided username
          FirebaseFirestore.instance.collection('users').doc(uid).set({
            'Name': username,
            // You can add more fields here if needed
          }).then((value) {
            Fluttertoast.showToast(
              msg: "Profile saved",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0,
            );
          }).catchError((error) {
            print('Failed to save username: $error');
          });
        }
      }).catchError((error) {
        print('Failed to check document existence: $error');
      });
    } else {
      print('User not authenticated.');
    }
  }

  // void saveUsername() {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //
  //   if (auth.currentUser != null) {
  //     String uid = auth.currentUser!.uid;
  //     String username = _usernameController.text;
  //
  //     // Access Firestore and save the username along with the UID
  //     FirebaseFirestore.instance.collection('users').doc(uid).set({
  //       'Name': username,
  //       // You can add more fields here if needed
  //     }).then((value) {
  //       Fluttertoast.showToast(
  //         msg: "Profile saved",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 2,
  //         backgroundColor: Colors.white,
  //         textColor: Colors.black,
  //         fontSize: 16.0,
  //       );
  //     }).catchError((error) {
  //       print('Failed to save username: $error');
  //     });
  //   } else {
  //     print('User not authenticated.');
  //   }
  // }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}