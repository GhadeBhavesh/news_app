import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/components/home_ui.dart';
import 'package:news_app/pages/account_page.dart';
import 'package:news_app/pages/all_news.dart';
import 'package:news_app/pages/category_Page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/models/slider_model.dart';
import 'package:news_app/services/data.dart';
import 'package:news_app/services/news.dart';
import 'package:news_app/services/slider_data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;
  List<CategoryModel> categories = [];
  List<sliderModel> sliders = [];
  List<ArticleModel> articles = [];
  bool _loading = true, loading2 = true;

  int activeIndex = 0;
  @override
  void initState() {
    categories = getCategories();
    getSlider();
    getNews();
    super.initState();
  }

  getNews() async {
    News newsclass = News();
    await newsclass.getNews();
    articles = newsclass.news;
    setState(() {
      _loading = false;
    });
  }

  getSlider() async {
    Sliders slider = Sliders();
    await slider.getSlider();
    sliders = slider.sliders;
    setState(() {
      loading2 = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          user!.displayName!,
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
              onPressed: () {},
              icon: Icon(
                Icons.notifications_on_rounded,
                color: Colors.white,
              )),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipPath(
                      clipper: TCustomCurvedEdges(),
                      child: Container(
                        color: Color.fromARGB(255, 0, 51, 255),
                        child: SizedBox(
                          height: height * .3,
                          child: Stack(
                            children: [
                              Positioned(
                                top: -250,
                                right: -300,
                                child: Circleui(height, width),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Breaking News!",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AllNews(news: "Breaking")));
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    loading2
                        ? Center(child: CircularProgressIndicator())
                        : CarouselSlider.builder(
                            itemCount: 5,
                            itemBuilder: (context, index, realIndex) {
                              String? res = sliders[index].urlToImage;
                              String? res1 = sliders[index].title;
                              return buildImage(res!, index, res1!);
                            },
                            options: CarouselOptions(
                                height: 250,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.height,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    activeIndex = index;
                                  });
                                })),
                    SizedBox(
                      height: 30.0,
                    ),
                    Center(child: buildIndicator()),
                    SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Trending News!",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AllNews(news: "Trending")));
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildImage(String image, int index, String name) => Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: Stack(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            height: 250,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            imageUrl: image,
          ),
        ),
        Container(
          height: 250,
          padding: EdgeInsets.only(left: 10.0),
          margin: EdgeInsets.only(top: 170.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Center(
            child: Text(
              name,
              maxLines: 2,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ]));

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 5,
        effect: SlideEffect(
            dotWidth: 15, dotHeight: 15, activeDotColor: Colors.blue),
      );
}

class CategoryTile extends StatelessWidget {
  final image, categoryName;
  CategoryTile({this.categoryName, this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(name: categoryName)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                image,
                width: 120,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 120,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black38,
              ),
              child: Center(
                  child: Text(
                categoryName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )),
            )
          ],
        ),
      ),
    );
  }
}

//   Widget build(BuildContext context) {
//     final width = MediaQuery.sizeOf(context).width * 1;
//     final height = MediaQuery.sizeOf(context).height * 1;
//     return Scaffold(
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           automaticallyImplyLeading: false,
//           title: Text(
//             user!.displayName!,
//             style: TextStyle(color: Colors.white),
//           ),
//           actions: [
//             IconButton(
//                 onPressed: () {},
//                 icon: Icon(
//                   Icons.manage_accounts_sharp,
//                   color: Colors.white,
//                 )),
//             IconButton(
//                 onPressed: () {},
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
//                 height: height * .3,
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       top: -250,
//                       right: -300,
//                       child: Circleui(height, width),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               "Top Headlines",
//               style: TextStyle(fontSize: 20),
//             ),
//           ),
//           CarouselSlider(options: CarouselOptions(viewportFraction: 1), items: [
//             Container(
//                 child: ClipRRect(
//                     borderRadius: BorderRadius.circular(30),
//                     child: BlocBuilder<NewsBloc, NewsState>(
//                         builder: (BuildContext context, state) {
//                       switch (state.categoriesStatus) {
//                         case Status.initial:
//                           return Center(
//                             child: SpinKitCircle(
//                               size: 50,
//                               color: Colors.blue,
//                             ),
//                           );
//                         case Status.failure:
//                           return Text(state.categoriesMessage.toString());
//                         case Status.success:
//                           return ListView.builder(
//                               itemCount: state.newsList!.articles!.length,
//                               scrollDirection: Axis.horizontal,
//                               itemBuilder: (context, index) {
//                                 DateTime dateTime = DateTime.parse(
//                                   state.newsList!.articles![index].publishedAt
//                                       .toString(),
//                                 );
//                                 return SizedBox(
//                                     child: Stack(
//                                         alignment: Alignment.center,
//                                         children: [
//                                       Container(
//                                         height: height * 0.6,
//                                         width: width * .9,
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: height * .02),
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                           child: CachedNetworkImage(
//                                             imageUrl: state.newsList!
//                                                 .articles![index].urlToImage
//                                                 .toString(),
//                                             fit: BoxFit.cover,
//                                             placeholder: (context, url) =>
//                                                 Container(
//                                               child: spinKit2,
//                                             ),
//                                             errorWidget:
//                                                 (context, url, error) =>
//                                                     Image.asset(
//                                               "assets/splash_pic.jpg",
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Text(
//                                         format1.format(dateTime),
//                                         style: GoogleFonts.poppins(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                     ]));
//                               });
//                       }
//                     }))),
//           ]),
//         ])));
//   }

//   Container Circleui(double height, double width) {
//     return Container(
//       height: height * .4,
//       width: width,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(400),
//         color: Color.fromARGB(255, 251, 249, 249).withOpacity(0.2),
//       ),
//     );
//   }
// }

// const spinKit2 = SpinKitFadingCircle(
//   color: Colors.amber,
//   size: 50,
// );
