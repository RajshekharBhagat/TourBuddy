import 'package:flutter/material.dart';
import '../models/place.dart';

class discover_format extends StatelessWidget {
  final City city;
  const discover_format({
    super.key,
    required this.city,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top:15),
          padding: EdgeInsets.only(left:5, right:5),
          child: Container(
            height: 292,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(0, 3),
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                ),
              ],
              image:DecorationImage(
                  fit:BoxFit.cover,
                  image: NetworkImage(city.imagePath)
              ),
            ),
          ),
        ),
        SizedBox(
          height:10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(right:50),
              child: Text(
                  city.name.toString().toUpperCase(),style: const TextStyle(fontSize: 20)
              ),
            ),
          ],
        )
      ],
    );
  }
}