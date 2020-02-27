import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

/// ------------ Event

abstract class AppBottomNavTabEvent extends Equatable {
  const AppBottomNavTabEvent();
}

class BottomNavTabDisplay extends AppBottomNavTabEvent {
  final AppBloc appBloc;
  final int currentTabIndex;

  BottomNavTabDisplay({
    @required this.appBloc,
    @required this.currentTabIndex,
  });

  @override
  List<Object> get props => [appBloc, currentTabIndex];

  @override
  String toString() {
    return 'BottomNavTabDisplay { appBloc: $appBloc, currentTabIndex: '
        '$currentTabIndex }';
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
        hide: (event.currentTabIndex == 1 && event.appBloc.userDetails == null),
      );
    }
  }
}
