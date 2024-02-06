import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/Bookmark_Page.dart';
import 'package:news_app/pages/Home_page.dart';
import 'package:news_app/pages/account_page.dart';
import 'package:news_app/pages/category_Page.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  var primary = Color.fromARGB(255, 222, 66, 14);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: HiddenDrawerMenu(
          // initPositionSelected: 5,
          disableAppBarDefault: true,
          withAutoTittleName: false,

          isTitleCentered: true,
          styleAutoTittleName: TextStyle(color: Colors.white),
          slidePercent: 50,
          backgroundColorMenu: Colors.blue,
          backgroundColorAppBar: Colors.blueAccent,
          screens: [
            ScreenHiddenDrawer(
                ItemHiddenMenu(
                  name: "Home",
                  colorLineSelected: Colors.white,
                  baseStyle: TextStyle(
                    color: Colors.white,
                  ),
                  selectedStyle: TextStyle(),
                ),
                Home()),
            ScreenHiddenDrawer(
                ItemHiddenMenu(
                  name: "Category",
                  colorLineSelected: Colors.white,
                  baseStyle: TextStyle(color: Colors.white),
                  selectedStyle: TextStyle(),
                ),
                CategoryNews(
                  name: '',
                )),
            ScreenHiddenDrawer(
                ItemHiddenMenu(
                  name: "Bookmark",
                  colorLineSelected: Colors.white,
                  baseStyle: TextStyle(color: Colors.white),
                  selectedStyle: TextStyle(),
                ),
                bookmarkPage()),
            ScreenHiddenDrawer(
                ItemHiddenMenu(
                  name: "Account",
                  colorLineSelected: Colors.white,
                  baseStyle: TextStyle(color: Colors.white),
                  selectedStyle: TextStyle(),
                ),
                Account()),
          ],
        ),
        // body: SizedBox.expand(
        //   child: PageView(
        //     controller: _pageController,
        //     onPageChanged: (index) {
        //       setState(() => _currentIndex = index);
        //     },
        //     children: _pages,
        //   ),
        // ),
        // bottomNavigationBar: BottomNavyBar(
        //   selectedIndex: _currentIndex,
        //   onItemSelected: (index) {
        //     setState(() => _currentIndex = index);
        //     _pageController.jumpToPage(index);
        //   },
        //   items: <BottomNavyBarItem>[
        //     BottomNavyBarItem(
        //       activeColor: const Color.fromARGB(255, 0, 51, 255),
        //       inactiveColor: Colors.black,
        //       title: Text('Home', style: TextStyle(color: Colors.black)),
        //       icon: Icon(Icons.home),
        //     ),
        //     BottomNavyBarItem(
        //       activeColor: const Color.fromARGB(255, 0, 51, 255),
        //       inactiveColor: Colors.black,
        //       title: SelectableText(
        //         'Category',
        //         style: TextStyle(color: Colors.black),
        //       ),
        //       icon: Icon(Icons.category),
        //     ),
        //     BottomNavyBarItem(
        //       activeColor: const Color.fromARGB(255, 0, 51, 255),
        //       inactiveColor: Colors.black,
        //       title: Text('Bookmarks', style: TextStyle(color: Colors.black)),
        //       icon: Icon(Icons.bookmark),
        //     ),
        //     BottomNavyBarItem(
        //       activeColor: const Color.fromARGB(255, 0, 51, 255),
        //       inactiveColor: Colors.black,
        //       title: Text('Account', style: TextStyle(color: Colors.black)),
        //       icon: Icon(Icons.manage_accounts_rounded),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
