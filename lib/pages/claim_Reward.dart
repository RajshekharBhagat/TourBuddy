import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class claim_Reward extends StatefulWidget {
  const claim_Reward({Key? key}) : super(key: key);

  @override
  State<claim_Reward> createState() => _ClaimRewardState();
}

class _ClaimRewardState extends State<claim_Reward> with WidgetsBindingObserver {
  late Timer _timer;
  late DateTime _nextRewardTime;
  bool _canClaim = false;
  int _userCoins = 0;
  Duration _remainingTime = Duration.zero;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    await _initSharedPreferences();
    WidgetsBinding.instance?.addObserver(this);
    _timer = Timer(Duration.zero, () {}); // Initialize the timer
    _initializeTimer();
    _loadTimer();
    _checkClaimStatus();
    _fetchUserCoins();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _saveClaimStatus();
    _saveTimer();
    super.dispose();
  }

  void _initializeTimer() async {
    int nextRewardTimeMillis = _prefs.getInt('next_reward_time') ?? 0;
    _nextRewardTime = DateTime.fromMicrosecondsSinceEpoch(nextRewardTimeMillis);

    if (_nextRewardTime.isAfter(DateTime.now())) {
      _loadTimer();
      setState(() {
        _canClaim = false;
      });
    } else {
      setState(() {
        _canClaim = true;
      });
    }
  }

  void _startTimer(Duration duration) {
    _remainingTime = duration;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds:1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime -= const Duration(seconds: 0);
          _saveTimer();
        } else {
          _timer?.cancel();
          _canClaim = true;
        }
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _saveTimer();
    } else if (state == AppLifecycleState.resumed) {
      _loadTimer();
    }
  }

  Future<void> _checkClaimStatus() async {
    bool pointsClaimed = _prefs.getBool('points_claimed') ?? false;
    setState(() {
      _canClaim = !pointsClaimed;
    });
  }

  Future<void> _claimReward() async {
    _prefs.setBool('points_claimed', true);
    _startTimer(const Duration(hours: 12));
    _addPoints();
    setState(() {
      _canClaim = false;
    });
  }

  void _addPoints() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userSnapshot.exists) {
        FirebaseFirestore.instance.collection('users').doc(uid).update({
          'points': FieldValue.increment(50),
        }).then((_) {
          print('Points added successfully');
          _fetchUserCoins();
        }).catchError((error) {
          print('Failed to add points: $error');
        });
      } else {
        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'points': 500,
        }).then((_) {
          print('User document created with initial points');
          _fetchUserCoins();
        }).catchError((error) {
          print('Failed to create user document: $error');
        });
      }
    } else {
      print('User not authenticated.');
    }
  }

  Future<void> _saveClaimStatus() async {
    _prefs.setInt('next_reward_time', _nextRewardTime.millisecondsSinceEpoch);
  }

  void _resetClaimStatus() async {
    _prefs.setBool('points_claimed', false);
    _startTimer(const Duration(minutes:1));
    setState(() {
      _canClaim = true;
    });
  }

  void _saveTimer() {
    _prefs.setInt('remaining_time', _remainingTime.inSeconds);
    _prefs.setInt('timer_start_time', DateTime.now().millisecondsSinceEpoch);
  }

  void _loadTimer() {
    int remainingTimeSeconds = _prefs.getInt('remaining_time') ?? 0;
    int timerStartTimeMillis = _prefs.getInt('timer_start_time') ?? 0;
    if (remainingTimeSeconds > 0 && timerStartTimeMillis > 0) {
      DateTime startTime = DateTime.fromMillisecondsSinceEpoch(timerStartTimeMillis);
      Duration elapsed = DateTime.now().difference(startTime);
      Duration remaining = Duration(seconds: remainingTimeSeconds) - elapsed;
      if (remaining > Duration.zero) {
        _startTimer(remaining);
      }
    }
  }

  Future<void> _fetchUserCoins() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        _userCoins = userSnapshot['points'] ?? 0;
      });
    } else {
      print('User not authenticated.');
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadTimer();
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor:Colors.blue[100],
        title: const Text(
          "Daily Rewards",
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height:20,),
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color:Color(0xFF90CAF9),//Color(0xFFBEBEBE),
                    offset: Offset(10,10),
                    blurRadius:10,
                    spreadRadius: 0.1,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-5, -5),
                    blurRadius: 10,
                    spreadRadius: 0.5,
                  ),
                ],
                image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/coin_png.png')
                )
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                '$_userCoins',
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
              width: double.infinity,
              height: 100,
              margin: const EdgeInsets.all(10),
              decoration:BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue[200],
                boxShadow: const [
                  BoxShadow(
                    color:Color(0xFF90CAF9),//Color(0xFFBEBEBE),
                    offset: Offset(10,10),
                    blurRadius:10,
                    spreadRadius: 0.1,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-5, -5),
                    blurRadius: 10,
                    spreadRadius: 0.5,
                  ),
                ],
              ),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin:const EdgeInsets.symmetric(horizontal: 10),
                    child:Text(
                      _canClaim ? "Daily Reward" : "${_remainingTime.inHours}:${_remainingTime.inMinutes%60}:${_remainingTime.inSeconds % 60}",
                      style: TextStyle(
                          fontSize: _canClaim ? 20 : 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child:Opacity(
                        opacity: _canClaim ? 1.0 : 0.5,
                        child:ElevatedButton(
                          onPressed: _canClaim ? _claimReward : null,
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0), // Adjust the value to make it more circular
                              ),
                            ),
                            elevation: MaterialStateProperty.all(4), // Adjust the elevation value as needed
                            shadowColor: MaterialStateProperty.all(Colors.white), // Adjust shadow color as needed
                          ),
                          child: Container(
                            width: 90, // Adjust width as needed
                            height: 50, // Adjust height as needed
                            alignment: Alignment.center,
                            child: const Text(
                              'CLAIM',
                              style: TextStyle(fontSize: 18), // Adjust font size as needed
                            ),
                          ),
                        )
                    ),
                  ),
                ],
              )
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _resetClaimStatus,
            child: const Text('Reset Claim Status'),
          ),
        ],
      ),
    );
  }
}