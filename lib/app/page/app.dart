import 'package:adactin_hotel_app/account/login/page/login_page.dart';
import 'package:adactin_hotel_app/app/constants/app_content.dart';
import 'package:adactin_hotel_app/app/constants/app_semantic_keys.dart';
import 'package:adactin_hotel_app/home/page/home.dart';
import 'package:adactin_hotel_app/search/page/search.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  final Duration _bottomNavBarDuration = const Duration(milliseconds: 200);

  int _selectedTabIndex = 0;

  List<FFNavigationBarItem> _ffNavBarItemList = List();

  @override
  Widget build(BuildContext context) {
    _ffNavBarItemList = _getFFNavBarItems();

    return DefaultTabController(
      length: _ffNavBarItemList.length,
      initialIndex: 0,
      child: Scaffold(
        body: SafeArea(
          child: Builder(
            builder: (BuildContext context) {
              return TabBarView(
                children: _getTabViews(context),
                physics: NeverScrollableScrollPhysics(),
              );
            },
          ),
        ),
        bottomNavigationBar: Builder(
          builder: (BuildContext context) => Semantics(
            enabled: true,
            label: AppSemanticKeys.bottomNavigationBar,
            child: FFNavigationBar(
              theme: FFNavigationBarTheme(
                barBackgroundColor: Colors.white,
                selectedItemBorderColor: Colors.white,
                selectedItemBackgroundColor: Palette.primaryColor,
                selectedItemIconColor: Colors.white,
                selectedItemLabelColor: Colors.black,
              ),
              selectedIndex: _selectedTabIndex,
              items: _ffNavBarItemList,
              onSelectTab: (index) {
                DefaultTabController.of(context).index = index;
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the list of widgets which we will be showing for a tab bar
  List<Widget> _getTabViews(BuildContext context) {
    return [
      Home(),
      Search(),
//      Book(),
      Login(),
    ];
  }

  /// List of FFNavigationBarItem's which we show in the bottom navigation bar
  List<FFNavigationBarItem> _getFFNavBarItems() {
    return [
      FFNavigationBarItem(
        iconData: Icons.home,
        label: AppContent.home,
        animationDuration: _bottomNavBarDuration,
      ),
      FFNavigationBarItem(
        iconData: Icons.search,
        label: AppContent.search,
        animationDuration: _bottomNavBarDuration,
      ),
//      FFNavigationBarItem(
//        iconData: Icons.error,
//        label: AppContent.book,
//        animationDuration: _bottomNavBarDuration,
//      ),
      FFNavigationBarItem(
        iconData: Icons.account_circle,
        label: AppContent.account,
        animationDuration: _bottomNavBarDuration,
      ),
    ];
  }
}
