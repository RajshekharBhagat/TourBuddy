import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:partial_tourbuddy/Reward%20Module/leaderboard_page.dart';
import 'package:partial_tourbuddy/Reward%20Module/reword_page.dart';
import 'package:partial_tourbuddy/pages/claim_Reward.dart';
import 'package:partial_tourbuddy/pages/profile_page.dart';
import 'package:partial_tourbuddy/pages/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login_page.dart';

class myHeaderDrawer extends StatefulWidget {
  const myHeaderDrawer({super.key});

  @override
  State<myHeaderDrawer> createState() => _myHeaderDrawerState();
}

class _myHeaderDrawerState extends State<myHeaderDrawer> {
  String _username = "Unknown User";

  void fetchUsername() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (doc.exists) {
        setState(() {
          _username = doc['Name'];
        });
      } else {
        print('no user found');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUsername();
  }
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20)
        ),
        color: Colors.blue[100],
      ),
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(top:10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 70,
            decoration:const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/profile_icon2.png'),
              )
            ),
          ),
          Text('${_username}',style: const TextStyle(color: Colors.black87,fontSize: 20),)
        ],
      ),
    );
  }
}
class myListDrawer extends StatefulWidget {
  const myListDrawer({super.key});

  @override
  State<myListDrawer> createState() => _myListDrawerState();
}

class _myListDrawerState extends State<myListDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10,bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(20)
            ),
            child:  ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const profilePage()));
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(20)
            ),
            margin: const EdgeInsets.only(top: 10,bottom: 10),
            child:  ListTile(
              leading: const Icon(Icons.access_time_filled),
              title: const Text("Claim"),
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const claim_Reward()));
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(20)
            ),
            child: ListTile(
              leading: const Icon(Icons.flag_circle),
              title: const Text("Rewards"),
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const reward_page()));
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(20)
            ),
            margin: const EdgeInsets.only(top: 10,bottom: 10),
            child:ListTile(
              leading: const Icon(Icons.leaderboard_rounded),
              title: const Text("LeaderBoard"),
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const leaderboard_page()));
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left:90),
            child: ListTile(
              title:const Text("Logout",
              style:TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red
              )
              ),
              onTap: () async{
                var sharepref = await SharedPreferences.getInstance();
                sharepref.setBool(SplashScreenState.KEYLOGIN, false);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context)=>const login_page()));
              },
            ),
          ),
          Container(
            margin:const EdgeInsets.only(top: 230),
            width: double.infinity,
            child: const Center(
                child: Text(
                  "tourbuddy123@gmail.com",
                  style:TextStyle(fontSize:14,color:Colors.black),
              )
            ),
          )
        ],
      ),
    );
  }
}


