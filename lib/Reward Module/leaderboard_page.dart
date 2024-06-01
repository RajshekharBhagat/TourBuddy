import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class leaderboard_page extends StatefulWidget {
  const leaderboard_page({super.key});

  @override
  State<leaderboard_page> createState() => _leaderboard_pageState();
}

class _leaderboard_pageState extends State<leaderboard_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          backgroundColor: Colors.blue[100],
          automaticallyImplyLeading: true,
          title: Text("Leader Board"),
        ),
      body: Container(
        color: Colors.blue[100],
        child:StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No users found.'),
              );
            }

            // Convert QuerySnapshot to List of Documents
            List<DocumentSnapshot> users = snapshot.data!.docs;

            // Sort users based on points
            users.sort((a, b) {
              var aData = a.data() as Map<String, dynamic>; // Explicit cast
              var bData = b.data() as Map<String, dynamic>; // Explicit cast
              var aPoints = aData['points'] ?? 0;
              var bPoints = bData['points'] ?? 0;
              return bPoints.compareTo(aPoints);
            });

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var userData = users[index].data() as Map<String, dynamic>; // Explicit cast
                String place = ' ';

                // Identify top three users
                if (index == 0) {
                  place = '🥇';
                } else if (index == 1) {
                  place = '🥈';
                } else if (index == 2) {
                  place = '🥉';
                }
                return Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  height: 50,
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue[200],
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
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                              '$place ${userData['Name']?? 'Unknown'}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )
                      ),
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                              '${userData['points'] ?? 0}',
                            style: TextStyle(
                              fontSize: 18
                            ),
                          )
                      ),

                    ],
                  ),
                );
                // return ListTile(
                //   title: Text('$place ${userData['Name'] ?? 'Unknown'}'),
                //   subtitle: Text('Points: ${userData['points'] ?? 0}'),
                //);
              },
            );
          },
        ),
      ),
    );
  }
}