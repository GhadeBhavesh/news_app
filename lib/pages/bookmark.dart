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
import 'package:hive/hive.dart';

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
