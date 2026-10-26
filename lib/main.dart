
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:movie_booking_app/homepage.dart';
import 'package:movie_booking_app/login.dart';
import 'package:movie_booking_app/signup.dart';

import 'bottomnav.dart';
import 'detail_page.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey = 'pk_test_51R5nKTC0m0eMHkaww9e790Oj2DEo9Q2Mq2b09vjG7gIMDzVyHrf38CD82AoFHgzFpAdh50bRvPV1ThvayZtMwtH200x3GJEkuz'; // Replace with your actual key
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}

