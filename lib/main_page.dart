
import 'package:flutter/material.dart';
import 'package:partial_tourbuddy/pages/Drawer.dart';
import 'package:partial_tourbuddy/pages/translate_page.dart';
import 'package:partial_tourbuddy/pages/home_page.dart';
import 'package:partial_tourbuddy/pages/search_page.dart';
import 'package:partial_tourbuddy/pages/quest_page.dart';


class main_page extends StatefulWidget {
  const main_page({super.key});

  @override
  State<main_page> createState() => _main_pageState();
}

class _main_pageState extends State<main_page> {
  List pages=[
    const home_page(),
    const search_page(),
    const translate_page(),
    const QuestPage()
  ];
  int currentIndex=0;
void onTap(int index)
{
  setState(() {
    currentIndex= index;
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
          size: 30,
        ),
        centerTitle: true,
        backgroundColor:Colors.blue[100],
        title: const Text('TourBuddy',style: TextStyle(
          fontSize: 25,
          color: Colors.black,
        ),),
      ),
      drawer: Drawer(
        clipBehavior: Clip.antiAlias,
        backgroundColor: Colors.blue[200],
        child: SingleChildScrollView(
          child: Container(
            child: const Column(
              children: [
                myHeaderDrawer(),
                myListDrawer(),
              ],
            ),
          ),
        )
        ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          // backgroundColor: Colors.blue,
          iconSize: 25,
          type: BottomNavigationBarType.shifting,
          elevation: 10,
          currentIndex:currentIndex,
          onTap: onTap,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black45,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          items: const [
            BottomNavigationBarItem(icon:Icon(Icons.home),label:'Discover'),
            BottomNavigationBarItem(icon:Icon(Icons.search),label:'search'),
            BottomNavigationBarItem(icon:Icon(Icons.translate),label: 'Translator'),
            BottomNavigationBarItem(icon:Icon(Icons.explore),label: 'Quest'),
          ],
        ),
      );
  }
}
