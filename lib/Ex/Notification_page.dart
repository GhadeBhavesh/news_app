// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:news_app/auth/authentication_repository.dart';
// import 'package:news_app/Ex/models/Notification_model.dart';
// import 'package:news_app/services/Notification_url.dart';

// class Notification_page extends StatefulWidget {
//   @override
//   _Notification_pageState createState() => _Notification_pageState();
// }

// class _Notification_pageState extends State<Notification_page> {
//   final Notification_url _categoryNews = Notification_url();
//   bool _isLoading = true;
//   List<NotificationModel> _categoryData = [];

//   @override
//   void initState() {
//     super.initState();
//     _getCategoryNews();
//   }

//   Future<void> _getCategoryNews() async {
//     try {
//       // Fetch saved category from Firestore instead of using widget.category
//       String savedCategory = await _getSavedCategoryFromFirestore();
//       await _categoryNews.getCategoriesNews(savedCategory);
//       setState(() {
//         _categoryData = _categoryNews.categories;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print("Error fetching category news: $e");
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<String> _getSavedCategoryFromFirestore() async {
//     String savedCategory = '';
//     try {
//       // Access Firestore instance
//       final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//       // Get the current user
//       final User? _user = AuthenticationRepository.instance.firebaseUser.value;

//       // Check if user is authenticated
//       if (_user != null) {
//         // Fetch the user's saved category from Firestore
//         final DocumentSnapshot documentSnapshot = await _firestore
//             .collection('categories')
//             .doc(_user.uid)
//             .collection('user_categories')
//             .doc(
//                 'saved_category') // Assuming there's a document named 'saved_category' containing the saved category
//             .get();

//         // Check if the document exists
//         if (documentSnapshot.exists) {
//           // Retrieve the saved category from the document
//           savedCategory = documentSnapshot['category'] ?? '';
//         }
//       }
//     } catch (e) {
//       print("Error fetching saved category from Firestore: $e");
//     }
//     return savedCategory;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Saved Category News'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _categoryData.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_categoryData[index].title ?? ''),
//                   subtitle: Text(_categoryData[index].description ?? ''),
//                   onTap: () {
//                     // Navigate to the URL when tapped
//                     // You can use a WebView or launch the URL in a browser
//                     // Example: launchURL(_categoryData[index].url);
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }
