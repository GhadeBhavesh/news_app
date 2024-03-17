import 'dart:async';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/components/dropDownList.dart';
import 'package:news_app/components/font_size.dart';
import 'package:news_app/model/utils.dart';
import 'package:news_app/pages/ViewNews.dart';
import 'package:news_app/pages/bookmark.dart';
import "package:news_app/services/NewsController.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsController newsController = Get.put(NewsController());
  final _databaseRef = FirebaseDatabase.instance.reference().child('bookmarks');
  bool _showFilterChips = false;
  @override
  void initState() {
    super.initState();
    getStoredCategory().then((category) {
      if (category != null) {
        setState(() {
          dropdownValue = category;
        });
        dropdownValue = category;
        newsController.category.value = category;
        newsController.getNews();
        updateNewsCategory(getStoredCategory() as String);
      }
    });
  }

  Future<void> _saveBookmark(news) async {
    try {
      final key = _databaseRef.push().key;
      await _databaseRef.child(key!).set({
        'title': news.title,
        'imageUrl': news.imageUrl,
      });
    } catch (error) {
      print('Error saving bookmark: $error');
    }
  }

  Future<void> _removeBookmark(String title) async {
    try {
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
    final snapshot = await FirebaseDatabase.instance
        .reference()
        .child('selectedCategory')
        .get();
    return snapshot.value as String?;
  }

  Future<String?> getStoredChannel() async {
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

  void saveSelectedCategory(String categoryCode) async {
    await FirebaseDatabase.instance
        .reference()
        .child('selectedCategory')
        .set(categoryCode);
  }

  void saveSelectedChannel(String channelCode) async {
    await FirebaseDatabase.instance
        .reference()
        .child('selectedChannel')
        .set(channelCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Headlines"),
        leading: IconButton(
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
          icon: Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showFilterChips = !_showFilterChips; // Toggle visibility
              });
            },
            icon: Icon(Icons.filter_list),
          ),
          // IconButton(
          //   onPressed: () {
          //     newsController.country.value = '';
          //     newsController.category.value = '';
          //     newsController.findNews.value = '';
          //     newsController.cName.value = '';
          //     newsController.getNews(reload: true);
          //     newsController.update();
          //   },
          //   icon: Icon(Icons.refresh),
          // ),
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
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search any Thing",
                      ),
                      scrollPadding: EdgeInsets.all(5),
                      onChanged: (val) {
                        newsController.findNews.value = val;
                        newsController.getNews(
                            searchKey: val); // Update news on text change
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_showFilterChips)
            Wrap(
              spacing: 8.0,
              children:
                  List<Widget>.generate(listOfCategory.length, (int index) {
                return FilterChip(
                  label: Text(listOfCategory[index]['name']!.toUpperCase()),
                  selected: dropdownValue == listOfCategory[index]['code'],
                  onSelected: (bool selected) {
                    setState(() {
                      dropdownValue =
                          (selected ? listOfCategory[index]['code'] : null)!;
                      newsController.category.value = dropdownValue;
                      newsController.getNews();
                      saveSelectedCategory(
                          dropdownValue ?? ''); // Save selected category
                      updateNewsCategory(
                          dropdownValue ?? ''); // Update news category
                    });
                  },
                );
              }),
            ),

          // ExpansionTile(
          //   title: Text("Category :$dropdownValue"),
          //   onExpansionChanged: (expanded) async {
          //     setState(() {
          //       _isCategoryExpanded = expanded;
          //     });
          //   },
          //   children: [
          //     for (int i = 0; i < listOfCategory.length; i++)
          //       dropDownList(
          //         call: () {
          //           Get.back();
          //           newsController.category.value = listOfCategory[i]['code']!;
          //           newsController.getNews();
          //           saveSelectedCategory(listOfCategory[i]['code']!);
          //           updateNewsCategory(listOfCategory[i]['code']!);
          //           dropdownValue = listOfCategory[i]['code']!;
          //           setState(() {
          //             _isCountryExpanded = false;
          //           });
          //         },
          //         name: listOfCategory[i]['name']!.toUpperCase(),
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
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Image Container
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    Container(
                                                  color: Colors.grey[200],
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                                imageUrl: controller.news[index]
                                                        .urlToImage ??
                                                    '',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          // Title and Source Container
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Title
                                                Text(
                                                  controller.news[index].title,
                                                  style: TextStyle(
                                                    fontSize: Provider.of<
                                                                FontSizeProvider>(
                                                            context)
                                                        .fontSize,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 5),
                                                // Source Name
                                                Text(
                                                  "${controller.news[index].source.name}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        Provider.of<FontSizeProvider>(
                                                                    context)
                                                                .fontSize -
                                                            2,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
              },
              init: NewsController(),
            ),
          ),
        ],
      ),
    );
  }
}
