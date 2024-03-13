import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:news_app/services/NewsController.dart';

class BookmarksPage extends StatefulWidget {
  final List<int> bookmarkedIndexes;

  const BookmarksPage({Key? key, required this.bookmarkedIndexes})
      : super(key: key);

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  List<int> bookmarkedIndexes = [];
  NewsController newsController = Get.put(NewsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
        leading: IconButton(
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
            icon: Icon(Icons.menu)),
      ),
      body: ListView.builder(
          itemCount: widget.bookmarkedIndexes.length,
          // controller: controller.scrollController,
          itemBuilder: (context, index) {
            final newsIndex = widget.bookmarkedIndexes[index];
            final news = newsController.news[newsIndex];
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            imageUrl:
                                newsController.news[index].urlToImage ?? '',
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Card(
                            elevation: 0,
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              child: Text(
                                "${news.source.name}",
                                style: Theme.of(context).textTheme.titleSmall,
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
                              Icons.bookmark,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                // Toggle bookmark status
                                if (bookmarkedIndexes.contains(index)) {
                                  bookmarkedIndexes.remove(newsIndex);
                                  Get.find<NewsController>().update();
                                } else {
                                  bookmarkedIndexes.add(index);
                                }
                              });
                              // Get.find<NewsController>()
                              //     .removeBookmark(newsIndex);
                              // // Refresh the UI
                              // Get.find<NewsController>().update();
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Text(
                      "${news.title}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      // title: Text(news.title),
      // // subtitle: Text(news.description),
      // onTap: () {
      //   // Navigate to the detailed view of the bookmarked news item
      //   Get.to(ViewNews(newsUrl: news.url));
      // },
    );
  }
}
