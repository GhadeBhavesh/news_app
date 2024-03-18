// import 'dart:html';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/model/ArticalModel.dart';
import 'package:news_app/pages/ViewNews.dart';
import 'package:news_app/services/NewsController.dart';
// import 'package:news_app/services/news.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = FavotiteProvider.of(context);
    final finallist = provider.favorite;
    return Scaffold(
        appBar: AppBar(
            // title: const Text('Material App Bar'),
            ),
        body: Expanded(
          child: ListView.builder(
              itemCount: finallist.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(6),
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: finallist[index].urlToImage ?? "",
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    title: Text(finallist[index].title),
                    // subtitle: finallist[index].,
                  ),
                );
              }),
        ));
  }
}

class FavotiteProvider extends ChangeNotifier {
  final List<Article> _favorites = [];
  List<Article> get favorite => _favorites;
  void toggleFavorite(Article news) {
    if (_favorites.contains(news)) {
      _favorites.remove(news);
    } else {
      _favorites.add(news);
    }
    notifyListeners();
  }

  bool isExit(Article news) {
    final isExit = _favorites.contains(news);
    return isExit;
  }

  static FavotiteProvider of(
    BuildContext context, {
    bool listen = true,
  }) {
    return Provider.of<FavotiteProvider>(context, listen: listen);
  }
}
// class BookmarksPage extends StatefulWidget {
//   final List<int> bookmarkedIndexes;

//   const BookmarksPage({Key? key, required this.bookmarkedIndexes})
//       : super(key: key);

//   @override
//   State<BookmarksPage> createState() => _BookmarksPageState();
// }

// class _BookmarksPageState extends State<BookmarksPage> {
//   List<int> bookmarkedIndexes = [];
//   NewsController newsController = Get.put(NewsController());
//   @override
//   Widget build(BuildContext context) {
//     var controller;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bookmarks'),
//       ),
//       body: ListView.builder(
//           itemCount: widget.bookmarkedIndexes.length,
//           // controller: controller.scrollController,
//           itemBuilder: (context, index) {
//             final newsIndex = widget.bookmarkedIndexes[index];
//             final news = newsController.news[newsIndex];
//             return Card(
//               elevation: 5,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                   vertical: 10,
//                   horizontal: 15,
//                 ),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Column(
//                   children: [
//                     Stack(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: CachedNetworkImage(
//                             placeholder: (context, url) => Container(
//                               child: CircularProgressIndicator(),
//                             ),
//                             errorWidget: (context, url, error) =>
//                                 Icon(Icons.error),
//                             imageUrl:
//                                 newsController.news[index].urlToImage ?? '',
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 8,
//                           right: 8,
//                           child: Card(
//                             elevation: 0,
//                             color:
//                                 Theme.of(context).primaryColor.withOpacity(0.8),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 8,
//                               ),
//                               child: Text(
//                                 "${news.source.name}",
//                                 style: Theme.of(context).textTheme.titleSmall,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           top: 8,
//                           right: 8,
//                           child: IconButton(
//                             icon: Icon(
//                               // Check if the current index is bookmarked
//                               Icons.bookmark,
//                               color: Colors.red,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 // Toggle bookmark status
//                                 if (bookmarkedIndexes.contains(index)) {
//                                   bookmarkedIndexes.remove(newsIndex);
//                                   Get.find<NewsController>().update();
//                                 } else {
//                                   bookmarkedIndexes.add(index);
//                                 }
//                               });
//                               // Get.find<NewsController>()
//                               //     .removeBookmark(newsIndex);
//                               // // Refresh the UI
//                               // Get.find<NewsController>().update();
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     Divider(),
//                     Text(
//                       "${news.title}",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }),
//       // title: Text(news.title),
//       // // subtitle: Text(news.description),
//       // onTap: () {
//       //   // Navigate to the detailed view of the bookmarked news item
//       //   Get.to(ViewNews(newsUrl: news.url));
//       // },
//     );
//   }
// }

// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:firebase_database/firebase_database.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
// // import 'package:get/get.dart';
// // import 'package:news_app/pages/ViewNews.dart';
// // import 'package:news_app/services/NewsController.dart';
// // import 'package:news_app/services/news.dart';

// // class Bookmark extends StatelessWidget {
// //   final bool isBookmarked;
// //   final VoidCallback onTap;

