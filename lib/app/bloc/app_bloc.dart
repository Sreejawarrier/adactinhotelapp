import 'package:adactin_hotel_app/api/models/user_details.dart';
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

/// ------------ State

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppNotStarted extends AppState {}

class AppLoading extends AppState {}

class AppStarted extends AppState {}

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

      yield AppStarted();
    }
  }
}
