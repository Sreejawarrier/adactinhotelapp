import 'package:adactin_hotel_app/account/login/page/login_page.dart';
import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:adactin_hotel_app/app/bloc/app_tab_bloc.dart';
import 'package:adactin_hotel_app/app/constants/app_content.dart';
import 'package:adactin_hotel_app/app/constants/app_semantic_keys.dart';
import 'package:adactin_hotel_app/base/spinner/spinner.dart';
import 'package:adactin_hotel_app/home/page/home.dart';
import 'package:adactin_hotel_app/search/page/search.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppContainerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppContainerWidgetState();
}

class _AppContainerWidgetState extends State<AppContainerWidget> {
  final Duration _bottomNavBarDuration = const Duration(milliseconds: 200);

  int _selectedTabIndex = 0;

  List<FFNavigationBarItem> _ffNavBarItemList = List();

  @override
  Widget build(BuildContext context) {
    _ffNavBarItemList = _getFFNavBarItems();

    return BlocListener(
      bloc: BlocProvider.of<AppBloc>(context),
      listener: (BuildContext context, AppState state) {
        if (state is AppUserChanged) {
          BlocProvider.of<AppTabBloc>(context)
              .add(AppTabSelect(tab: AppTab.home));
        } else if (state is AppStarted) {
          BlocProvider.of<AppTabBloc>(context)
              .add(AppTabSelect(tab: AppTab.account));
        }
      },
      child: BlocBuilder(
        bloc: BlocProvider.of<AppBloc>(context),
        builder: (BuildContext context, AppState state) {
          if (state is AppLoading) {
            return Container(
              color: Palette.primaryColor,
              child: Spinner(spinnerColor: Colors.white),
            );
          }

          return BlocBuilder(
            bloc: BlocProvider.of<AppTabBloc>(context),
            builder: (BuildContext context, AppTabState state) {
              _selectedTabIndex = _getAppTabIndex(state);

              return DefaultTabController(
                length: _ffNavBarItemList.length,
                initialIndex: 0,
                child: Scaffold(
                  body: SafeArea(
                    child: Builder(
                      builder: (BuildContext context) {
                        /// Below check is when we try to move automatically from
                        /// one screen tab to another screen tab via bloc call
                        /// of the apptabbloc. Ex: On successful login we move to
                        /// home screen at that time we pass user change app bloc
                        /// event then we try to move to home tab via bloc call.
                        /// So at that time if we see that the default tab controller
                        /// index is not equal to the needed one we animate to it.
                        final int curIndex =
                            DefaultTabController.of(context).index;
                        if (curIndex != _selectedTabIndex) {
                          DefaultTabController.of(context)
                              .animateTo(_selectedTabIndex);
                        }

                        return TabBarView(
                          children: _getTabViews(context),
                          physics: NeverScrollableScrollPhysics(),
                        );
                      },
                    ),
                  ),
                  bottomNavigationBar: Builder(
                    builder: (BuildContext context) =>
                        _getBottomNavBar(context),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Returns int value based on the apptab enum value
  int _getAppTabIndex(AppTabState state) {
    if (state is AppTabChosen) {
      switch (state.tab) {
        case AppTab.search:
          return 1;
        case AppTab.account:
          return 2;
        default:
          return 0;
      }
    }

    return 0;
  }

  /// Returns app tab enum based on the index
  AppTab _getAppTab(int index) {
    switch (index) {
      case 1:
        return AppTab.search;
      case 2:
        return AppTab.account;
      default:
        return AppTab.home;
    }
  }

  /// Returns the list of widgets which we will be showing for a tab bar
  List<Widget> _getTabViews(BuildContext context) {
    return [
      Home(),
      Search(),
//      Book(),
      Login(appBloc: BlocProvider.of<AppBloc>(context)),
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

  /// Constructs bottom navigation bar
  Widget _getBottomNavBar(BuildContext context) {
    return Semantics(
      enabled: true,
      label: AppSemanticKeys.bottomNavigationBar,
      child: ExcludeSemantics(
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
            if (BlocProvider.of<AppBloc>(context).userDetails != null) {
              DefaultTabController.of(context).index = index;
              BlocProvider.of<AppTabBloc>(context)
                  .add(AppTabSelect(tab: _getAppTab(index)));
            } else if (index != 2) {
              Scaffold.of(context).hideCurrentSnackBar();
              final SnackBar snackBar = SnackBar(
                duration: Duration(milliseconds: 1000),
                content: Semantics(
                  label: AppSemanticKeys.snackBarNeedLogIn,
                  enabled: true,
                  child: ExcludeSemantics(
                    child: Text(AppContent.needLogIn),
                  ),
                ),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            }
          },
        ),
      ),
    );
  }
}
