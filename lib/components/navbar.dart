import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/Bookmark_Page.dart';
import 'package:news_app/pages/Home_page.dart';
import 'package:news_app/pages/account_page.dart';
import 'package:news_app/pages/category_Page.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late DateTime yesterday;
  late DateTime fromDate;
  late DateTime toDate;
  late List<Widget> _pages;

  var primary = Color.fromARGB(255, 222, 66, 14);
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    yesterday = DateTime.now();
    fromDate = yesterday.subtract(Duration(days: 1));
    toDate = DateTime.now();
    _pages = [
      Home(),
      CategoryNews(
        name: '',
      ),
      bookmarkPage(),
      Account(),
    ];
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: _pages,
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              activeColor: const Color.fromARGB(255, 0, 51, 255),
              inactiveColor: Colors.black,
              title: Text('Home', style: TextStyle(color: Colors.black)),
              icon: Icon(Icons.home),
            ),
            BottomNavyBarItem(
              activeColor: const Color.fromARGB(255, 0, 51, 255),
              inactiveColor: Colors.black,
              title: SelectableText(
                'Category',
                style: TextStyle(color: Colors.black),
              ),
              icon: Icon(Icons.category),
            ),
            BottomNavyBarItem(
              activeColor: const Color.fromARGB(255, 0, 51, 255),
              inactiveColor: Colors.black,
              title: Text('Bookmarks', style: TextStyle(color: Colors.black)),
              icon: Icon(Icons.bookmark),
            ),
            BottomNavyBarItem(
              activeColor: const Color.fromARGB(255, 0, 51, 255),
              inactiveColor: Colors.black,
              title: Text('Account', style: TextStyle(color: Colors.black)),
              icon: Icon(Icons.manage_accounts_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
