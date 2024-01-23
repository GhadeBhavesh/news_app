import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:news_app/auth/authentication_repository.dart';
import 'package:news_app/components/navbar.dart';
import 'package:news_app/pages/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase and get an instance of AuthenticationRepository
  await initialization(null);
  await Firebase.initializeApp()
      .then((value) => Get.put(AuthenticationRepository()));
  // Get SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  // Get the 'showHome' value from SharedPreferences, defaulting to false if not found
  final showHome = prefs.getBool("showHome") ?? false;
  // Run the app with the 'showHome' value
  runApp(MyApp(showHome: showHome));
}

Future initialization(BuildContext? context) async {
  await Future.delayed(Duration(seconds: 2));
}

class MyApp extends StatelessWidget {
  final bool showHome;
  MyApp({
    Key? key,
    required this.showHome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NewsApp',
      debugShowCheckedModeBanner: false,
      home: showHome ? WelcomeScreen() : Navbar(),
    );
  }
}
