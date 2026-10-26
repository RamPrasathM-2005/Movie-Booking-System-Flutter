import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future<QuerySnapshot> getUserbyemail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("Email", isEqualTo: email)
        .get();
  }
  Future addUserBooking(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id).collection("Booking")
        .add(userInfoMap);
  }
  Future<Stream<QuerySnapshot>> getbokings(String id) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Booking")
        .snapshots();
  }

  Future<QuerySnapshot> checkDuplicateBooking(
      String id, String movie, String date, String time, String seats) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Booking")
        .where("Movie", isEqualTo: movie)
        .where("Date", isEqualTo: date)
        .where("Time", isEqualTo: time)
        .where("Seats", isEqualTo: seats)
        .get();
  }

  Future<QuerySnapshot> getBookingsForShowtime(
      String movie, String date, String time) async {
    return FirebaseFirestore.instance
        .collectionGroup("Booking")
        .where("Movie", isEqualTo: movie)
        .where("Date", isEqualTo: date)
        .where("Time", isEqualTo: time)
        .get();
  }
}