// //   const Bookmark({required this.isBookmarked, required this.onTap});

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Icon(
// //         isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
// //         color: Colors.red,
// //       ),
// //     );
// //   }
// // }

// // class BookmarkScreen extends StatefulWidget {
// //   @override
// //   _BookmarkScreenState createState() => _BookmarkScreenState();
// // }

// // class _BookmarkScreenState extends State<BookmarkScreen> {
// //   final _databaseRef = FirebaseDatabase.instance.reference().child('bookmarks');

// //   List<News> bookmarks = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _databaseRef.onChildAdded.listen(_onEntryAdded);
// //     _databaseRef.onChildChanged.listen(_onEntryChanged);
// //   }

// //   void _onEntryAdded(Event event) {
// //     setState(() {
// //       bookmarks.add(News.fromSnapshot(event.snapshot));
// //     });
// //   }

// //   void _onEntryChanged(Event event) {
// //     var old =
// //         bookmarks.singleWhere((entry) => entry.title == event.snapshot.key);
// //     setState(() {
// //       bookmarks[bookmarks.indexOf(old)] = News.fromSnapshot(event.snapshot);
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Bookmarks"),
// //       ),
// //       body: bookmarks.isEmpty
// //           ? Center(
// //               child: Text("No Bookmarks"),
// //             )
// //           : ListView.builder(
// //               itemCount: bookmarks.length,
// //               itemBuilder: (context, index) {
// //                 return ListTile(
// //                   leading: Image.network(
// //                     bookmarks[index].urlToImage ?? '',
// //                     width: 50,
// //                     height: 50,
// //                     fit: BoxFit.cover,
// //                   ),
// //                   title: Text(bookmarks[index].title),
// //                   subtitle: Text(bookmarks[index].source.name),
// //                   onTap: () {
// //                     Get.to(
// //                       ViewNews(
// //                         newsUrl: bookmarks[index].url,
// //                       ),
// //                     );
// //                   },
// //                 );
// //               },
// //             ),
// //     );
// //   }
// // }
// // // class BookmarksPage extends StatefulWidget {
// // //   final List<int> bookmarkedIndexes;

// // //   const BookmarksPage({Key? key, required this.bookmarkedIndexes})
// // //       : super(key: key);

// // //   @override
// // //   State<BookmarksPage> createState() => _BookmarksPageState();
// // // }

// // // class _BookmarksPageState extends State<BookmarksPage> {
// // //   List<int> bookmarkedIndexes = [];
// // //   NewsController newsController = Get.put(NewsController());
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Bookmarks'),
// // //         leading: IconButton(
// // //             onPressed: () => ZoomDrawer.of(context)!.toggle(),
// // //             icon: Icon(Icons.menu)),
// // //       ),
// // //       body: ListView.builder(
// // //           itemCount: widget.bookmarkedIndexes.length,
// // //           // controller: controller.scrollController,
// // //           itemBuilder: (context, index) {
// // //             final newsIndex = widget.bookmarkedIndexes[index];
// // //             final news = newsController.news[newsIndex];
// // //             return Card(
// // //               elevation: 5,
// // //               shape: RoundedRectangleBorder(
// // //                 borderRadius: BorderRadius.circular(20),
// // //               ),
// // //               child: Container(
// // //                 padding: EdgeInsets.symmetric(
// // //                   vertical: 10,
// // //                   horizontal: 15,
// // //                 ),
// // //                 decoration: BoxDecoration(
// // //                   borderRadius: BorderRadius.circular(30),
// // //                 ),
// // //                 child: Column(
// // //                   children: [
// // //                     Stack(
// // //                       children: [
// // //                         ClipRRect(
// // //                           borderRadius: BorderRadius.circular(20),
// // //                           child: CachedNetworkImage(
// // //                             placeholder: (context, url) => Container(
// // //                               child: CircularProgressIndicator(),
// // //                             ),
// // //                             errorWidget: (context, url, error) =>
// // //                                 Icon(Icons.error),
// // //                             imageUrl:
// // //                                 newsController.news[index].urlToImage ?? '',
// // //                           ),
// // //                         ),
// // //                         Positioned(
// // //                           bottom: 8,
// // //                           right: 8,
// // //                           child: Card(
// // //                             elevation: 0,
// // //                             color:
// // //                                 Theme.of(context).primaryColor.withOpacity(0.8),
// // //                             child: Padding(
// // //                               padding: const EdgeInsets.symmetric(
// // //                                 horizontal: 10,
// // //                                 vertical: 8,
// // //                               ),
// // //                               child: Text(
// // //                                 "${news.source.name}",
// // //                                 style: Theme.of(context).textTheme.titleSmall,
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ),
// // //                         Positioned(
// // //                           top: 8,
// // //                           right: 8,
// // //                           child: IconButton(
// // //                             icon: Icon(
// // //                               // Check if the current index is bookmarked
// // //                               Icons.bookmark,
// // //                               color: Colors.red,
// // //                             ),
// // //                             onPressed: () {
// // //                               setState(() {
// // //                                 // Toggle bookmark status
// // //                                 if (bookmarkedIndexes.contains(index)) {
// // //                                   bookmarkedIndexes.remove(newsIndex);
// // //                                   Get.find<NewsController>().update();
// // //                                 } else {
// // //                                   bookmarkedIndexes.add(index);
// // //                                 }
// // //                               });
// // //                               // Get.find<NewsController>()
// // //                               //     .removeBookmark(newsIndex);
// // //                               // // Refresh the UI
// // //                               // Get.find<NewsController>().update();
// // //                             },
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                     Divider(),
// // //                     Text(
// // //                       "${news.title}",
// // //                       style: TextStyle(
// // //                         fontWeight: FontWeight.bold,
// // //                         fontSize: 18,
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             );
// // //           }),
// // //       // title: Text(news.title),
// // //       // // subtitle: Text(news.description),
// // //       // onTap: () {
// // //       //   // Navigate to the detailed view of the bookmarked news item
// // //       //   Get.to(ViewNews(newsUrl: news.url));
// // //       // },
// // //     );
// // //   }
// // // }
