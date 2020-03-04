import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:adactin_hotel_app/app/bloc/app_tab_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

/// ------------ Event

abstract class AppBottomNavTabEvent extends Equatable {
  const AppBottomNavTabEvent();
}

class BottomNavTabDisplay extends AppBottomNavTabEvent {
  final AppBloc appBloc;
  final AppTab currentTab;

  BottomNavTabDisplay({
    @required this.appBloc,
    @required this.currentTab,
  });

  @override
  List<Object> get props => [appBloc, currentTab];

  @override
  String toString() {
    return 'BottomNavTabDisplay { appBloc: $appBloc, currentTab: $currentTab }';
  }
}

/// ------------ State

abstract class AppBottomNavTabState extends Equatable {
  const AppBottomNavTabState();

  @override
  List<Object> get props => [];
}

class BottomNavTabDisplayStatus extends AppBottomNavTabState {
  final bool hide;

  BottomNavTabDisplayStatus({this.hide});

  @override
  List<Object> get props => [hide];

  @override
  String toString() {
    return 'BottomNavTabDisplayStatus { $hide }';
  }
}

/// ------------ Bloc

class AppBottomNavTabBloc
    extends Bloc<AppBottomNavTabEvent, AppBottomNavTabState> {
  @override
  AppBottomNavTabState get initialState =>
      BottomNavTabDisplayStatus(hide: false);

  @override
  Stream<AppBottomNavTabState> mapEventToState(
      AppBottomNavTabEvent event) async* {
    if (event is BottomNavTabDisplay) {
      yield BottomNavTabDisplayStatus(
        hide: (event.currentTab == AppTab.account &&
            event.appBloc.userDetails == null),
      );
    }
  }
}
