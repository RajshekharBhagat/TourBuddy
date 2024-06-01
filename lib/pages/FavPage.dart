import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:partial_tourbuddy/pages/fav_detail_page.dart';
import 'package:partial_tourbuddy/pages/hotel_detail.dart';
import 'package:partial_tourbuddy/pages/places_detail.dart';

class favPage extends StatefulWidget {
   favPage({super.key});

  @override
  State<favPage> createState() => _favPageState();
}

class _favPageState extends State<favPage> {
int _currentIndex = 0;
late String uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserUid();
  }
void fetchUserUid() {
  FirebaseAuth auth = FirebaseAuth.instance;
  if (auth.currentUser != null) {
    uid = auth.currentUser!.uid;
    print('User UID: $uid');
  } else {
    print('User not authenticated.');
  }
}
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text("Favourites",style: TextStyle(fontSize:24,color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height:10,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 3),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(20),
                renderBorder:false,
                selectedColor: Colors.blueGrey[100],
                isSelected: [_currentIndex == 0, _currentIndex == 1],
                onPressed: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children:[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal:50),
                    child: const Text("Places",style: TextStyle(color: Colors.black,fontSize:16),),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal:50),
                    child: const Text("Hotels",style: TextStyle(color: Colors.black,fontSize: 16),),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _currentIndex == 0
                  ? _buildPlacesContent()
                  : _buildHotelsContent(),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildPlacesContent() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('Favourite').doc(uid).collection('favPlaces').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            "No Favorite Places Available",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        );
      } else {
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> placeData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
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
                ],
              ),
              child: TextButton(
                onPressed: () {
                  Map<String, dynamic> placeMap = {
                    'pimg': placeData['img'] ?? 'N/A',
                    'pname': placeData['name'] ?? 'N/A',
                    'prating': placeData['rating'] ?? 'N/A',
                    'padd': placeData['add'] ?? 'N/A',
                    'pdesc': placeData['desc'] ?? 'N/A',
                    'lat': placeData['lat'] ?? 'N/A',
                    'long': placeData['long'] ?? 'N/A',
                  };
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => places_detail(placeDetails: placeMap),
                    ),
                  );
                },
                // onPressed:(){
                //   Navigator.push(context, MaterialPageRoute(builder: (context)=>favDetail(favPlaceDetail: Map<String,dynamic>.from(placeData))));
                // },
                child: Text(
                  placeData['name'],
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          },
        );
      }
    },
  );
}
  Widget _buildHotelsContent() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Favourite').doc(uid).collection('favHotels').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              "No Favorite Hotels Available",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> hotelData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
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
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    // Convert Place object to Map<String, dynamic>
                    Map<String, dynamic> hotelMap = {
                      'himg': hotelData['img'] ?? 'N/A',
                      'hname': hotelData['name'] ?? 'N/A',
                      'rating': hotelData['rating'] ?? 'N/A',
                      'hadd': hotelData['add'] ?? 'N/A',
                      'hdesc': hotelData['desc'] ?? 'N/A',
                      'lat': hotelData['lat'] ?? 'N/A',
                      'long': hotelData['long'] ?? 'N/A',
                    };
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => hotel_detail(hotelDetails: hotelMap),
                      ),
                    );
                  },
                  child: Text(
                      hotelData['name'],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
