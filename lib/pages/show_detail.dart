import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:partial_tourbuddy/models/place.dart';
import 'package:partial_tourbuddy/pages/hotel_detail.dart';
import 'package:partial_tourbuddy/pages/places_desc.dart';
import 'package:partial_tourbuddy/pages/places_detail.dart';

class show_detail extends StatefulWidget {
  final City city;
  final List<Place> place;
  final List<Hotel> hotel;

  const show_detail({
    Key? key,
    required this.city,
    required this.place,
    required this.hotel
  }) : super(key: key);


  @override
  _ShowDetailState createState() => _ShowDetailState();
}

class _ShowDetailState extends State<show_detail> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late Animation animation;
  late AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds:700));
    animation = Tween(begin:70.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut)
    );
    animationController.addListener(() {
      setState(() {
      });
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.city.imagePath),
                fit: BoxFit.cover,
              ),
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
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    widget.city.name.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    widget.city.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height:animation.value?? 0,),
                Container(
                  width: double.infinity,
                  height: 500,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(0, -2),
                      blurRadius: 5.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                  child: Column(
                    children: [
                      SizedBox(height:10,),
                      Center(
                        child: Container(
                          height: 3,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height:10,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 3),
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
                        child:SingleChildScrollView(
                          child: _currentIndex == 0
                              ? _buildPlacesContent()
                              : _buildHotelsContent(),
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPlacesContent() {
    return Column(
      children: widget.place.map((place) {
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
            },
            child: Text(
              place.name, // Use the appropriate key
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHotelsContent() {
    return Column(
      children: widget.hotel.map((hotel) {
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
            },
            child: Text(
              hotel.name, // Use the appropriate key
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
    );
  }
}