import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:partial_tourbuddy/Reward%20Module/reward_model.dart';
import 'package:partial_tourbuddy/Reward%20Module/reword_detail_page.dart';

import 'leaderboard_page.dart';
class reward_page extends StatefulWidget {
  const reward_page({super.key});
  @override
  State<reward_page> createState() => _reward_pageState();
}
class _reward_pageState extends State<reward_page> {

  int _userCoins = 0;
  List<String> claimedRewards = [];

  Future<void> _fetchClaimedRewards() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      List<dynamic> claimed = userSnapshot['claimedRewards'];
      setState(() {
        claimedRewards = List<String>.from(claimed);
      });
    }
  }

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserCoins();
    _fetchClaimedRewards();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        automaticallyImplyLeading: true,
        title: Text("Rewards"),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue.shade200)
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => leaderboard_page()));
            },
            child:Row(
              children: [
                Icon(Icons.leaderboard),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Text("Leaderboard"),
                ),
              ],
            )
          ),
        ],
      ),
      body:Column(
        children: [
          SizedBox(height: 50,),
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  const BoxShadow(
                    color:Color(0xFF90CAF9),//Color(0xFFBEBEBE),
                    offset: Offset(10,10),
                    blurRadius:10,
                    spreadRadius: 0.1,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-5, -5),
                    blurRadius: 10,
                    spreadRadius: 0.5,
                  ),
                ],
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/coin_png.png')
              )
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                  '$_userCoins',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          SizedBox(height:50,),
          // Expanded(
          //   child: ListView.builder(
          //       itemCount: Reward.Rewards.length,
          //       itemBuilder: (context, index) {
          //         return Opacity(
          //           opacity: Reward.Rewards[index].claimed == false ? 1.0 : 0.2,
          //           child: Container(
          //             margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(20),
          //               color:int.parse(Reward.Rewards[index].reqPoints) > _userCoins ? Colors.red[200]: Colors.blue[200],
          //               boxShadow: [
          //                 const BoxShadow(
          //                   color:Color(0xFF90CAF9),//Color(0xFFBEBEBE),
          //                   offset: Offset(10,10),
          //                   blurRadius:10,
          //                   spreadRadius: 0.1,
          //                 ),
          //                 const BoxShadow(
          //                   color: Colors.white,
          //                   offset: Offset(-5, -5),
          //                   blurRadius: 10,
          //                   spreadRadius: 0.5,
          //                 ),
          //               ],
          //             ),
          //             child: ListTile(
          //                 title: Text(
          //                     Reward.Rewards[index].name,
          //                   style: TextStyle(
          //                     fontSize: 20
          //                   ),
          //                 ),
          //                 subtitle: Text('${Reward.Rewards[index].reqPoints} points'),
          //                 onTap: () {
          //                   if(int.parse(Reward.Rewards[index].reqPoints) > _userCoins){
          //                     Fluttertoast.showToast(
          //                       msg: "Insufficient Points",
          //                       toastLength: Toast.LENGTH_SHORT,
          //                       gravity: ToastGravity.BOTTOM,
          //                       timeInSecForIosWeb: 2,
          //                       backgroundColor: Colors.white,
          //                       textColor: Colors.black,
          //                       fontSize: 16.0,
          //                       webShowClose: false,
          //                     );
          //                   }
          //                   else if(Reward.Rewards[index].claimed == true){
          //                     Fluttertoast.showToast(
          //                       msg: "Already Claimed",
          //                       toastLength: Toast.LENGTH_SHORT,
          //                       gravity: ToastGravity.BOTTOM,
          //                       timeInSecForIosWeb: 2,
          //                       backgroundColor: Colors.white,
          //                       textColor: Colors.black,
          //                       fontSize: 16.0,
          //                       webShowClose: false,
          //                     );
          //                   }
          //                   else if(int.parse(Reward.Rewards[index].reqPoints) <= _userCoins && Reward.Rewards[index].claimed == false){
          //                     Navigator.push(context, MaterialPageRoute(builder: (context)=>
          //                         reward_detail_page(rewardName: Reward.Rewards[index].name,rewardDesc:Reward.Rewards[index].description, rewardPoints: int.parse(Reward.Rewards[index].reqPoints),claimed: Reward.Rewards[index].claimed,)));
          //                   }
          //                 }
          //             ),
          //           ),
          //         );
          //       }
          //   ),
          // )
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Rewards').snapshots(),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting)
                    {
                      return Center(child:CircularProgressIndicator());
                    }
                  List<Reward> rewards = [];
                  snapshot.data!.docs.forEach((doc) {
                    rewards.add(Reward(
                      name: doc['name'],
                      description: doc['desc'],
                      reqPoints: doc['reqPoints'].toString(),
                      claimed: doc['status']
                    ));
                  });
                  return ListView.builder(
                      itemCount: rewards.length,
                      itemBuilder: (context,index){
                        bool isClaimed = claimedRewards.contains(rewards[index].name);
                        return Opacity(
                          opacity:isClaimed ? 0.2 : 1.0,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: int.parse(rewards[index].reqPoints) > _userCoins
                                  ? Colors.red[200]
                                  : Colors.blue[200],
                              boxShadow: [
                                const BoxShadow(
                                  color: Color(0xFF90CAF9),
                                  offset: Offset(10, 10),
                                  blurRadius: 10,
                                  spreadRadius: 0.1,
                                ),
                                const BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-5, -5),
                                  blurRadius: 10,
                                  spreadRadius: 0.5,
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                rewards[index].name,
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Text('${rewards[index].reqPoints} points'),
                              onTap: () {
                                bool isClaimed = claimedRewards.contains(rewards[index].name);
                                if (int.parse(rewards[index].reqPoints)  > _userCoins) {
                                  Fluttertoast.showToast(
                                    msg: "Insufficient Points",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                    fontSize: 16.0,
                                    webShowClose: false,
                                  );
                                } else if (isClaimed == true) {
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
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => reward_detail_page(
                                        rewardName: rewards[index].name,
                                        rewardDesc: rewards[index].description,
                                        rewardPoints: int.parse(rewards[index].reqPoints),
                                        claimed: isClaimed, // Pass the boolean value indicating if reward is claimed
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                  );
                },
            ),
          )
        ],
      )
    );
  }
}

