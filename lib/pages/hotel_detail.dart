import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class hotel_detail extends StatefulWidget {
  final Map<String, dynamic> hotelDetails;
  hotel_detail({Key? key, required this.hotelDetails}) : super(key: key);
  @override
  State<hotel_detail> createState() => _hotel_detailState();
}

class _hotel_detailState extends State<hotel_detail> {
  FirebaseFirestore databaseInstance = FirebaseFirestore.instance;

  void _launchDirections(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation:FloatingActionButtonLocation.miniEndTop ,
        floatingActionButton:LikeButton(hotelDetails: widget.hotelDetails),
      extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.blue[100],
        body:SingleChildScrollView(
          scrollDirection: Axis.vertical,
              child: Column(
              children: [
                // SizedBox(height:,),
                Container(
                  margin: const EdgeInsets.all(5),
                  width: double.infinity,
                  height: 400,
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(widget.hotelDetails['himg'].toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height:5),
                Container(
                  margin:EdgeInsets.symmetric(horizontal:10),
                  width: double.infinity,
                  height:70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width:300,
                        child: Text(
                          widget.hotelDetails['hname'] ?? 'N/A',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                              Icons.star,
                          ),
                          Text("${widget.hotelDetails['rating']}",style: const TextStyle(fontSize: 18))
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue[200],
                  ),
                  child: SingleChildScrollView( // Wrap your Column with SingleChildScrollView
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Detail", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "${widget.hotelDetails['hdesc']}" ?? "N/A",
                            overflow: TextOverflow.visible , // Allow text to wrap to multiple lines
                            maxLines: null, // Set maxLines to null for unlimited lines
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin:EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  height:100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue[200],
                  ),
                  child:Column(
                    children: [
                      Text("Address:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                      Text("${widget.hotelDetails['hadd']}"??'N/A'),
                    ],
                  )
                ),
                Container(
                  width:double.infinity,
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          width:150,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all<double>(5), // Add elevation for shadow effect
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent)
                            ),
                            onPressed: () async {
                              String hotelName = Uri.encodeComponent(widget.hotelDetails['hname']);
                              String bookingURL = 'https://www.booking.com/searchresults.html?ss=$hotelName';

                              try {
                                await launch(bookingURL, forceWebView: false);
                              } catch (e) {
                                print('Error launching URL: $e');
                              }
                            },
                            child:Text("Booking"),
                          ),
                      ),
                  Container(
                      width:150,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () async {
                            // Get the destination latitude and longitude
                            double destinationLat = widget.hotelDetails['lat'];
                            double destinationLong = widget.hotelDetails['long'];

                            // Construct the URL for launching Google Maps with directions
                            final url = 'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLong';

                            // Check if the URL can be launched
                            if (await canLaunch(url)) {
                              // Launch Google Maps with directions
                              await launch(url);
                            } else {
                              // Handle the case where the URL cannot be launched
                              throw 'Could not launch $url';
                            }
                          },

                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(5), // Add elevation for shadow effect
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.yellowAccent)
                          ),
                          child:Text("Direction")
                      ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        );
    }
}
class LikeButton extends StatefulWidget {
  final Map<String, dynamic> hotelDetails;

  LikeButton({Key? key, required this.hotelDetails}) : super(key: key);
  @override
  _LikeButtonState createState() => _LikeButtonState();
}
class _LikeButtonState extends State<LikeButton> {
  FirebaseFirestore databaseInstance = FirebaseFirestore.instance;
  bool isLiked = false;
  void onPressed() {
    setState(() {
      isLiked = !isLiked;
    });
    if (isLiked) {
      addFavHotel(widget.hotelDetails);
    } else {
      removeFavHotel(widget.hotelDetails);
    }
  }
  Future<void> addFavHotel(Map<String, dynamic> hotelDetails) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      await databaseInstance.collection('Favourite').doc(uid).collection('favHotels').add({
        'img': hotelDetails['himg'],
        'name': hotelDetails['hname'],
        'rating': hotelDetails['rating'],
        'add': hotelDetails['hadd'],
        'desc': hotelDetails['hdesc'],
        'lat': hotelDetails['lat']?? 'N/A',
        'long': hotelDetails['long'],
      });
      print('hotel added successfully');
    }
  }
  Future<void> removeFavHotel(Map<String, dynamic> hotelDetails) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      QuerySnapshot<Map<String, dynamic>> snapshot = await databaseInstance
          .collection('Favourite')
          .doc(uid)
          .collection('favHotels')
          .where('name', isEqualTo: widget.hotelDetails['hname'])
          .get() as QuerySnapshot<Map<String, dynamic>>;
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.first.reference.delete();
        print('hotel removed successfully');
      }
    }
  }
  Future<void> checkLikedStatus() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      QuerySnapshot<Map<String, dynamic>> snapshot = await databaseInstance
          .collection('Favourite')
          .doc(uid)
          .collection('favHotels')
          .where('name', isEqualTo: widget.hotelDetails['hname'])
          .get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          isLiked = true;
        });
      }
      else
        {
          isLiked = false;
        }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLikedStatus();
  }
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      child: Icon(
        Icons.favorite,
        color: isLiked ? Colors.red : Colors.white,
      ),
    );
  }
}