import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/database.dart';
import 'package:movie_booking_app/shared_pref.dart';
import 'package:movie_booking_app/signup.dart';

import 'bottomnav.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "", password = "", myname = "", myid = "", myimage = "";
  TextEditingController passwordcontroller = new TextEditingController();
  TextEditingController mailcontroller = new TextEditingController();
  bool _isLoading = false;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.orangeAccent,
      content: Text(
        message,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
      ),
    ));
  }

  userlogin() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showMessage("Login failed. Please try again.");
        return;
      }
      final uid = user.uid;
      myid = uid;
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        myname = "${data["Name"] ?? ""}";
        myimage = "${data["Image"] ?? ""}";
      } else {
        // Fallback for older accounts stored by email lookup
        QuerySnapshot querySnapshot =
            await DatabaseMethods().getUserbyemail(email);
        if (querySnapshot.docs.isNotEmpty) {
          myname = "${querySnapshot.docs[0]["Name"]}";
          myimage = "${querySnapshot.docs[0]["Image"]}";
          if (querySnapshot.docs[0].data() is Map &&
              (querySnapshot.docs[0].data() as Map).containsKey("Id")) {
            myid = "${querySnapshot.docs[0]["Id"]}";
          }
        }
      }

      await SharedpreferenceHelper().saveUserImage(myimage);
      await SharedpreferenceHelper().saveUserEmail(email);
      await SharedpreferenceHelper().saveUserId(myid);
      await SharedpreferenceHelper().saveUserDisplayName(myname);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNav()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showMessage("No user Found for that Email");
      } else if (e.code == 'wrong-password') {
        _showMessage("Wrong Password Provided by User");
      } else {
        _showMessage("Login failed. Please try again.");
      }
    } catch (e) {
      _showMessage("Login failed. Please try again.");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff14141d),
        body: SingleChildScrollView(
          child: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("images/signin.png"),
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome",
                        style: TextStyle(
                            color: Color.fromARGB(157, 255, 255, 255),
                            fontSize: 34.0,
                            fontWeight: FontWeight.w500)),
                    Text("LogIn",
                        style: TextStyle(
                            color: Color.fromARGB(157, 255, 255, 255),
                            fontSize: 45.0,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 90.0,
                    ),
                    Text("Email",
                        style: TextStyle(
                            color: Color.fromARGB(157, 255, 255, 255),
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500)),
                    TextField(
                      controller: mailcontroller,
                      decoration: InputDecoration(
                          hintText: "Enter Email",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(219, 255, 255, 255),
                          ),
                          suffixIcon: Icon(
                            Icons.email,
                            color: Colors.white,
                          )),
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Text("Password",
                        style: TextStyle(
                            color: Color.fromARGB(157, 255, 255, 255),
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500)),
                    TextField(
                      obscureText: true,
                      controller: passwordcontroller,
                      decoration: InputDecoration(
                          hintText: "Enter Password",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(219, 255, 255, 255),
                          ),
                          suffixIcon: Icon(
                            Icons.password,
                            color: Colors.white,
                          )),
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Forgot Password ?",
                            style: TextStyle(
                                color: Color(0xff5953fc),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signup()));
                          },
                          child: Container(
                            width: 170,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Text("Sign Up",
                                  style: TextStyle(
                                      color: Color(0xff5953fc),
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                    GestureDetector(
                      onTap: _isLoading ? null : (){
                        if (mailcontroller.text.trim().isEmpty ||
                            passwordcontroller.text.trim().isEmpty) {
                          _showMessage("Please enter email and password");
                          return;
                        }
                        setState(() {
                          email=mailcontroller.text.trim();
                          password=passwordcontroller.text.trim();
                        });
                        userlogin();
                      },
                      child: Container(
                        width: 170,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(0xff5953fc),
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: _isLoading
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text("Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
        ));
  }
}
