import 'package:flutter/material.dart';
import 'package:news_app/pages/account_page.dart';
import 'package:news_app/components/home_ui.dart';

class bookmarkPage extends StatefulWidget {
  const bookmarkPage({super.key});

  @override
  State<bookmarkPage> createState() => _bookmarkPageState();
}

class _bookmarkPageState extends State<bookmarkPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          // surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text(
            // user.displayName,
            "jskd",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.manage_accounts_sharp,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  // Get.off(NotificationPage(selectedCategory: selectedCategory));
                },
                icon: Icon(
                  Icons.notifications_on_rounded,
                  color: Colors.white,
                )),
          ],
        ),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipPath(
            clipper: TCustomCurvedEdges(),
            child: Container(
              color: Color.fromARGB(255, 0, 51, 255),
              child: SizedBox(
                height: height * .2,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      top: -250,
                      right: -300,
                      child: Circleui(height, width),
                    ),
                    Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Popular Category",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
          ),
        ])));
  }
}
