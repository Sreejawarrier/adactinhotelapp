import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ------------ Data

enum AppTab { home, bookedItinerary, account }

/// ------------ Event

abstract class AppTabEvent extends Equatable {
  const AppTabEvent();
}

class AppTabSelect extends AppTabEvent {
  final AppTab tab;

  AppTabSelect({this.tab});

  @override
  List<Object> get props => [tab];

  @override
  String toString() {
    return 'AppTabSelect { $tab }';
  }
}

/// ------------ State

abstract class AppTabState extends Equatable {
  const AppTabState();

  @override
  List<Object> get props => [];
}

class AppTabChosen extends AppTabState {
  final AppTab tab;

  AppTabChosen({this.tab});

  @override
  List<Object> get props => [tab];

  @override
  String toString() {
    return 'AppTabChosen { $tab }';
  }
}

/// ------------ Bloc

class AppTabBloc extends Bloc<AppTabEvent, AppTabState> {
  @override
  AppTabState get initialState => AppTabChosen(tab: AppTab.account);

  @override
  Stream<AppTabState> mapEventToState(AppTabEvent event) async* {
    if (event is AppTabSelect) {
      yield AppTabChosen(tab: event.tab);
    }
  }
}
