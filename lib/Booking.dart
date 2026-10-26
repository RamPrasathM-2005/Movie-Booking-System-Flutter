import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/bottomnav.dart';
import 'package:movie_booking_app/database.dart';
import 'package:movie_booking_app/shared_pref.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
   Stream<QuerySnapshot>? bookingStream;
   String? id,name;
   gethesharedpref()async{
     id = await SharedpreferenceHelper().getUserId();
     name=await SharedpreferenceHelper().getNameId();
     setState(() {

     });
   }
   getontheload()async {
     await gethesharedpref();
     if (id == null) {
       bookingStream = null;
       setState(() {});
       return;
     }
     bookingStream=await DatabaseMethods().getbokings(id!);
     setState(() {});
   }
   @override
   void initState(){
     getontheload();
     super.initState();
   }
   String _safeText(dynamic value, {String fallback = ""}) {
     if (value == null) return fallback;
     final text = value.toString();
     if (text.trim().isEmpty || text.trim().toLowerCase() == "null") {
       return fallback;
     }
     return text;
   }

   Widget _movieImage(String? path){
     final safePath = _safeText(path);
     if (safePath.isEmpty) {
       return Image.asset(
         "images/infinity.jpg",
         height: 130,
         width: 130,
         fit: BoxFit.cover,
       );
     }
     if (safePath.startsWith("http://") || safePath.startsWith("https://")) {
       return Image.network(
         safePath,
         height: 130,
         width: 130,
         fit: BoxFit.cover,
         errorBuilder: (context, error, stackTrace) {
           return Image.asset(
             "images/infinity.jpg",
             height: 130,
             width: 130,
             fit: BoxFit.cover,
           );
         },
       );
     }
     return Image.asset(
       safePath,
       height: 130,
       width: 130,
       fit: BoxFit.cover,
     );
   }

   Widget allBooking(){
     if (bookingStream == null) {
       return Center(
         child: Text(
           "No bookings yet",
           style: TextStyle(color: Colors.white70, fontSize: 18.0),
         ),
       );
     }
     return StreamBuilder<QuerySnapshot>(
       stream: bookingStream,
       builder: (context, snapshot){
         try {
           if (snapshot.hasError) {
             return Center(
               child: Text(
                 "Unable to load bookings. Check your internet connection.",
                 style: TextStyle(color: Colors.white70, fontSize: 16.0),
               ),
             );
           }
           if (snapshot.connectionState == ConnectionState.waiting) {
             return Center(child: CircularProgressIndicator());
           }
           final data = snapshot.data;
           final docs = data?.docs ?? [];
           if (data == null || docs.isEmpty) {
             return Center(
               child: Text(
                 "No bookings yet",
                 style: TextStyle(color: Colors.white70, fontSize: 18.0),
               ),
             );
           }
           return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: docs.length,
            itemBuilder: (context,index){
             try {
               DocumentSnapshot ds=docs[index];
               final raw = ds.data();
               if (raw == null || raw is! Map) {
                 return SizedBox.shrink();
               }
               final data = Map<String, dynamic>.from(raw);
               final nameText = _safeText(data["Name"], fallback: "Guest");
               final movieText = _safeText(data["Movie"], fallback: "Movie");
               final qtyText = _safeText(data["Quantity"], fallback: "0");
               final totalText = _safeText(data["Total"], fallback: "0");
               final timeText = _safeText(data["Time"], fallback: "--");
               final dateText = _safeText(data["Date"], fallback: "--");
               final seatsText = _safeText(data["Seats"]);
               final qrText = _safeText(data["QrId"]);
               final movieImage = _safeText(data["MovieImage"]);
               return Column(
                 children: [
                   Container(
                     margin: EdgeInsets.only(bottom: 16.0),
                     padding: EdgeInsets.all(16.0),
                     width: MediaQuery.of(context).size.width,
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(14),
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             ClipRRect(
                               borderRadius: BorderRadius.circular(12.0),
                               child: _movieImage(movieImage),
                             ),
                             SizedBox(width: 14.0),
                             Expanded(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(
                                     movieText,
                                     style: TextStyle(
                                       color: Colors.black,
                                       fontSize: 20.0,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                   SizedBox(height: 4.0),
                                   Text(
                                     nameText,
                                     style: TextStyle(
                                       color: Colors.black54,
                                       fontSize: 14.0,
                                       fontWeight: FontWeight.w500,
                                     ),
                                   ),
                                   SizedBox(height: 6.0),
                                   Row(
                                     children: [
                                       Icon(Icons.calendar_month,
                                           color: Color(0xffedb41d), size: 18),
                                       SizedBox(width: 6.0),
                                       Text(
                                         dateText,
                                         style: TextStyle(
                                           color: Colors.black,
                                           fontSize: 14.0,
                                           fontWeight: FontWeight.w600,
                                         ),
                                       ),
                                     ],
                                   ),
                                   SizedBox(height: 4.0),
                                   Row(
                                     children: [
                                       Icon(Icons.alarm,
                                           color: Color(0xffedb41d), size: 18),
                                       SizedBox(width: 6.0),
                                       Text(
                                         timeText,
                                         style: TextStyle(
                                           color: Colors.black,
                                           fontSize: 14.0,
                                           fontWeight: FontWeight.w600,
                                         ),
                                       ),
                                     ],
                                   ),
                                   if (seatsText.isNotEmpty) ...[
                                     SizedBox(height: 6.0),
                                     Row(
                                       children: [
                                         Icon(Icons.event_seat,
                                             color: Color(0xffedb41d), size: 18),
                                         SizedBox(width: 6.0),
                                         Flexible(
                                           fit: FlexFit.loose,
                                           child: Text(
                                             seatsText,
                                             style: TextStyle(
                                               color: Colors.black87,
                                               fontSize: 13.0,
                                               fontWeight: FontWeight.w600,
                                             ),
                                             overflow: TextOverflow.ellipsis,
                                           ),
                                         ),
                                       ],
                                     ),
                                   ],
                                 ],
                               ),
                             ),
                           ],
                         ),
                         SizedBox(height: 12.0),
                         Row(
                           children: [
                             _statChip(Icons.group, "Tickets: $qtyText"),
                             SizedBox(width: 10.0),
                             _statChip(Icons.attach_money, "Total: $totalText"),
                             Spacer(),
                             Container(
                               padding: EdgeInsets.all(8),
                               decoration: BoxDecoration(
                                 color: Colors.black12,
                                 borderRadius: BorderRadius.circular(10),
                               ),
                               child: qrText.isEmpty
                                   ? Column(
                                       children: [
                                         Icon(Icons.qr_code, size: 28),
                                         SizedBox(height: 4),
                                         Text("N/A",
                                             style: TextStyle(fontSize: 10)),
                                       ],
                                     )
                                   : QrImageView(
                                       data: qrText,
                                       version: QrVersions.auto,
                                       size: 70,
                                     ),
                             ),
                           ],
                         ),
                       ],
                     ),
                   ),
                   SizedBox(height: 8.0),
                 ],
               );
             } catch (_) {
               return SizedBox.shrink();
             }
           });
         } catch (_) {
           return Center(
             child: Text(
               "Unable to render bookings right now.",
               style: TextStyle(color: Colors.white70, fontSize: 16.0),
             ),
           );
         }
       });
   }

   Widget _statChip(IconData icon, String text) {
     return Container(
       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
       decoration: BoxDecoration(
         color: Colors.black12,
         borderRadius: BorderRadius.circular(20),
       ),
       child: Row(
         mainAxisSize: MainAxisSize.min,
         children: [
           Icon(icon, size: 16, color: Colors.black87),
           SizedBox(width: 6),
           Text(
             text,
             style: TextStyle(
                 color: Colors.black87,
                 fontSize: 12,
                 fontWeight: FontWeight.w600),
           )
         ],
       ),
     );
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          margin: EdgeInsets.only(top: 40.0),
          child: Column(

            children: [
              Row(
                children: [
                  SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => BottomNav()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: Center(
                      child: Text("Bookings",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: 42.0),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.only(left: 20.0, top: 10.0),
                    margin: EdgeInsets.only(top: 5.0, left: 2.0, right: 7.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Color(0xff1e232c),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    child: Column(
                      children: [
                        Expanded(child: allBooking())
                      ],
                    )),
              )
            ],
          ),
        ));
  }
}
