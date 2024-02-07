// import 'package:flutter/material.dart';
// import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
// import 'package:news_app/pages/account_page.dart';
// import 'package:news_app/components/home_ui.dart';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class bookmarkPage extends StatefulWidget {
//   const bookmarkPage({super.key});

//   @override
//   State<bookmarkPage> createState() => _bookmarkPageState();
// }

// class _bookmarkPageState extends State<bookmarkPage> {
//   List<dynamic> articles = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchNews();
//     Timer.periodic(Duration(hours: 1), (Timer t) => fetchNews());
//   }

//   Future<void> fetchNews() async {
//     final String apiKey = '866e37213c6b497eb3dfee12ac4e2b57';
//     final String url =
//         'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey';

//     try {
//       final response = await http.get(Uri.parse(url));
//       final jsonData = json.decode(response.body);
//       setState(() {
//         articles = jsonData['articles'];
//       });
//     } catch (e) {
//       print('Error fetching news: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.sizeOf(context).width * 1;
//     final height = MediaQuery.sizeOf(context).height * 1;
//     return Scaffold(
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           // surfaceTintColor: Colors.transparent,
//           automaticallyImplyLeading: false,
//           title: Text(
//             "Bookmark",
//             style: TextStyle(color: Colors.white),
//           ),
//           leading: IconButton(
//               onPressed: () {
//                 SimpleHiddenDrawerController.of(context).toggle();
//               },
//               icon: Icon(
//                 Icons.menu,
//                 color: Colors.white,
//               )),
//           actions: [
//             IconButton(
//                 onPressed: () {},
//                 icon: Icon(
//                   Icons.manage_accounts_sharp,
//                   color: Colors.white,
//                 )),
//             IconButton(
//                 onPressed: () {
//                   // Get.off(NotificationPage(selectedCategory: selectedCategory));
//                 },
//                 icon: Icon(
//                   Icons.notifications_on_rounded,
//                   color: Colors.white,
//                 )),
//           ],
//         ),
//         body: SingleChildScrollView(
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           ClipPath(
//             clipper: TCustomCurvedEdges(),
//             child: Container(
//               color: Color.fromARGB(255, 0, 51, 255),
//               child: SizedBox(
//                 height: height * .2,
//                 width: double.infinity,
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       top: -250,
//                       right: -300,
//                       child: Circleui(height, width),
//                     ),
//                     Column(
//                         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         // crossAxisAlignment: CrossAxisAlignment.stretch,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               "Popular Category",
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 20),
//                             ),
//                           ),
//                           ListView.builder(
//                             itemCount: articles.length,
//                             itemBuilder: (context, index) {
//                               final article = articles[index];
//                               return ListTile(
//                                 title: Text(article['title']),
//                                 subtitle: Text(article['description'] ?? ''),
//                               );
//                             },
//                           ),
//                         ]),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ])));
//   }
// }
