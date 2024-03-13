import 'dart:async';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/components/dropDownList.dart';
import 'package:news_app/model/utils.dart';
import 'package:news_app/pages/ViewNews.dart';
import 'package:news_app/pages/bookmark.dart';
import "package:news_app/services/NewsController.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsController newsController = Get.put(NewsController());
  final _databaseRef = FirebaseDatabase.instance
      .reference()
      .child('bookmarks'); // Change 'bookmarks' to your desired path

  @override
  void initState() {
    super.initState();
    getStoredCategory().then((category) {
      if (category != null) {
        setState(() {
          dropdownValue =
              category; // Update dropdownValue when category is retrieved
        });
        dropdownValue = category;
        newsController.category.value = category;
        newsController.getNews(); // Update news based on retrieved category
        updateNewsCategory(getStoredCategory() as String);
      }
    });
    // getStoredChannel().then((channel) {
    //   if (channel != null) {
    //     dropdownValue = channel;
    //     newsController.category.value = channel;
    //     newsController.getNews();
    //     updateNewsChannel(getStoredChannel() as String);
    //   }
    // });
  }

  Future<void> _saveBookmark(news) async {
    try {
      final key =
          _databaseRef.push().key; // Generate a unique key for the bookmark
      await _databaseRef.child(key!).set({
        'title': news.title,
        'imageUrl': news.imageUrl,
        // Add other relevant fields as needed
      });
    } catch (error) {
      print('Error saving bookmark: $error');
    }
  }

  Future<void> _removeBookmark(String title) async {
    try {
      // Query bookmarks based on title (modify based on your data structure)
      final snapshot =
          await _databaseRef.orderByChild('title').equalTo(title).get();
    } catch (error) {
      print('Error removing bookmark: $error');
    }
  }

  bool _isCountryExpanded = false;
  bool _isCategoryExpanded = false;
  bool _isChannelExpanded = false;
  String dropdownValue = 'in';
  Future<String?> getStoredCategory() async {
    // Replace with your database access code (e.g., Firebase Realtime Database)
    final snapshot = await FirebaseDatabase.instance
        .reference()
        .child('selectedCategory')
        .get();
    return snapshot.value as String?;
  }

  Future<String?> getStoredChannel() async {
    // Replace with your database access code (e.g., Firebase Realtime Database)
    final snapshot = await FirebaseDatabase.instance
        .reference()
        .child('selectedChannel')
        .get();
    return snapshot.value as String?;
  }

  void updateNewsCategory(String selectedValue) {
    newsController.category.value = selectedValue;
    newsController.getNews();
  }

  void updateNewsChannel(String selectedValue) {
    newsController.cName.value = selectedValue;
    newsController.getNews();
  }

