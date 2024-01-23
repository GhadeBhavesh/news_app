import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/auth/authentication_repository.dart';
import 'package:news_app/components/Datepi.dart';
import 'package:news_app/components/home_ui.dart';
import 'package:news_app/components/NotificiedSettingPage.dart';
import 'package:news_app/pages/profile_page.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    // NewsviewModels newsviewModels = NewsviewModels();
    // final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          "Account",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            ClipPath(
              clipper: TCustomCurvedEdges(),
              child: Container(
                color: Color.fromARGB(255, 0, 51, 255),
                child: SizedBox(
                  height: height * .3,
                  child: Stack(
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image(
                                  height: 50,
                                  width: 50,
                                  image: user!.photoURL != null
                                      ? NetworkImage(user.photoURL!)
                                      : NetworkImage(
                                          "https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1931&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                user.displayName!,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(user.email!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                              trailing: IconButton(
                                  onPressed: () {
                                    Get.to(() => Profile_page());
                                  },
                                  icon: Icon(
                                    Icons.edit_square,
                                    color: Colors.white,
                                  )),
                            )
                          ]),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Account Settings",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.off(NotificiedSettingPage());
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  title: Text("Notification"),
                  subtitle: Text("Set any kind of notification"),
                  leading: Icon(
                    Icons.notifications_none_sharp,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => Datepi());
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  title: Text("Date"),
                  subtitle: Text("Set date for news"),
                  leading: Icon(
                    Icons.notifications_none_sharp,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "App Settings",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                title: Text("Data clear"),
                subtitle: Text("Clearing the app data"),
                leading: Icon(
                  Icons.clear_outlined,
                  color: Colors.blue,
                ),
              ),
            ),
            Center(
              child: OutlinedButton(
                  onPressed: () {
                    AuthenticationRepository.instance.signOut();
                  },
                  child: Text("Logout")),
            )
          ])),
    );
  }
}

Container Circleui(double height, double width) {
  return Container(
    height: height * .4,
    width: width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(400),
      color: Color.fromARGB(255, 251, 249, 249).withOpacity(0.2),
    ),
  );
}
