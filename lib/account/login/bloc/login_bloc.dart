import 'package:adactin_hotel_app/api/models/user_details.dart';
import 'package:adactin_hotel_app/api/repo/user_repo.dart';
import 'package:adactin_hotel_app/global/global_constants.dart'
    as globalConstants;
import 'package:bloc/bloc.dart';
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
  final String token;

  const LogoutAction({@required this.token});

  @override
  List<Object> get props => [token];
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
  final UserDetails userDetails;

  const LoginSuccess({@required this.userDetails});

  @override
  List<Object> get props => [userDetails];

  @override
  String toString() {
    return 'LoginSuccess { userDetails: $userDetails }';
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

  LoginBloc({
    @required this.userRepository,
  }) : assert(
          userRepository != null,
        );

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginAction) {
      yield LoginLoading();

      try {
        yield LoginSuccess(
          userDetails: await userRepository.authenticate(
            username: event.username,
            password: event.password,
          ),
        );
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    } else if (event is LogoutAction) {
      yield LoginLoading();

      try {
        final bool success = await userRepository.logout(token: event.token);
        if (success) {
          yield LogoutSuccess();
        } else {
          yield LoginFailure(
              error: globalConstants.GlobalConstants.unknown_error);
        }
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
