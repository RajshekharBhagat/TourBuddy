import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../Reward Module/reword_page.dart';

class QuestPage extends StatefulWidget {
  const QuestPage({Key? key}) : super(key: key);

  @override
  _QuestPageState createState() => _QuestPageState();
}

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
Set<Marker> _markers = Set<Marker>();
Set<Circle> _circles = Set<Circle>();   

class _QuestPageState extends State<QuestPage> {
  GoogleMapController? mapController;
  int _userCoins = 0;
  List<Marker> markersInsideCircle = [];
  bool showMarkersInsideCircle = true;
  bool rewardClaimed = false;

  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(19.074800, 72.885600),
    zoom: 14.0,
  );

  List<Map<String, double>> latLongList = [];

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude),
          ),
        );
      });

      _updateCircle(LatLng(position.latitude,
          position.longitude)); // Update circle with user's location

      _checkMarkersProximity(
          position.latitude, position.longitude); // Check proximity to markers

      printRealtimeData(_databaseReference);
    } catch (e) {
      setState(() {
        "Error getting location: $e";
      });
    }
  }

  Future<void> _checkAndRequestLocationPermission() async {
    var status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      _getCurrentLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission denied'),
        ),
      );
    }
  }


  void printRealtimeData(DatabaseReference reference) {
    reference
        .child("cities")
        .onValue
        .listen((event) {
      DataSnapshot snapshot = event.snapshot;
      final dynamic value = snapshot.value;
      if (value != null) {
        final cities = Map<String, dynamic>.from(value);

        cities.forEach((cityKey, cityData) {
          final places = Map<String, dynamic>.from(cityData['Places']);

          places.forEach((placeKey, placeData) {
            final dynamic latValue = placeData['lat'];
            final dynamic longValue = placeData['long'];

            if (latValue != null && longValue != null) {
              double lat = latValue is double
                  ? latValue
                  : double.tryParse(latValue.toString()) ?? 0.0;
              double long = longValue is double
                  ? longValue
                  : double.tryParse(longValue.toString()) ?? 0.0;

              latLongList.add({'latitude': lat, 'longitude': long});
            } else {
              print('Lat/Long data is missing under $cityKey/$placeKey');
            }
          });
        });
        _addMarkers(latLongList);
      } else {
        print('Data is null');
      }
    }, onError: (error) {
      print('Error: $error');
    });
  }


  Future<List<String>> getPlaceNames(double latitude, double longitude) async {
    List<String> placeNames = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Places')
        .where('lat', isEqualTo: latitude)
        .where('long', isEqualTo: longitude)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (DocumentSnapshot doc in querySnapshot.docs) {
        String placeName = doc['pname'];
        placeNames.add(placeName);
        print(placeName);
      }
    }
    return placeNames;
  }


  void _addMarkers(List<Map<String, double>> points) async {
    Set<Marker> markers = Set<Marker>();

    for (final point in points) {
      double latitude = point['latitude']!;
      double longitude = point['longitude']!;
      Marker marker = Marker(
        markerId: MarkerId("$latitude-$longitude"),
        position: LatLng(latitude, longitude),

        icon: BitmapDescriptor.defaultMarker, // Default marker color
      );

      markers.add(marker);
    }

    setState(() {
      _markers = markers;
    });
  }

  void _updateCircle(LatLng center) {
    setState(() {
      _circles.clear(); // Clear existing circles
      _circles.add(
        Circle(
          circleId: const CircleId("userCircle"),
          center: center,
          radius: 3000,
          fillColor:
          Colors.yellowAccent.withOpacity(0.5),
          strokeWidth: 0,
        ),
      );
      _circles.add(
        Circle(
          circleId: const CircleId("invisibleCircle"),
          center: center,
          radius: 200,

          fillColor: Colors.black,
          strokeWidth: 0,
        ),
      );
    });
  }


  void _addPoints() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rewardClaimed', true);
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userSnapshot.exists) {
        FirebaseFirestore.instance.collection('users').doc(uid).update({
          'points': FieldValue.increment(100),
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
  void _checkMarkersProximity(double userLat, double userLong) {
    List<Marker> insideMarkers = [];
    for (Marker marker in _markers) {
      double markerLat = marker.position.latitude;
      double markerLong = marker.position.longitude;


      if (_isInsideCircle(userLat, userLong, markerLat, markerLong, 200)) {
        // If the marker is inside the invisible circle,
        print("Marker inside 200m circle - Lat: $markerLat, Long: $markerLong");
        insideMarkers.add(marker);

      }else if (_isInsideCircle(userLat, userLong, markerLat, markerLong, 3000)) {
        // If the marker is inside the circle
        print(
            "Marker inside 3000m circle - Lat: $markerLat, Long: $markerLong");
        insideMarkers.add(marker);
      } else {
        // Otherwise
        print(
            "Marker outside both circles - Lat: $markerLat, Long: $markerLong");
      }
    }
    setState(() {
      markersInsideCircle = insideMarkers;
    });
  }

  bool _isInsideCircle(double userLat, double userLong, double markerLat,
      double markerLong, double radius) {
    double distance = Geolocator.distanceBetween(
        userLat, userLong, markerLat, markerLong);
    return distance <= radius;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("Map Controller: ${mapController != null}");
  }

  Future<void> _fetchUserCoins() async {
    FirebaseAuth auth = FirebaseAuth.instance;

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

  void _checkMarkersProximityOnInit() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _checkMarkersProximity(position.latitude, position.longitude);
    }).catchError((e) {
      print("Error getting location: $e");
    });
  }

  void _addMarkersToMap() {
    // Call your method to fetch and add markers here
    // For example:
    _addMarkers(latLongList);
  }
  void _loadRewardClaimed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rewardClaimed = prefs.getBool('rewardClaimed') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserCoins();
    _checkAndRequestLocationPermission();
    _addMarkersToMap();
    _checkMarkersProximityOnInit();
    printRealtimeData(_databaseReference);
    _loadRewardClaimed();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        title: const Text("Quest Page"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const reward_page()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/coin_png.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  child: FutureBuilder(
                    future: _fetchUserCoins(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Text('$_userCoins');
                      } else {
                        return Text(_userCoins.toString());
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),

      body: SlidingUpPanel(
        minHeight: 50,
        maxHeight: 350,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        panelBuilder: (scrollController) => _SlidePanel(scrollController),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
              initialCameraPosition: initialCameraPosition,
              myLocationEnabled: true,
              mapType: MapType.hybrid,
              markers: showMarkersInsideCircle
                  ? markersInsideCircle.toSet()
                  : _markers,
              circles: _circles, // Add circles to the map
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showMarkersInsideCircle = !showMarkersInsideCircle;
          });
        },

        child: Icon(showMarkersInsideCircle ? Icons.visibility : Icons.visibility_off),
      ),
    );
  }

  Widget _SlidePanel(ScrollController scrollController) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Colors.blue[100],
      ),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black54,
            ),
            width: 60,
            height: 5,
          ),
          const Text(
            "Quests",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Display markers inside the circle
          Expanded(
            child: ListView.builder(
              itemCount: markersInsideCircle.length,
              itemBuilder: (context, index) {
                Marker marker = markersInsideCircle[index];
                return Container(
                  width: double.infinity,
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  padding: const EdgeInsets.all(5),
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
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                            'Lat: ${marker.position.latitude},Long: ${marker.position.longitude}'
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            // Check if the reward has already been claimed
                            if (!rewardClaimed) {
                              double userLat, userLong;
                              Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
                                  .then((Position position) {
                                userLat = position.latitude;
                                userLong = position.longitude;
                                if (_isInsideCircle(userLat, userLong, marker.position.latitude, marker.position.longitude, 2000)) {
                                  _addPoints(); // Add points if the user is within 2000 meters of the marker
                                  // Set rewardClaimed to true to indicate that the reward has been claimed
                                  setState(() {
                                    rewardClaimed = true;
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Please visit the location first!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                    fontSize: 16.0,
                                  );
                                }
                              }).catchError((e) {
                                print("Error getting location: $e");
                              });
                            } else {
                              Fluttertoast.showToast(
                                msg: "Reward already claimed!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 16.0,
                              );
                            }
                          },

                          child: const Text('Claim'),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}