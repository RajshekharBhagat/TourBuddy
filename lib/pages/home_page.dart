// import 'package:flutter/material.dart';
// import 'package:partial_tourbuddy/pages/FavPage.dart';
// import 'package:partial_tourbuddy/pages/discover_format.dart';
// import 'package:partial_tourbuddy/models/place.dart';
// import 'package:partial_tourbuddy/pages/map_page.dart';
// import 'package:partial_tourbuddy/pages/show_detail.dart';
//
// class home_page extends StatefulWidget {
//   const home_page({super.key});
//
//   @override
//   State<home_page> createState() => _home_pageState();
// }
//
// class _home_pageState extends State<home_page> {
//   List places = [
//     Place(
//         name: 'Mumbai',
//         imagePath: 'assets/gatewayofindia.jpg',
//         rating:'4.5',
//         description: "The Gateway of India stands as an iconic symbol of Mumbai's maritime history and cultural richness. Majestically overlooking the Arabian Sea, this grand archway beckons travelers into the heart of the city, bridging the gap between historical legacy and modern dynamism. Its intricate design and commanding presence make it a gateway not only to the city but also to the stories of its past and the promises of its future."
//     ),
//     Place(
//         name: 'Jaipur',
//         imagePath: 'assets/hawamahal.jpg',
//         rating:'4.5',
//         description:"The Hawa Mahal, or \"Palace of Winds,\" is a masterpiece of delicate architecture nestled in the heart of Jaipur. This whimsical palace, adorned with countless latticed windows and ornate balconies, seems to catch the very breeze that carries the tales of Rajasthan's royalty. As sunlight filters through its honeycombed façade, it paints a picture of a bygone era, inviting you to glimpse the world behind its intriguing walls.",
//     ),
//     Place(
//         name: 'Agra',
//         imagePath: 'assets/Tajmahal.jpg',
//         rating:'4.5',
//         description: "The Taj Mahal, an embodiment of eternal love and architectural brilliance, stands as a testament to the power of human emotion and creativity. Its white marble façade, kissed by the sun's gentle glow, stands proudly on the banks of the Yamuna River. Every intricate detail, from its symmetrical gardens to the majestic dome, tells a story of Shah Jahan's devotion to his beloved Mumtaz Mahal. It's not just a mausoleum; it's an emotion etched in stone."
//     ),
//     Place(
//         name: 'Varanasi',
//         imagePath: 'assets/varanasi.jpg',
//         rating:'4.5',
//         description: "Varanasi, the spiritual heart of India, exudes an otherworldly charm that transcends time. Nestled on the banks of the sacred Ganges River, its ghats come alive with the vibrant tapestry of life and death, devotion and liberation. Here, the ancient rituals blend seamlessly with the everyday rhythm, as the city's temples and narrow alleyways invite you to explore a cosmos of faith, culture, and introspection. Varanasi is a journey into the mystique of the universe itself."
//     ),
//     Place(
//         name: 'Uttrakhand',
//         imagePath: 'assets/kedarnath.jpg',
//         rating:'4.5',
//         description: "Perched at the lap of the Himalayas, Kedarnath is not just a temple town; it's a sanctuary of devotion and resilience. The Kedarnath Temple, dedicated to Lord Shiva, stands as a testimony to human determination, having weathered the tests of time and nature. Amidst the crisp mountain air and the reverberating chants, pilgrims ascend the steep paths to pay homage to the divine. Each step taken here echoes with the legends of faith and the ethereal beauty of the surroundings, inviting you to embark on a spiritual journey that transcends the physical realm."
//     ),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor:Colors.blue[100],
//       body: Column(
//             children: [
//               const SizedBox(
//                 height: 20,
//               ),
//               Container(
//                 height:50,
//                 width: 200,
//                 decoration: BoxDecoration(
//                     color: Colors.blue[200],
//                     borderRadius: BorderRadius.circular(20),
//                   // boxShadow: [
//                   //   const BoxShadow(
//                   //     color:Color(0xFF90CAF9),//Color(0xFFBEBEBE),
//                   //     offset: Offset(10,10),
//                   //     blurRadius:10,
//                   //     spreadRadius: 0.1,
//                   //   ),
//                   //   const BoxShadow(
//                   //     color: Colors.white,
//                   //     offset: Offset(-5, -5),
//                   //     blurRadius: 10,
//                   //     spreadRadius: 0.5,
//                   //   ),
//                   // ],
//                 ),
//                 margin: const EdgeInsets.only(right:190),
//                   child:const Center(child: Text("Discover",style: TextStyle(fontSize:30, fontWeight:FontWeight.w500),)),
//               ),
//               const SizedBox(height:10),
//               Container(
//                 // decoration: BoxDecoration(
//                 //   borderRadius: BorderRadius.circular(20),
//                 //   color: Colors.blueGrey[100]
//                 // ),
//                 height:350,
//                 child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: places.length,
//                     itemBuilder:(context,index)=>GestureDetector(
//                       onTap:(){
//                         Navigator.push(context,MaterialPageRoute(builder: (context)=>show_detail(place: places[index])));
//                       },
//                       child: discover_format(place: places[index],),
//                     )
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                     color: Colors.blue[200],
//                     borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     const BoxShadow(
//                       color:Color(0xFF90CAF9),//Color(0xFFBEBEBE),
//                       offset: Offset(10,10),
//                       blurRadius:10,
//                       spreadRadius: 0.1,
//                     ),
//                     const BoxShadow(
//                       color: Colors.white,
//                       offset: Offset(-5, -5),
//                       blurRadius: 10,
//                       spreadRadius: 0.5,
//                     ),
//                   ],
//                 ),
//                 width: double.infinity,
//                 child: ListTile(
//                   horizontalTitleGap:90,
//                   leading: const Icon(Icons.favorite_outlined,size: 30,),
//                   onTap: () {
//                     Navigator.push(context,MaterialPageRoute(builder: (context)=>favPage()));
//                   },
//                   title: const Text(
//                     "Favourites",
//                     style: TextStyle(
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                     color: Colors.blue[200],
//                     borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     const BoxShadow(
//                       color:Color(0xFF90CAF9),//Color(0xFFBEBEBE),
//                       offset: Offset(10,10),
//                       blurRadius:10,
//                       spreadRadius: 0.1,
//                     ),
//                     const BoxShadow(
//                       color: Colors.white,
//                       offset: Offset(-5, -5),
//                       blurRadius: 10,
//                       spreadRadius: 0.5,
//                     ),
//                   ],
//                 ),
//                 width: double.infinity,
//                 child: ListTile(
//                   horizontalTitleGap: 90,
//                   leading: const Icon(Icons.map,size: 30,),
//                   onTap: () {
//                     Navigator.push(context,MaterialPageRoute(builder: (context)=>const map_page()));
//                   },
//                   title: const Text(
//                     "Map",
//                     style: TextStyle(
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//     );
//
//   }
//
//
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:partial_tourbuddy/pages/FavPage.dart';
import 'package:partial_tourbuddy/pages/discover_format.dart';
import 'package:partial_tourbuddy/models/place.dart';
import 'package:partial_tourbuddy/pages/map_page.dart';
import 'package:partial_tourbuddy/pages/places_desc.dart';
import 'package:partial_tourbuddy/pages/show_detail.dart';
import 'package:firebase_database/firebase_database.dart';

