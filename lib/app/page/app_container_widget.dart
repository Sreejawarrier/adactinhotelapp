import 'dart:async';

import 'package:adactin_hotel_app/account/login/page/login_page.dart';
import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:adactin_hotel_app/app/bloc/app_bottom_nav_bloc.dart';
import 'package:adactin_hotel_app/app/bloc/app_tab_bloc.dart';
import 'package:adactin_hotel_app/app/constants/app_content.dart';
import 'package:adactin_hotel_app/app/constants/app_semantic_keys.dart';
import 'package:adactin_hotel_app/base/spinner/spinner.dart';
import 'package:adactin_hotel_app/booked_itinerary/page/booked_itinerary_page.dart';
import 'package:adactin_hotel_app/home/page/home_page.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:quiver/async.dart';

class AppContainerWidget extends StatefulWidget {
  final AppBloc appBloc;
  final AppTabBloc appTabBloc;

  AppContainerWidget({@required this.appBloc, @required this.appTabBloc});

  @override
  State<StatefulWidget> createState() => _AppContainerWidgetState();
}

class _AppContainerWidgetState extends State<AppContainerWidget>
    with WidgetsBindingObserver {
  final Duration _bottomNavBarDuration = const Duration(milliseconds: 200);

  int _selectedTabIndex = 0;
  List<FFNavigationBarItem> _ffNavBarItemList = List();

  AppBottomNavTabBloc _appBottomNavTabBloc;
  CountdownTimer _userSessionTimer;
  DateTime _userSessionStartTime;
  StreamSubscription<CountdownTimer> _sessionTimerListener;
  AppLifecycleState _appLifecycleState;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _appBottomNavTabBloc = AppBottomNavTabBloc();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sessionTimerListener?.cancel();
    _userSessionTimer?.cancel();
    _appBottomNavTabBloc.close();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    _appLifecycleState = state;
    if (state == AppLifecycleState.resumed &&
        widget.appBloc.userDetails != null) {
      widget.appBloc.add(
        CheckSessionExpiry(sessionStartTime: _userSessionStartTime),
      );
    } else if (_userSessionTimer?.isRunning == true) {
      _sessionTimerListener.cancel();
      _userSessionTimer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    _ffNavBarItemList = _getFFNavBarItems();

    return BlocListener(
      bloc: widget.appBloc,
      listener: (BuildContext context, AppState state) {
        if (state is AppUserChanged) {
          if (state.userDetails != null) {
            _userSessionStartTime = DateTime.now();

            if (_appLifecycleState == null ||
                _appLifecycleState == AppLifecycleState.resumed) {
              /// Creation of session timer
              _createSessionCountdown(
                context,
                widget.appBloc.userSessionTimerMaxInSeconds,
              );

              _setStatusBarColor(0);
              widget.appTabBloc.add(AppTabSelect(tab: AppTab.home));
            }
          } else {
            Navigator.of(context).popUntil((route) {
              return (route.settings.name == Navigator.defaultRouteName);
            });

            _sessionTimerListener?.cancel();
            _userSessionTimer?.cancel();
            _sessionTimerListener = null;
            _userSessionTimer = null;

            _setStatusBarColor(2);
            widget.appTabBloc.add(AppTabSelect(tab: AppTab.account));
          }
        } else if (state is AppStarted) {
          _setStatusBarColor(2);
          widget.appTabBloc.add(AppTabSelect(tab: AppTab.account));
        } else if (state is AppSessionCheckProcessed) {
          /// Creation of session timer
          _createSessionCountdown(
            context,
            state.remainingDuration,
          );
        }
      },
      child: BlocBuilder(
        bloc: widget.appBloc,
        builder: (BuildContext context, AppState appState) {
          if (appState is AppLoading) {
            return _appLoadingWidget();
          }

          return BlocBuilder(
            bloc: widget.appTabBloc,
            builder: (BuildContext context, AppTabState appTabState) {
              _selectedTabIndex = _getAppTabIndex(appTabState);
              _appBottomNavTabBloc.add(
                BottomNavTabDisplay(
                  appBloc: widget.appBloc,
                  currentTab: _getAppTab(_selectedTabIndex),
                ),
              );

              return Stack(
                children: <Widget>[
                  DefaultTabController(
                    length: _ffNavBarItemList.length,
                    initialIndex: 0,
                    child: Scaffold(
                      body: SafeArea(
                        child: Builder(
                          builder: (BuildContext context) {
                            /// Below check is when we try to move automatically from
                            /// one screen tab to another screen tab via bloc call
                            /// of the appTabBloc. Ex: On successful login we move to
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
                            if (appState is AppUserChanged &&
                                appState.sessionExpired) {
                              WidgetsBinding.instance.addPostFrameCallback(
                                (_) {
                                  _displaySnackBar(
                                    context,
                                    AppSemanticKeys.sessionExpired,
                                    AppContent.sessionExpired,
                                  );
                                },
                              );
                            }

                            return TabBarView(
                              children: _getTabViews(context),
                              physics: NeverScrollableScrollPhysics(),
                            );
                          },
                        ),
                      ),
                      bottomNavigationBar: BlocBuilder(
                        bloc: _appBottomNavTabBloc,
                        builder: (
                          BuildContext context,
                          AppBottomNavTabState state,
                        ) {
                          if (state is BottomNavTabDisplayStatus &&
                              state.hide) {
                            return const SizedBox.shrink();
                          }

                          return Builder(
                            builder: (BuildContext context) =>
                                _getBottomNavBar(context),
                          );
                        },
                      ),
                    ),
                  ),
                  (appState is AppUserChangeProcessing ||
                          appState is AppSessionCheckProcessing)
                      ? Spinner(title: 'AppContainerWidget - $appState')
                      : const SizedBox.shrink(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  /// Creates  a session timer count down once the user is logged in
  void _createSessionCountdown(BuildContext context, int totalSessionSeconds) {
    _sessionTimerListener?.cancel();
    _userSessionTimer?.cancel();
    _userSessionTimer = CountdownTimer(
      Duration(seconds: totalSessionSeconds),
      Duration(seconds: 1),
    );

    /// Session timer listener
    _sessionTimerListener = _userSessionTimer.listen(null);
    _sessionTimerListener.onDone(() {
      _sessionTimerListener.cancel();
      Navigator.of(context).popUntil((route) {
        return (route.settings.name == Navigator.defaultRouteName);
      });
      widget.appTabBloc.add(AppTabSelect(tab: AppTab.account));
      widget.appBloc.add(AppSessionExpired());
    });
  }

  /// App first time launch loading widget
  Stack _appLoadingWidget() {
    return Stack(
      children: <Widget>[
        Spinner(
          title: 'AppLoading Spinner',
          spinnerColor: Colors.white,
          backgroundColor: Palette.primaryColor,
          backgroundOpacity: 1,
        ),
      ],
    );
  }

  /// Returns int value based on the app Tab enum value
  int _getAppTabIndex(AppTabState state) {
    if (state is AppTabChosen) {
      switch (state.tab) {
        case AppTab.bookedItinerary:
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
        {
          return AppTab.bookedItinerary;
        }
      case 2:
        {
          return AppTab.account;
        }
      default:
        {
          return AppTab.home;
        }
    }
  }

  /// Returns the list of widgets which we will be showing for a tab bar
  List<Widget> _getTabViews(BuildContext context) {
    return [
      HomePage(appBloc: widget.appBloc),
      BookedItineraryPage(appBloc: widget.appBloc),
      LoginPage(appBloc: widget.appBloc),
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
        iconData: Icons.hotel,
        label: AppContent.bookedItinerary,
        animationDuration: _bottomNavBarDuration,
      ),
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
          if (widget.appBloc.userDetails != null) {
            DefaultTabController.of(context).index = index;
            widget.appTabBloc.add(AppTabSelect(tab: _getAppTab(index)));
          } else if (index != 2) {
            _displaySnackBar(
              context,
              AppSemanticKeys.snackBarNeedLogIn,
              AppContent.needLogIn,
            );
          }
          _setStatusBarColor(index);
        },
      ),
    );
  }

  void _setStatusBarColor(int index) {
    switch (index) {
      case 1:
        {
          FlutterStatusbarcolor.setStatusBarColor(Colors.grey.withOpacity(0.2));
          FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
        }
        break;
      case 2:
        {
          FlutterStatusbarcolor.setStatusBarColor(Colors.white);
          FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
        }
        break;
      default:
        {
          FlutterStatusbarcolor.setStatusBarColor(Palette.primaryColor);
          FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
        }
        break;
    }
  }

  /// Displays a snackBar with given semantic key and information to display.
  void _displaySnackBar(BuildContext context, String semanticKey, String info) {
    Scaffold.of(context).hideCurrentSnackBar();
    final SnackBar snackBar = SnackBar(
      duration: Duration(milliseconds: 2000),
      content: Semantics(
        label: semanticKey,
        enabled: true,
        child: Text(info),
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