// Inside your GestureDetector or IconButton in the news card
  void saveSelectedCategory(String categoryCode) async {
    // Replace with your database access code (e.g., Firebase Realtime Database)
    await FirebaseDatabase.instance
        .reference()
        .child('selectedCategory')
        .set(categoryCode);
  }

  void saveSelectedChannel(String channelCode) async {
    // Replace with your database access code (e.g., Firebase Realtime Database)
    await FirebaseDatabase.instance
        .reference()
        .child('selectedChannel')
        .set(channelCode);
  }

  @override
  Widget build(BuildContext context) {
    final _databaseRef = FirebaseDatabase.instance
        .reference()
        .child('bookmarks'); // Change 'bookmarks'
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("Headlines"),
          leading: IconButton(
              onPressed: () => ZoomDrawer.of(context)!.toggle(),
              icon: Icon(Icons.menu)),
          actions: [
            IconButton(
              onPressed: () {
                newsController.country.value = '';
                newsController.category.value = '';
                newsController.findNews.value = '';
                newsController.cName.value = '';
                newsController.getNews(reload: true);
                newsController.update();
              },
              icon: Icon(Icons.refresh),
            ),
            GetBuilder<NewsController>(
              builder: (controller) => Switch(
                value: controller.isSwitched == true ? true : false,
                onChanged: (value) => controller.changeTheme(value),
                activeTrackColor: Colors.yellow,
                activeColor: Colors.red,
              ),
              init: NewsController(),
            ),
          ],
        ),
        body: Column(children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Search any Thing",
                      ),
                      scrollPadding: EdgeInsets.all(5),
                      onChanged: (val) {
                        newsController.findNews.value = val;
                        newsController.update();
                      },
                    ),
                  ),
                ),
                MaterialButton(
                  child: Text("Search"),
                  onPressed: () async {
                    newsController.getNews(
                      searchKey: newsController.findNews.value,
                    );
                  },
                ),
              ],
            ),
          ),
          ExpansionTile(
            title: Text("Category :$dropdownValue"),
            onExpansionChanged: (expanded) async {
              setState(() {
                _isCategoryExpanded = expanded;
              });
            },
            children: [
              for (int i = 0; i < listOfCategory.length; i++)
                dropDownList(
                  call: () {
                    Get.back();
                    newsController.category.value = listOfCategory[i]['code']!;
                    newsController.getNews();
                    saveSelectedCategory(listOfCategory[i]['code']!);
                    updateNewsCategory(listOfCategory[i]['code']!);
                    dropdownValue = listOfCategory[i]
                        ['code']!; // Call to store the category
                    setState(() {
                      _isCountryExpanded = false;
                    });
                  },
                  name: listOfCategory[i]['name']!.toUpperCase(),
                ),
            ],
          ),
          // ExpansionTile(
          //   title: Text("Channel"),
          //   onExpansionChanged: (expanded) async {
          //     setState(() {
          //       _isChannelExpanded = expanded;
          //     });
          //   },
          //   children: [
          //     for (int i = 0; i < listOfNewsChannel.length; i++)
          //       dropDownList(
          //         call: () {
          //           Get.back();
          //           newsController.cName.value = listOfNewsChannel[i]['code']!;
          //           newsController.getNews();
          //           saveSelectedChannel(listOfNewsChannel[i]['code']!);
          //           updateNewsChannel(listOfNewsChannel[i]['code']!);
          //           dropdownValue = listOfNewsChannel[i]['code']!;
          //           setState(() {
          //             _isChannelExpanded = false;
          //           });
          //         },
          //         name: listOfNewsChannel[i]['name']!.toUpperCase(),
          //       ),
          //   ],
          // ),
          Expanded(
            child: GetBuilder<NewsController>(
              builder: (controller) {
                return controller.notFound.value
                    ? Center(
                        child: Text(
                          "Not Found",
                          style: TextStyle(fontSize: 30),
                        ),
                      )
                    : controller.news.length == 0
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            controller: controller.scrollController,
                            itemCount: controller.news.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: GestureDetector(
                                    onTap: () => Get.to(
                                      ViewNews(
                                        newsUrl: controller.news[index].url,
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              controller.news[index]
                                                          .urlToImage ==
                                                      null
                                                  ? Container()
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: CachedNetworkImage(
                                                        placeholder:
                                                            (context, url) =>
                                                                Container(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                        imageUrl: controller
                                                                .news[index]
                                                                .urlToImage ??
                                                            '',
                                                      ),
                                                    ),
                                              Positioned(
                                                bottom: 8,
                                                right: 8,
                                                child: Card(
                                                  elevation: 0,
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.8),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                      vertical: 8,
                                                    ),
                                                    child: Text(
                                                      "${controller.news[index].source.name}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          Text(
                                            "${controller.news[index].title}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          // IconButton(
                                          //   icon: Icon(
                                          //     controller
                                          //             .news[index].isBookmarked
                                          //         ? Icons.bookmark
                                          //         : Icons.bookmark_border,
                                          //     color: Colors.blue,
                                          //   ),
                                          //   onPressed: () => setState(() {
                                          //     controller.news[index]
                                          //             .isBookmarked =
                                          //         !controller
                                          //             .news[index].isBookmarked;
                                          //     if (controller
                                          //         .news[index].isBookmarked) {
                                          //       // Save to database when bookmarked
                                          //       _saveBookmark(
                                          //           controller.news[index]);
                                          //     } else {
                                          //       // Remove from database when unbookmarked (optional)
                                          //       _removeBookmark(controller
                                          //           .news[index]
                                          //           .title); // Implement _removeBookmark function
                                          //     }
                                          //   }),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            // itemCount: controller.news.length,
                          );
              },
              init: NewsController(),
            ),
          ),
        ]));
  }
}
