import 'dart:async';

import 'package:adactin_hotel_app/api/models/user_details.dart';
import 'package:adactin_hotel_app/api/repo/user_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ------------ Event

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class AppStart extends AppEvent {
  const AppStart();

  @override
  List<Object> get props => [];
}

class AppUserChangeInProcess extends AppEvent {
  const AppUserChangeInProcess();

  @override
  List<Object> get props => [];
}

class AppUserChange extends AppEvent {
  final UserDetails userDetails;
  final bool isSessionExpired;

  AppUserChange({this.userDetails, this.isSessionExpired = false});

  @override
  List<Object> get props => [userDetails];
}

class AppSessionExpired extends AppEvent {
  const AppSessionExpired();

  @override
  List<Object> get props => [];
}

class CheckSessionExpiry extends AppEvent {
  final DateTime sessionStartTime;

  CheckSessionExpiry({@required this.sessionStartTime});

  @override
  List<Object> get props => [sessionStartTime];
}

/// ------------ State

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppNotStarted extends AppState {}

class AppLoading extends AppState {}

class AppStarted extends AppState {}

class AppUserChangeProcessing extends AppState {}

class AppUserChanged extends AppState {
  final UserDetails userDetails;
  final bool sessionExpired;

  AppUserChanged({this.userDetails, this.sessionExpired = false});

  @override
  List<Object> get props => [userDetails, sessionExpired];

  @override
  String toString() {
    return 'AppUserChanged { $userDetails, $sessionExpired }';
  }
}

class AppSessionCheckProcessing extends AppState {}

class AppSessionCheckProcessed extends AppState {
  final int remainingDuration;

  AppSessionCheckProcessed({@required this.remainingDuration});

  @override
  List<Object> get props => [remainingDuration];

  @override
  String toString() {
    return 'AppSessionCheckProcessed { $remainingDuration }';
  }
}

/// ------------ Bloc

class AppBloc extends Bloc<AppEvent, AppState> {
  final SharedPreferences preferences;
  final int userSessionTimerMaxInSeconds = 1800;

  UserDetails userDetails;

  AppBloc({@required this.preferences});

  @override
  AppState get initialState => AppNotStarted();

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppStart) {
      yield AppLoading();

      userDetails = UserDetails.fromSharedPreferences(preferences);
      if (userDetails != null) {
        await UserDetails.removeFromPreferences(preferences);
      }
      userDetails = null;

      yield AppStarted();
    } else if (event is AppUserChange) {
      if (event.userDetails == null) {
        await UserDetails.removeFromPreferences(preferences);
        userDetails = null;
      } else {
        userDetails = event.userDetails;
        await event.userDetails.toPreferences(preferences);
      }

      yield AppUserChanged(
        userDetails: event.userDetails,
        sessionExpired: event.isSessionExpired,
      );
    } else if (event is AppUserChangeInProcess) {
      yield AppUserChangeProcessing();
    } else if (event is AppSessionExpired) {
      if (userDetails != null) {
        yield AppUserChangeProcessing();

        await _logOutUser();
        add(AppUserChange(isSessionExpired: true));
      }
    } else if (event is CheckSessionExpiry) {
      yield AppSessionCheckProcessing();

      final Duration timeDifference =
          DateTime.now().difference(event.sessionStartTime);
      if (timeDifference.inSeconds > userSessionTimerMaxInSeconds) {
        await _logOutUser();
        add(AppUserChange(isSessionExpired: true));
      } else {
        yield AppSessionCheckProcessed(
          remainingDuration:
              (userSessionTimerMaxInSeconds - timeDifference.inSeconds),
        );
      }
    }
  }

  Future _logOutUser() async {
    await UserRepository().logout(token: userDetails.token);
  }
}
