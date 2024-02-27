import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/components/dropDownList.dart';
import 'package:news_app/components/sideDrawer.dart';
import 'package:news_app/model/utils.dart';
import 'package:news_app/pages/ViewNews.dart';
import 'package:news_app/pages/bookmark.dart';
import 'package:news_app/pages/category_Page.dart';
import "package:news_app/services/NewsController.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _categoryRef =
      FirebaseDatabase.instance.reference().child('selectedCategory');
  final DatabaseReference _channelRef =
      FirebaseDatabase.instance.reference().child('selectedChannel');
  NewsController newsController = Get.put(NewsController());
  List<int> bookmarkedIndexes = []; // List to store bookmarked news indexes

  bool _isCountryExpanded = false;
  bool _isCategoryExpanded = false;
  bool _isChannelExpanded = false;
  String dropdownValue = 'in';
  void saveSelectedCategory(String category) {
    _categoryRef.set(category);
  }

  // Method to store selected channel in Firebase
  void saveSelectedChannel(String channel) {
    _channelRef.set(channel);
  }

  Future<String?> getSelectedCategory() async {
    String? selectedCategory;
    try {
      DataSnapshot snapshot = (await _categoryRef.once()) as DataSnapshot;
      selectedCategory = snapshot.value as String?;
    } catch (error) {
      print("Error getting selected category: $error");
    }
    return selectedCategory;
  }

  Future<String?> getSelectedChannel() async {
    String? selectedChannel;
    try {
      DataSnapshot snapshot = (await _channelRef.once()) as DataSnapshot;
      selectedChannel = snapshot.value as String?;
    } catch (error) {
      print("Error getting selected channel: $error");
    }
    return selectedChannel;
  }

  // Method to retrieve selected channel from Firebase

  // void toggleBookmark(int index) {
  //   newsController.toggleBookmark(index);
  // }

// Inside your GestureDetector or IconButton in the news card

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("News"),
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
        drawer: sideDrawer(newsController),
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
            title: Text("Category"),
            onExpansionChanged: (expanded) async {
              if (expanded) {
                String? selectedCategory = (await getSelectedCategory());
                if (selectedCategory != null) {
                  // Update UI with selected category
                }
              }
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
                    setState(() {
                      _isCountryExpanded = false;
                    });
                  },
                  name: listOfCategory[i]['name']!.toUpperCase(),
                )
            ],
          ),
          ExpansionTile(
            title: Text("Channel"),
            onExpansionChanged: (expanded) async {
              if (expanded) {
                String? selectedChannel = (await getSelectedChannel());
                if (selectedChannel != null) {
                  // Update UI with selected channel
                }
              }
              setState(() {
                _isChannelExpanded = expanded;
              });
            },
            children: [
              for (int i = 0; i < listOfNewsChannel.length; i++)
                dropDownList(
                  call: () {
                    Get.back();
                    newsController.getNews(
                      channel: listOfNewsChannel[i]['code'],
                    );
                    saveSelectedChannel(listOfNewsChannel[i]['code']!);
                    setState(() {
                      _isChannelExpanded = false;
                    });
                  },
                  name: listOfNewsChannel[i]['name']!.toUpperCase(),
                ),
            ],
          ),
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
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: IconButton(
                                                  icon: Icon(
                                                    // Check if the current index is bookmarked
                                                    bookmarkedIndexes
                                                            .contains(index)
                                                        ? Icons.bookmark
                                                        : Icons.bookmark_border,
                                                    // Change the icon color to red if bookmarked
                                                    color: bookmarkedIndexes
                                                            .contains(index)
                                                        ? Colors.red
                                                        : null,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      controller.toggleBookmark(
                                                          index);
                                                      // Toggle bookmark status
                                                      if (bookmarkedIndexes
                                                          .contains(index)) {
                                                        bookmarkedIndexes
                                                            .remove(index);
                                                      } else {
                                                        bookmarkedIndexes
                                                            .add(index);
                                                      }
                                                    });
                                                  },
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

  void updateNewsCategory(String selectedValue) {
    newsController.category.value = selectedValue;
    newsController.getNews();
  }
}
