import 'package:flutter/material.dart';
class favDetail extends StatefulWidget {
  final Map<String , dynamic> favPlaceDetail; 
  const favDetail({Key? key,required this.favPlaceDetail}):super(key: key);
  @override
  State<favDetail> createState() => _favDetailState();
}

class _favDetailState extends State<favDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation:FloatingActionButtonLocation.miniEndTop ,
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
                    image: NetworkImage(widget.favPlaceDetail['img'].toString()),
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
                        widget.favPlaceDetail['name'] ?? 'N/A',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.star,
                        ),
                        Text("${widget.favPlaceDetail['rating']}",style: const TextStyle(fontSize: 18))
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Detail", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "${widget.favPlaceDetail['desc']}" ?? "N/A",
                          overflow: TextOverflow.visible ,
                          maxLines: null,
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
                      Text("${widget.favPlaceDetail['add']}"??'N/A'),
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
                            elevation: MaterialStateProperty.all<double>(5),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent)
                        ),
                        onPressed: null,
                        child:Text("Booking"),
                      ),
                    ),
                    Container(
                      width:150,
                      height: 50,
                      child: ElevatedButton(
                          onPressed:(){
                            double lat = widget.favPlaceDetail['lat'];
                            double long = widget.favPlaceDetail['long'];
                            print("${lat},${long}");
                          },
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(5),
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
    );;
  }
}
