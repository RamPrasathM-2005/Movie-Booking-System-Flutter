import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/homepage.dart';
import 'package:movie_booking_app/profile.dart';

import 'Booking.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
   late List<Widget> pages;

   late Home homepage;
   late Booking booking;
   late Profile profile;
   int currentTabIndex=0;
  @override
  void initState(){
      homepage = Home();
      booking = Booking();
      profile = Profile();
      pages=[homepage,booking,profile];
      super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.black,
        color:Color.fromARGB(255, 204, 151, 7),
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index){
          setState(() {
            currentTabIndex= index;
          });
        },
        items:[
          Icon(Icons.home,
          color: Colors.white,
            size: 30.0,
          ),
          Icon(Icons.book,
            color: Colors.white,
            size: 30.0,
          ),
          Icon(Icons.person,
            color: Colors.white,
            size: 30.0,
          ),

        ]
      ),
      body: pages[currentTabIndex],
    );

  }
}
