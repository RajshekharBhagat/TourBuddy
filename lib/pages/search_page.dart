import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:partial_tourbuddy/pages/places_desc.dart';
import 'places_desc.dart';

class search_page extends StatefulWidget {
  const search_page({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<search_page> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  List<Map<String, dynamic>> _searchResults = [];

  void _searchData(String query) async {
    // Clear previous search results
    _searchResults.clear();
    query = query.toLowerCase();

    if (query.isNotEmpty) {
      // Use .onValue() instead of .once() for real-time updates
      _databaseReference
          .child('cities')
          .orderByChild('name')
          .startAt(query)
          .endAt(query + '\uf8ff')
          .onValue
          .listen((event) {
        // Use the DataSnapshot property to get the actual snapshot
        DataSnapshot snapshot = event.snapshot;
        if (snapshot.value != null) {
          _searchResults.clear();
          // Iterate through the search results
          (snapshot.value as Map<dynamic, dynamic>).forEach((key, value) {
            Map<String, dynamic> resulting = {
              'city': value['name'],
              'imgurl': value['cimg'],
              'city_desc': value['desc'],
              'hotels': (value['Hotels']).values.toList(),
              'places': (value['Places']).values.toList(),
            };
            _searchResults.add(resulting);
          });
        }

        // Update the UI
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[100],
      child: Column(
        children: [
          SizedBox(height: 10),
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
                //   BoxShadow(
                //     color: Colors.white,
                //     offset: Offset(-5, -5),
                //     blurRadius: 30,
                //     spreadRadius: 1,
                //   ),
                // ]
            ),
            margin: const EdgeInsets.all(15),
            child: TextField(
              controller: _searchController,
              onChanged: _searchData,
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
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text('No results.'),
      );
    } else {
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> result = _searchResults[index];

          return Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
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
            child: TextButton(
              onPressed: () {
                // Handle city button click
                print('City button clicked: ${result['city']}');
                // Navigate to CityDetailsPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => place_desc(result: result),
                  ),
                );
              },
              child: Text(result['city'].toString().toUpperCase()),
            ),
          );
        },
      );
    }
  }
}
