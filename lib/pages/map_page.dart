import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:partial_tourbuddy/pages/places_detail.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/place.dart';
import 'hotel_detail.dart';

class map_page extends StatefulWidget {
  const map_page({Key? key}) : super(key: key);

  @override
  State<map_page> createState() => _map_pageState();
}

class _map_pageState extends State<map_page> {
  final Set<Marker> _markers = {};
  Marker? _selectedMarker;
  String _markerDetails = '';
  late GoogleMapController _controller;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  final List<City> cities = [];
  List<Hotel> hotels=[];
  List<Place> places=[];
  List<Hotel> hotelResults = [];
  List<Place> placeResults = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchPlaces();
  }

  void _launchDirections(String placeName) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$placeName';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch$url';
    }
  }

  void _fetchPlaces() {
    hotels.clear();
    places.clear();
    cities.clear();
    _databaseReference.child('cities').onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final citiesData = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        citiesData.forEach((key, value) {
          if (value['Hotels'] != null) {
            final hotelsData = Map<String, dynamic>.from(value['Hotels'] as Map<dynamic, dynamic>);
            hotelsData.forEach((hotelKey, hotelValue) {
              final latitude = (hotelValue['lat'] is num)
                  ? (hotelValue['lat'] as num).toDouble()
                  : double.tryParse(hotelValue['lat']?.toString() ?? '0.0') ?? 0.0;

              final longitude = (hotelValue['long'] is num)
                  ? (hotelValue['long'] as num).toDouble()
                  : double.tryParse(hotelValue['long']?.toString() ?? '0.0') ?? 0.0;
              final rating = (hotelValue['prating'] is num)
                  ? (hotelValue['prating'] as num).toDouble()
                  : double.tryParse(hotelValue['prating']?.toString() ?? '0.0') ?? 0.0;
              final hotel = Hotel(
                image: hotelValue['himg']??'N/A',
                name: hotelValue['hname']??'N/A',
                rating: rating,
                address: hotelValue['hadd']??'N/A',
                amenity: hotelValue['hamenity']??'N/A',
                description: hotelValue['hdesc']??'N/A',
                latitude: latitude,
                longitude: longitude,
              );
              hotels.add(hotel);
            });
          }
          if (value['Places'] != null) {
            final placesData = Map<String, dynamic>.from(value['Places'] as Map<dynamic, dynamic>);
            placesData.forEach((placeKey, placeValue) {
              final latitude = (placeValue['lat'] is num)
                  ? (placeValue['lat'] as num).toDouble()
                  : double.tryParse(placeValue['lat']?.toString() ?? '0.0') ?? 0.0;

              final longitude = (placeValue['long'] is num)
                  ? (placeValue['long'] as num).toDouble()
                  : double.tryParse(placeValue['long']?.toString() ?? '0.0') ?? 0.0;

              final rating = (placeValue['prating'] is num)
                  ? (placeValue['prating'] as num).toDouble()
                  : double.tryParse(placeValue['prating']?.toString() ?? '0.0') ?? 0.0;

              final place = Place(
                image: placeValue['pimg']??'N/A',
                name: placeValue['pname']??'N/A',
                rating: rating,
                address: placeValue['padd']??'N/A',
                description: placeValue['pdesc']??'N/A',
                latitude: latitude,
                longitude: longitude,
              );
              places.add(place);
            });
          }
          final city = City(
            name: value['name'],
            imagePath: value['cimg'],
            description: value['desc'],
            hotels: hotels,
            places: places,
          );
          cities.add(city);
        });
        setState(() {}); // Refresh UI after data retrieval
      }
    }, onError: (error) {
      print("Failed to fetch places: $error");
    });
  }

  List<Hotel> _searchHotels(String query) {
    return hotels.where((hotel) =>
        hotel.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
  List<Place> _searchPlaces(String query) {
    return places.where((place) =>
        place.name.toLowerCase().contains(query.toLowerCase())).toList();
  }

  void _search(String query) {
    setState(() {
      _markers.clear();
    });
    hotelResults = _searchHotels(query);
    placeResults = _searchPlaces(query);
    for (var hotel in hotelResults) {
      _addMarker(hotel.name,LatLng(hotel.latitude, hotel.longitude));
    }
    for (var place in placeResults) {
      _addMarker(place.name,LatLng(place.latitude, place.longitude));
    }
  }
  void _addMarker(String name,LatLng latLng) {
    setState(() {
      _selectedMarker = Marker(
        markerId: MarkerId(name),
        position: latLng,
      );
      _markers.add(_selectedMarker!);
      _markerDetails =
      'Marker Details:\nLatitude:${latLng.latitude.toStringAsFixed(
          2)}\nLongitude:${latLng.longitude.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: Colors.blue[100],
      ),
      body: SlidingUpPanel(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        panelBuilder: (scrollController) => _buildPanel(scrollController),
        body: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
          // onLongPress:_addMarker(),
          mapType: MapType.hybrid,
          markers: _markers,
          onTap: (_) {
            setState(() {
              _selectedMarker = null;
            });
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(19.0760, 72.8777),
            zoom: 12.0,
          ),
        ),
      ),
    );
  }
  Widget _buildPanel(ScrollController scrollController) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.blue[100],
      ),
      padding: EdgeInsets.all(5.0),
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
          Container(
            decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color:Colors.white,
                    offset: Offset(5, 5),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ]
            ),
            margin: const EdgeInsets.all(15),
            child: TextField(
              onChanged: (value){
                _search(value);
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 14),
                hintText: "Search For Destination",
                suffixIcon: Icon(Icons.search),
                border: InputBorder.none,
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(30.0),
                //   borderSide: const BorderSide(),
                // ),
              ),
            ),
          ),
          SizedBox(height:10),
          Expanded(
              child:SingleChildScrollView(
                  child: _buildSearchResults()
              )
          ),
        ]
      ),
    );
  }
  Widget _buildSearchResults()
  {
    if (hotelResults.isNotEmpty || placeResults.isNotEmpty) {
      return Column(
        children: [
          Text(
            "Search Results:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: hotelResults.length + placeResults.length,
            itemBuilder: (context, index) {
              if (index < hotelResults.length) {
                final hotel = hotelResults[index];
                return Container(
                  width: double.infinity,
                  height: 60,
                  margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue[200],
                  ),
                  child: ListTile(
                    title: Text(hotel.name),
                    onTap: () {
                      Map<String, dynamic> hotelMap = {
                        'himg': hotel.image ?? 'N/A',
                        'hname': hotel.name ?? 'N/A',
                        'rating': hotel.rating ?? 'N/A',
                        'hadd': hotel.address ?? 'N/A',
                        'hdesc': hotel.description ?? 'N/A',
                        'lat': hotel.latitude ?? 'N/A',
                        'long': hotel.longitude ?? 'N/A',
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => hotel_detail(hotelDetails: hotelMap),
                        ),
                      );
                      // _launchDirections(hotel.name);
                    },
                  ),
                );
              } else {
                final place = placeResults[index - hotelResults.length];
                return Container(
                  width: double.infinity,
                  height: 60,
                  margin: EdgeInsets.symmetric(horizontal: 5 ,vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue[200],
                  ),
                  child: ListTile(
                    title: Text(place.name),
                    onTap: () {
                      Map<String, dynamic> placeMap = {
                        'pimg': place.image ?? 'N/A',
                        'pname': place.name ?? 'N/A',
                        'prating': place.rating ?? 'N/A',
                        'padd': place.address ?? 'N/A',
                        'pdesc': place.description ?? 'N/A',
                        'lat': place.latitude ?? 'N/A',
                        'long': place.longitude ?? 'N/A',
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => places_detail(placeDetails: placeMap),
                        ),
                      );
                      // _launchDirections(place.name);
                    },
                  ),
                );
              }
            },
          ),
        ],
      );
    }
    if (_selectedMarker != null) {
      return Container(
        width:double.infinity,
        padding: EdgeInsets.symmetric(horizontal:5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  // width: double.infinity,
                  width:250,
                  padding: EdgeInsets.all(5),
                  // margin:EdgeInsets.all(5),
                  decoration:BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _markerDetails,
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                ),
                // ElevatedButton(
                //   style: ButtonStyle(
                //     shape: MaterialStateProperty.all<OutlinedBorder>(
                //       CircleBorder(),
                //     ),
                //     elevation: MaterialStateProperty.all<double>(5), // Add elevation for shadow effect
                //     backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF90CAF9)), // Button color
                //   ),
                //   onPressed: () {
                //     if (_selectedMarker != null) {
                //       _launchDirections(
                //           _selectedMarker!.position.latitude,
                //           _selectedMarker!.position.longitude);
                //     }
                //   },
                //   child:Icon(Icons.assistant_direction_outlined),
                // ),
              ],
            ),
          ],
        ),
      );
    }
    return Text('No Result');
  }
}