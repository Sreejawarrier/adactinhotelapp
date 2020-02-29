import 'dart:async';

import 'package:adactin_hotel_app/account/login/page/login_page.dart';
import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:adactin_hotel_app/app/bloc/app_bottom_nav_bloc.dart';
import 'package:adactin_hotel_app/app/bloc/app_tab_bloc.dart';
import 'package:adactin_hotel_app/app/constants/app_content.dart';
import 'package:adactin_hotel_app/app/constants/app_semantic_keys.dart';
import 'package:adactin_hotel_app/base/spinner/spinner.dart';
import 'package:adactin_hotel_app/home/page/home_page.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/async.dart';

class AppContainerWidget extends StatefulWidget {
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
        BlocProvider.of<AppBloc>(context)?.userDetails != null) {
      BlocProvider.of<AppBloc>(context).add(
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
      bloc: BlocProvider.of<AppBloc>(context),
      listener: (BuildContext context, AppState state) {
        if (state is AppUserChanged) {
          if (state.userDetails != null) {
            _userSessionStartTime = DateTime.now();

            if (_appLifecycleState == null ||
                _appLifecycleState == AppLifecycleState.resumed) {
              /// Creation of session timer
              _createSessionCountdown(
                context,
                BlocProvider.of<AppBloc>(context).userSessionTimerMaxInSeconds,
              );

              BlocProvider.of<AppTabBloc>(context)
                  .add(AppTabSelect(tab: AppTab.home));
            }
          } else {
            _sessionTimerListener?.cancel();
            _userSessionTimer?.cancel();
            _sessionTimerListener = null;
            _userSessionTimer = null;

            BlocProvider.of<AppTabBloc>(context)
                .add(AppTabSelect(tab: AppTab.account));
          }
        } else if (state is AppStarted) {
          BlocProvider.of<AppTabBloc>(context)
              .add(AppTabSelect(tab: AppTab.account));
        } else if (state is AppSessionCheckProcessed) {
          /// Creation of session timer
          _createSessionCountdown(
            context,
            state.remainingDuration,
          );
        }
      },
      child: BlocBuilder(
        bloc: BlocProvider.of<AppBloc>(context),
        builder: (BuildContext context, AppState appState) {
          if (appState is AppLoading) {
            return _appLoadingWidget();
          }

          return BlocBuilder(
            bloc: BlocProvider.of<AppTabBloc>(context),
            builder: (BuildContext context, AppTabState appTabState) {
              _selectedTabIndex = _getAppTabIndex(appTabState);
              _appBottomNavTabBloc.add(
                BottomNavTabDisplay(
                  appBloc: BlocProvider.of<AppBloc>(context),
                  currentTabIndex: _selectedTabIndex,
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
                      ? Spinner()
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
      BlocProvider.of<AppTabBloc>(context)
          .add(AppTabSelect(tab: AppTab.account));
      BlocProvider.of<AppBloc>(context).add(AppSessionExpired());
    });
  }

  /// App first time launch loading widget
  Stack _appLoadingWidget() {
    return Stack(
      children: <Widget>[
        Spinner(
          spinnerColor: Colors.white,
          backgroundColor: Palette.primaryColor,
          backgroundOpacity: 1,
        ),
      ],
    );
  }

  /// Returns int value based on the apptab enum value
  int _getAppTabIndex(AppTabState state) {
    if (state is AppTabChosen) {
      switch (state.tab) {
        case AppTab.account:
          return 1;
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
        return AppTab.account;
      default:
        return AppTab.home;
    }
  }

  /// Returns the list of widgets which we will be showing for a tab bar
  List<Widget> _getTabViews(BuildContext context) {
    return [
      HomePage(appBloc: BlocProvider.of<AppBloc>(context)),
      LoginPage(appBloc: BlocProvider.of<AppBloc>(context)),
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
          if (BlocProvider.of<AppBloc>(context).userDetails != null) {
            DefaultTabController.of(context).index = index;
            BlocProvider.of<AppTabBloc>(context)
                .add(AppTabSelect(tab: _getAppTab(index)));
          } else if (index != 2) {
            _displaySnackBar(
              context,
              AppSemanticKeys.snackBarNeedLogIn,
              AppContent.needLogIn,
            );
          }
        },
      ),
    );
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
