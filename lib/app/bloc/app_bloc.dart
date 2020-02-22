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

  AppUserChange({this.userDetails});

  @override
  List<Object> get props => [userDetails];
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

  AppUserChanged({this.userDetails});

  @override
  List<Object> get props => [userDetails];

  @override
  String toString() {
    return 'AppUserChanged { $userDetails }';
  }
}

/// ------------ Bloc

class AppBloc extends Bloc<AppEvent, AppState> {
  final SharedPreferences preferences;

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
        await UserRepository().logout(token: userDetails.token);
        userDetails = null;
      }

      yield AppStarted();
    } else if (event is AppUserChange) {
      if (event.userDetails == null) {
        await UserDetails.removeFromPreferences(preferences);
        userDetails = null;
      } else {
        userDetails = event.userDetails;
        await event.userDetails.toPreferences(preferences);
      }

      yield AppUserChanged(userDetails: event.userDetails);
    } else if (event is AppUserChangeInProcess) {
      yield AppUserChangeProcessing();
    }
  }
}
