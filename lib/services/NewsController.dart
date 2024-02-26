import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/model/ArticalModel.dart';
import 'package:news_app/model/NewsModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsController extends GetxController {
  List<int> bookmarkedIndexes = [];
  CollectionReference newsCollection =
      FirebaseFirestore.instance.collection('news');
  List<Article> news = <Article>[];
  ScrollController scrollController = ScrollController();
  RxBool notFound = false.obs;
  RxBool isLoading = false.obs;
  RxString cName = ''.obs;
  RxString country = ''.obs;
  RxString category = ''.obs;
  RxString findNews = ''.obs;
  RxInt pageNum = 1.obs;
  dynamic isSwitched = false.obs;
  dynamic isPageLoading = false.obs;
  RxInt pageSize = 10.obs;
  String baseApi = "https://newsapi.org/v2/top-headlines?";

  getNewsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await newsCollection.get();
      List<Article> fetchedNews = querySnapshot.docs
          .map((doc) => Article.fromJson(doc.data()
              as Map<String, dynamic>)) // Cast to Map<String, dynamic>
          .toList();
      news = fetchedNews;
      update();
    } catch (e) {
      print("Error fetching news: $e");
    }
  }

  void toggleBookmark(int index) {
    if (bookmarkedIndexes.contains(index)) {
      bookmarkedIndexes.remove(index);
    } else {
      bookmarkedIndexes.add(index);
    }
    update(); // Call update to notify GetBuilder of changes
  }

  @override
  void onInit() {
    // scrollController = new ScrollController()..addListener(_scrollListener);
    getNews();
    super.onInit();
  }

  changeTheme(value) {
    Get.changeTheme(value == true ? ThemeData.dark() : ThemeData.light());
    isSwitched = value;
    update();
  }

  // _scrollListener() {
  //   if (scrollController.position.pixels ==
  //       scrollController.position.maxScrollExtent) {
  //     isLoading.value = true;
  //     getNews();
  //   }
  // }

  getNews({channel = '', searchKey = '', reload = false}) async {
    notFound.value = false;

    if (!reload && isLoading.value == false) {
    } else {
      country.value = '';
      category.value = '';
    }
    if (isLoading.value == true) {
      pageNum++;
    } else {
      news = [];

      pageNum.value = 1;
    }
    baseApi = "https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&";
    baseApi += country == '' ? 'country=in&' : 'country=$country&';
    baseApi += category == '' ? '' : 'category=$category&';
    baseApi += 'apiKey=866e37213c6b497eb3dfee12ac4e2b57';
    if (channel != '') {
      country.value = '';
      category.value = '';
      baseApi =
          "https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&sources=$channel&apiKey=866e37213c6b497eb3dfee12ac4e2b57";
    }
    if (searchKey != '') {
      country.value = '';
      category.value = '';
      baseApi =
          "https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&q=$searchKey&apiKey=866e37213c6b497eb3dfee12ac4e2b57";
    }
    print(baseApi);
    getDataFromApi(baseApi);
  }

  getDataFromApi(url) async {
    // update();
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      NewsModel newsData = NewsModel.newsFromJson(res.body);

      if (newsData.articles.length == 0 && newsData.totalResults == 0) {
        notFound.value = isLoading.value == true ? false : true;
        isLoading.value = false;
        update();
      } else {
        if (isLoading.value == true) {
          news = [...news, ...newsData.articles];
          update();
        } else {
          if (newsData.articles.length != 0) {
            news = newsData.articles;
            if (scrollController.hasClients) scrollController.jumpTo(0.0);
            update();
          }
        }
        notFound.value = false;
        isLoading.value = false;
        update();
      }
    } else {
      notFound.value = true;
      update();
    }
  }
}
