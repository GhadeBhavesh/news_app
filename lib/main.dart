import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:news_app/auth/authentication_repository.dart';
import 'package:news_app/pages/HomeScreen.dart';
import 'package:news_app/pages/account_page.dart';
import 'package:news_app/pages/bookmark.dart';
import 'package:news_app/pages/category_Page.dart';
import 'package:news_app/pages/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

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
      home: showHome ? WelcomeScreen() : Draw(),
    );
  }
}

class Draw extends StatefulWidget {
  Draw({Key? key}) : super(key: key);

  @override
  State<Draw> createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  Widget pages = HomeScreen();
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: Builder(builder: (context) {
        return MenuScreen(
          onPageChanged: (a) {
            setState(() {
              pages = a;
            });
            ZoomDrawer.of(context)!.close();
          },
        );
      }),
      mainScreen: pages,
      borderRadius: 24,
      showShadow: true,
      drawerShadowsBackgroundColor: Colors.grey,
      menuBackgroundColor: Colors.indigo,
    );
  }
}

class MenuScreen extends StatefulWidget {
  MenuScreen({Key? key, required this.onPageChanged}) : super(key: key);

  final Function(Widget) onPageChanged;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<ListItems> drawerItems = [
    ListItems(Icon(Icons.home), Text('Home'), HomeScreen()),
    ListItems(
        Icon(Icons.category),
        Text('Category'),
        CategoryNews(
          name: '',
        )),
    ListItems(
        Icon(Icons.bookmark),
        Text('Bookmark'),
        BookmarksPage(
          bookmarkedIndexes: [],
        )),
    ListItems(Icon(Icons.account_circle), Text('Account'), Account()),
    // ListItems(Icon(Icons.account_circle), Text('Jobs'), JobInfoPage()),
  ];

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        backgroundColor: Colors.indigo,
        body: Theme(
            data: ThemeData.dark(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    // child: Image(
                    //   height: 100,
                    //   width: 100,
                    //   image: user!.photoURL == null
                    //       ? NetworkImage(user.photoURL!)
                    //       : NetworkImage(
                    //           "https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1931&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 38.0),
                //   child: Text(
                //     user!.displayName!,
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 18.0),
                //   child: Text(user.email!,
                //       style: TextStyle(
                //         fontSize: 14,
                //         color: Colors.white,
                //         fontWeight: FontWeight.bold,
                //       )),
                // ),
                SizedBox(
                  height: 30,
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: drawerItems
                        .map((e) => ListTile(
                              onTap: () {
                                widget.onPageChanged(e.page);
                              },
                              title: e.title,
                              leading: e.icon,
                            ))
                        .toList()),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: OutlinedButton(
                      onPressed: () {
                        AuthenticationRepository.instance.signOut();
                      },
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            )));
  }
}

class ListItems {
  final Icon icon;
  final Text title;
  final Widget page;
  ListItems(this.icon, this.title, this.page);
}
