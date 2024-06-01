import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:partial_tourbuddy/Reward%20Module/reward_model.dart';

class reward_detail_page extends StatefulWidget {
  final String rewardName;
  final String rewardDesc;
  final int rewardPoints;
  final bool claimed;
  const reward_detail_page({
    Key? key,
    required this.rewardName,
    required this.rewardDesc,
    required this.rewardPoints,
    required this.claimed
  }) : super(key: key);
  @override
  State<reward_detail_page> createState() => _reward_detail_pageState();
}
class _reward_detail_pageState extends State<reward_detail_page> {
  static String couponCode = 'Click to get coupon code';
  bool isRewardClaimed = false;
  int _userCoins = 0;

  Future<bool> checkRewardClaimStatus(String rewardName) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      List<dynamic> claimedRewards = userSnapshot['claimedRewards'];
      return claimedRewards.contains(rewardName);
    } else {
      return false;
    }
  }


  Future<void> _fetchUserCoins() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore _instance = FirebaseFirestore.instance;

    if (auth.currentUser != null) {

      String uid = auth.currentUser!.uid;
      DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        _userCoins = userSnapshot['points'] ?? 0;
      });
    } else {
      print('User not authenticated.');
    }
  }

  // Future<void> addClaimedReward(String rewardName) async{
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   if(auth.currentUser != null){
  //     String uid = auth.currentUser!.uid;
  //     DocumentReference userDocRef =  FirebaseFirestore.instance.collection('users').doc(uid);
  //
  //     DocumentSnapshot userSnapshot = await userDocRef.get();
  //     List<dynamic> claimedRewards = userSnapshot['claimedRewards'];
  //     claimedRewards.add(rewardName);
  //     await userDocRef.set({'claimedRewards': claimedRewards},SetOptions(merge: true));
  //   } else{
  //     print('user not found');
  //   }
  // }
  Future<void> addClaimedReward(String rewardName) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? currentUser = auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;
        DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(uid);

        DocumentSnapshot userSnapshot = await userDocRef.get();

        // Check if claimedRewards field exists, if not, initialize it as an empty list
        Map<String, dynamic>? data = userSnapshot.data() as Map<String, dynamic>?;

        if (!userSnapshot.exists || data == null || data['claimedRewards'] == null) {
          await userDocRef.set({'claimedRewards': []}, SetOptions(merge: true));
        }

        List<dynamic> claimedRewards =
        List<dynamic>.from(data!['claimedRewards'] ?? []);

        claimedRewards.add(rewardName);

        await userDocRef.set(
          {'claimedRewards': claimedRewards},
          SetOptions(merge: true),
        );
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error adding claimed reward: $e');
      // Handle the error appropriately, such as logging or displaying an error message
    }
  }

  Future<void> updateUserCoins(int point)async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if(auth.currentUser != null){
      String uid = auth.currentUser!.uid;
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      try{
        await userRef.update({'points':point});
        setState(() {
          _userCoins = point;
        });
      } catch(e){
        print("Cannot update the usercoint ${e}");
      }
    }
    else{
      print('user is not fount');
    }
  }

  void generateCouponCode() {
    if(widget.claimed == true)
      {
        Fluttertoast.showToast(
          msg: "Already Claimed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
          webShowClose: false,
        );
      }
    else{
      int codeLength = 10;
      String characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      Random random = Random();
      String code = '';

      for (int i = 0; i < codeLength; i++) {
        int randomIndex = random.nextInt(characters.length);
        code += characters[randomIndex];
      }
      setState(() {
        couponCode = code;
        int index = Reward.Rewards.indexWhere((reward) => reward.name == widget.rewardName);
        if(index != -1){
          Reward.Rewards[index].changeClaim(true, index);
        }
      });
      addClaimedReward(widget.rewardName);
      int updatedPoints = _userCoins - widget.rewardPoints;
      updateUserCoins(updatedPoints);
      Fluttertoast.showToast(
        msg: "Reward Claimed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0,
        webShowClose: false,
      );
    }
  }
  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: couponCode));
    Fluttertoast.showToast(
      msg: "Copied to clipboard",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
      webShowClose: false,
    );
  }
  Future<void> _checkRewardStatus() async {
    bool claimed = await checkRewardClaimStatus(widget.rewardName);
    setState(() {
      isRewardClaimed = claimed;
      if(isRewardClaimed){
        couponCode = "Already Claimed";
      }
      else{
        couponCode = "Click to get code";
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserCoins();
    _checkRewardStatus();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Details',style: TextStyle(fontSize:18),),
        backgroundColor: Colors.blue[100],
      ),
      body: Container(
        color: Colors.blue[100],
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue[200],
            borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFBEBEBE),
                  offset: Offset(10, 10),
                  blurRadius: 30,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-10, -10),
                  blurRadius: 30,
                  spreadRadius: 1,
                ),
              ]
          ),
          height: 350,
          width: 350,
          child: Column(
            children: [
              SizedBox(height: 20,),
              Text(
                  widget.rewardName,
                style: TextStyle(
                  fontSize:24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54
                ),
              ),
              SizedBox(height:50,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue[300],
                ),
                width:300,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin:EdgeInsets.all(5),
                      child: TextButton(
                        child: Text(couponCode),
                        onPressed: copyToClipboard,
                      ),
                    ),
                    Container(
                      margin:EdgeInsets.all(5),
                      child: ElevatedButton(
                          onPressed: isRewardClaimed ? null : generateCouponCode,
                          child:Icon(Icons.arrow_forward_ios_sharp)),
                    )
                  ],
                ),
              ),
              SizedBox(height:50,),
              Container(
                width:300,
                height: 60,
                padding:EdgeInsets.all(5),
                decoration:BoxDecoration(
                  color:Colors.blue[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child:Center(
                  child: Text(
                    widget.rewardDesc,
                  ),
                )
              )
            ],
          ),
          ),
        ),
    );
  }
}
