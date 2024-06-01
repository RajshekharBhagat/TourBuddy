
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:partial_tourbuddy/pages/hotel_detail.dart';
import 'package:partial_tourbuddy/pages/places_detail.dart';

class place_desc extends StatefulWidget {
  final Map<String,dynamic> result;
  const place_desc({Key? key , required this.result}) : super(key:key);

  @override
  _PlaceDescState createState() => _PlaceDescState();
}

class _PlaceDescState extends State<place_desc> with SingleTickerProviderStateMixin{
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
        children:[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.result['imgurl'].toString()),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          SingleChildScrollView(
            //scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    // widget.place.name,
                    widget.result['city'].toString().toUpperCase(),
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
                    // widget.place.description,
                    widget.result['city_desc'].toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height:animation.value),
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
                      const SizedBox(height:10,),
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
                        child: SingleChildScrollView(
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
                      ),
                      const SizedBox(height: 10,),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: _currentIndex == 0
                                ? _buildPlacesContent(context,widget.result['places'])
                                : _buildHotelsContent(context,widget.result['hotels']),
                          ),
                        ),
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
  List<Widget> _buildPlacesContent(BuildContext context, List<dynamic> details) {
    return details.map<Widget>((detail) {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => places_detail(
                  placeDetails: Map<String, dynamic>.from(detail),
                ),
              ),
            );
          },
          child: Text(
            detail['pname'], // Use the appropriate key
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildHotelsContent(BuildContext context, List<dynamic> details) {
    return details.map<Widget>((detail) {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => hotel_detail(
                  hotelDetails: Map<String, dynamic>.from(detail),
                ),
              ),
            );
          },
          child: Text(
            detail['hname'],
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }).toList();
  }
}