class home_page extends StatefulWidget {
  const home_page({Key? key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  final List<City> _city = [];

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
  }
  void _fetchPlaces() {
    _city.clear();
    _databaseReference.child('cities').onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final citiesData = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        citiesData.forEach((key, value) {
          final List<Hotel> hotels = [];
          final List<Place> places = [];
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
          _city.add(city);
        });
        setState(() {}); // Refresh UI after data retrieval
      }
    }, onError: (error) {
      print("Failed to fetch places: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            height:50,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.only(right:190),
            child:const Center(child: Text("Discover",style: TextStyle(fontSize:30, fontWeight:FontWeight.w500),)),
          ),
          const SizedBox(height: 10),
          Container(
            height: 350,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _city.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => show_detail(city: _city[index], place: _city[index].places, hotel: _city[index].hotels)));
                },
                child: discover_format(city: _city[index]),
              ),
            ),
          ),
          Container(
                margin: const EdgeInsets.all(10),
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
                ),
                width: double.infinity,
                child: ListTile(
                  horizontalTitleGap:90,
                  leading: const Icon(Icons.favorite_outlined,size: 30,),
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>favPage()));
                  },
                  title: const Text(
                    "Favourites",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
          Container(
            margin: const EdgeInsets.all(10),
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
            ),
            width: double.infinity,
            child: ListTile(
              horizontalTitleGap: 90,
              leading: const Icon(Icons.map,size: 30,),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const map_page()));
              },
              title: const Text(
                "Map",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
