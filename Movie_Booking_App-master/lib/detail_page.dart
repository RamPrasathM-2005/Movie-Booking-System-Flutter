import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_booking_app/bottomnav.dart';
import 'package:movie_booking_app/database.dart';
import 'package:movie_booking_app/homepage.dart';
import 'package:movie_booking_app/shared_pref.dart';
import 'package:random_string/random_string.dart';

class DetailPage extends StatefulWidget {
   final String moviename;
   final String movietype;
   final String moviedesc;
   final String movieposter;

  const //DetailPage({super.key});
  DetailPage({Key? key, required this.moviename,required this.movietype,required this.moviedesc,required this.movieposter}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? id,name;
  String? currentdate;
  String? selectedTime;
  late String _moviename;
  late String _movietype;
  late String _moviedesc;
  late String _movieposter;
  gethesharedpref()async{
    id = await SharedpreferenceHelper().getUserId();
    name=await SharedpreferenceHelper().getNameId();
    setState(() {

    });
  }
  List<String> getFormattedDates() {
    final now = DateTime.now();
    final formatter = DateFormat("EEE d");
    return List.generate(7, (index) {
      final date = now.add(Duration(days: index));
      return formatter.format(date);
    });
  }

  int track = 0,total=0;
  bool eight=false,ten=false,six=false;
  final Set<String> selectedSeats = {};
  final Set<String> blockedSeats = {"A1", "A2", "C5", "D7"};
  bool isLoadingBookedSeats = false;

  @override
  void initState(){
  super.initState();
    _moviename=widget.moviename;
    _movietype=widget.movietype;
    _moviedesc=widget.moviedesc;
    _movieposter=widget.movieposter;
    gethesharedpref();
  }

  Widget _posterImage(String path, BuildContext context){
    final height = MediaQuery.of(context).size.height / 2;
    final width = MediaQuery.of(context).size.width;
    if (path.startsWith("http://") || path.startsWith("https://")) {
      return Image.network(
        path,
        height: height,
        width: width,
        fit: BoxFit.cover,
      );
    }
    return Image.asset(
      path,
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }

  Widget _seat(String seatId) {
    final isBlocked = blockedSeats.contains(seatId);
    final isSelected = selectedSeats.contains(seatId);
    Color bg = isBlocked
        ? Colors.grey.shade700
        : isSelected
            ? Color(0xffeed51e)
            : Color(0xff1e232c);
    Color fg = isBlocked ? Colors.black54 : (isSelected ? Colors.black : Colors.white);
    return GestureDetector(
      onTap: (isBlocked || isLoadingBookedSeats)
          ? null
          : () {
              setState(() {
                if (isSelected) {
                  selectedSeats.remove(seatId);
                } else {
                  selectedSeats.add(seatId);
                }
                total = selectedSeats.length * 250;
              });
            },
      child: Container(
        width: 38,
        height: 38,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white24),
        ),
        child: Center(
          child: Text(
            seatId,
            style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSeatGrid() {
    final rows = ["A", "B", "C", "D", "E"];
    final seatsPerRow = 8;
    List<Widget> widgets = [];
    for (final row in rows) {
      for (int i = 1; i <= seatsPerRow; i++) {
        widgets.add(_seat("$row$i"));
      }
    }
    return widgets;
  }

  Future<void> _bookNow() async {
    if (currentdate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a date")),
      );
      return;
    }
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a time slot")),
      );
      return;
    }
    if (selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least one seat")),
      );
      return;
    }
    final uid = FirebaseAuth.instance.currentUser?.uid ?? id;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please login again to book.")),
      );
      return;
    }
    try {
      final seatsString = selectedSeats.join(", ");
      final snapshot = await DatabaseMethods().getBookingsForShowtime(
        widget.moviename,
        currentdate!,
        selectedTime!,
      );
      final Set<String> alreadyBooked = {};
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        final seats = (data["Seats"] ?? "").toString();
        if (seats.trim().isEmpty) continue;
        for (final seat in seats.split(",")) {
          final s = seat.trim();
          if (s.isNotEmpty) alreadyBooked.add(s);
        }
      }
      final conflict = selectedSeats.intersection(alreadyBooked);
      if (conflict.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Some selected seats are already booked.",
            style: TextStyle(fontSize: 16.0),
          ),
        ));
        return;
      }
      String uniqueid=randomAlphaNumeric(5);
      Map<String,dynamic> userMovieMap={
        "Movie":widget.moviename,
        "MovieImage":widget.movieposter,
        "Date":currentdate,
        "Time":selectedTime,
        "Quantity":selectedSeats.length.toString(),
        "Total":total.toString(),
        "Seats":seatsString,
        "QrId":uniqueid,
        "Name":name
      };
      await DatabaseMethods().addUserBooking(userMovieMap, uid);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Booking Successfully",
          style: TextStyle(fontSize: 18.0),
        ),
      ));
      setState(() {
        blockedSeats.addAll(selectedSeats);
        selectedSeats.clear();
        total = 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "Booking failed: ${e.toString()}",
          style: TextStyle(fontSize: 16.0),
        ),
      ));
    }
  }

  Future<void> _loadBookedSeats() async {
    if (currentdate == null || selectedTime == null) return;
    try {
      setState(() {
        isLoadingBookedSeats = true;
      });
      final snapshot = await DatabaseMethods().getBookingsForShowtime(
        widget.moviename,
        currentdate!,
        selectedTime!,
      );
      final Set<String> booked = {};
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        final seats = (data["Seats"] ?? "").toString();
        if (seats.trim().isEmpty) continue;
        for (final seat in seats.split(",")) {
          final s = seat.trim();
          if (s.isNotEmpty) booked.add(s);
        }
      }
      setState(() {
        blockedSeats
          ..clear()
          ..addAll(booked);
        selectedSeats.removeWhere((s) => blockedSeats.contains(s));
        total = selectedSeats.length * 250;
        isLoadingBookedSeats = false;
      });
    } catch (_) {
      setState(() {
        isLoadingBookedSeats = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dates = getFormattedDates();
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              _posterImage(_movieposter, context),
              SafeArea(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => BottomNav()));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0, top: 10.0),
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(0xff1e232c),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    left: 20.0, top: 20.0, right: 20.0, bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _moviename,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _movietype,
                      style: TextStyle(
                          color: Color.fromARGB(174, 255, 255, 255),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      _moviedesc,
                      style: TextStyle(
                          color: Color.fromARGB(174, 255, 255, 255),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "Select Date",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      height: 60,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dates.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                track = index;
                                currentdate = dates[index];
                                setState(() {});
                                _loadBookedSeats();
                              },
                              child: Container(
                                width: 100,
                                margin: EdgeInsets.only(right: 20.0),
                                decoration: BoxDecoration(
                                    color: Color(0xffeed51e),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: track == index
                                            ? Colors.white
                                            : Colors.black,
                                        width: 2.0)),
                                child: Center(
                                    child: Text(
                                  dates[index],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            );
                          }),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Select Time Slot",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                        onTap: () {
                          eight = true;
                          ten = false;
                          six = false;
                          selectedTime = "08.00 PM";
                          setState(() {});
                          _loadBookedSeats();
                        },
                          child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color:
                                    eight ? Colors.white : Color(0xff1e232c),
                                border: Border.all(
                                    color: Color(0xffeed51e), width: 3.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "08.00 PM",
                                style: TextStyle(
                                    color:
                                        eight ? Colors.black : Colors.white,
                                    fontSize: 21.0,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        GestureDetector(
                        onTap: () {
                          eight = false;
                          ten = true;
                          six = false;
                          selectedTime = "10.00 PM";
                          setState(() {});
                          _loadBookedSeats();
                        },
                          child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color:
                                    ten ? Colors.white : Color(0xff1e232c),
                                border: Border.all(
                                    color: Color(0xffeed51e), width: 3.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "10.00 PM",
                                style: TextStyle(
                                    color:
                                        ten ? Colors.black : Colors.white,
                                    fontSize: 21.0,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        GestureDetector(
                        onTap: () {
                          eight = false;
                          ten = false;
                          six = true;
                          selectedTime = "06.00 PM";
                          setState(() {});
                          _loadBookedSeats();
                        },
                          child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color:
                                    six ? Colors.white : Color(0xff1e232c),
                                border: Border.all(
                                    color: Color(0xffeed51e), width: 3.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "06.00 PM",
                                style: TextStyle(
                                    color:
                                        six ? Colors.black : Colors.white,
                                    fontSize: 21.0,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        SizedBox(width: 0.1)
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Select Seats",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "${selectedSeats.length} seat(s) selected",
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                    if (isLoadingBookedSeats) ...[
                      SizedBox(height: 4),
                      Text(
                        "Loading booked seats...",
                        style: TextStyle(color: Colors.white54, fontSize: 12.0),
                      ),
                    ],
                    SizedBox(height: 6),
                    Wrap(
                      children: _buildSeatGrid(),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        _legendBox(Color(0xffeed51e), "Selected"),
                        SizedBox(width: 12),
                        _legendBox(Color(0xff1e232c), "Available"),
                        SizedBox(width: 12),
                        _legendBox(Colors.grey.shade700, "Booked"),
                      ],
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: _bookNow,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                            color: Color(0xffeed51e),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white)),
                        child: Column(
                          children: [
                            Text(
                              "Total :\$${total}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Book Now",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

    Widget _legendBox(Color color, String label) {
      return Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          SizedBox(width: 6),
          Text(label, style: TextStyle(color: Colors.white70)),
        ],
      );
    }
  }
