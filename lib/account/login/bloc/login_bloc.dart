import 'package:adactin_hotel_app/api/repo/user_repo.dart';
import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// ------------ Event

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginAction extends LoginEvent {
  final String username;
  final String password;

  const LoginAction({
    @required this.username,
    @required this.password,
  });

  @override
  List<Object> get props => [username, password];

  @override
  String toString() {
    return 'LoginAction { username: $username, password: $password }';
  }
}

class LogoutAction extends LoginEvent {
  const LogoutAction();

  @override
  List<Object> get props => [];
}

/// ------------ State

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoggedInInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String token;

  const LoginSuccess({@required this.token});

  @override
  List<Object> get props => [token];

  @override
  String toString() {
    return 'LoginSuccess { token: $token }';
  }
}

class LogoutSuccess extends LoginState {
  const LogoutSuccess();
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'LoginFailure { error: $error }';
  }
}

/// ------------ Bloc

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AppBloc appBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.appBloc,
  }) : assert(
          userRepository != null,
          appBloc != null,
        );

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginAction) {
      yield LoginLoading();

      try {
        final Response response = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );

        yield LoginSuccess(token: response.toString());
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    } else if (event is LogoutAction) {
      yield LoginLoading();

      try {
        final Response response = await userRepository.logout(
          token: '',
        );

        yield LogoutSuccess();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
