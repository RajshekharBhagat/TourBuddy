import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class places_detail extends StatefulWidget {
  final Map<String, dynamic> placeDetails;
  places_detail({Key? key, required this.placeDetails}) : super(key: key);
  @override
  State<places_detail> createState() => _places_detailState();
}

class _places_detailState extends State<places_detail> {
  FirebaseFirestore databaseInstance = FirebaseFirestore.instance;

  void _launchDirections(String placeName) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$placeName';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch$url';
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
        floatingActionButton:LikeButton(placeDetails: widget.placeDetails),
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
                    image: NetworkImage(widget.placeDetails['pimg'].toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height:5),
              Container(
                margin:const EdgeInsets.symmetric(horizontal:10),
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
                        widget.placeDetails['pname'] ?? 'N/A',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.star,
                        ),
                        Text("${widget.placeDetails['prating']}",style: const TextStyle(fontSize: 18))
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue[200],
                ),
                child: SingleChildScrollView( // Wrap your Column with SingleChildScrollView
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Detail", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "${widget.placeDetails['pdesc']}" ?? "N/A",
                          overflow: TextOverflow.visible ,
                          maxLines: null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  margin:const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  width: double.infinity,
                  height:100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue[200],
                  ),
                  child:Column(
                    children: [
                      const Text("Address:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                      Text("${widget.placeDetails['padd']}"??'N/A'),
                    ],
                  )
              ),
              Container(
                width:double.infinity,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width:150,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _launchDirections(widget.placeDetails['pname']);
                          },
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(5),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.yellowAccent)
                          ),
                          child: const Text('Direction'),
                          )
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
  final Map<String, dynamic> placeDetails;

  LikeButton({Key? key, required this.placeDetails}) : super(key: key);
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
      addFavPlaces(widget.placeDetails);
    } else {
      removeFavPlaces(widget.placeDetails);
    }
  }
  Future<void> addFavPlaces(Map<String, dynamic> placeDetails) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      await databaseInstance.collection('Favourite').doc(uid).collection('favPlaces').add({
        'img':placeDetails['pimg'],
        'name':placeDetails['pname'],
        'rating':placeDetails['prating'],
        'add': placeDetails['padd'],
        'desc': placeDetails['pdesc'],
        'lat': placeDetails['lat']?? 'N/A',
        'long': placeDetails['long'],
      });
      print('place added successfully');
    }
  }
  Future<void> removeFavPlaces(Map<String, dynamic> placeDetails) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      QuerySnapshot<Map<String, dynamic>> snapshot = await databaseInstance
          .collection('Favourite')
          .doc(uid)
          .collection('favPlaces')
          .where('name', isEqualTo: widget.placeDetails['pname'])
          .get() as QuerySnapshot<Map<String, dynamic>>;
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.first.reference.delete();
        print('place removed successfully');
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
          .collection('favPlaces')
          .where('name', isEqualTo: widget.placeDetails['pname'])
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
  