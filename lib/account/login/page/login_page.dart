import 'package:adactin_hotel_app/account/login/bloc/login_bloc.dart';
import 'package:adactin_hotel_app/account/login/constants/login_content.dart';
import 'package:adactin_hotel_app/account/login/constants/login_semantic_keys.dart';
import 'package:adactin_hotel_app/api/repo/user_repo.dart';
import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:adactin_hotel_app/base/spinner/spinner.dart';
import 'package:adactin_hotel_app/theme/images.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  final AppBloc appBloc;

  Login({Key key, this.appBloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameTextFieldController =
      TextEditingController();
  final TextEditingController _passwordTextFieldController =
      TextEditingController();
  final TextEditingController _userTextFieldController =
      TextEditingController();
  final FocusNode _usernameTextFieldFocusNode = FocusNode();
  final FocusNode _passwordTextFieldFocusNode = FocusNode();

  @override
  void dispose() {
    _usernameTextFieldController.dispose();
    _passwordTextFieldController.dispose();
    _usernameTextFieldFocusNode.dispose();
    _passwordTextFieldFocusNode.dispose();
    _userTextFieldController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            userRepository: UserRepository(),
          );
        },
        child: SafeArea(
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {},
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: Center(
                        child: state is LoginInitial
                            ? _getLoginForm(context)
                            : _getLoggedInForm(context),
                      ),
                    ),
                    state is LoginLoading ? Spinner() : const SizedBox.shrink(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _getLoginForm(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _getLogo(),
            const SizedBox(height: 8),
            _getUsernameFormField(context),
            const SizedBox(height: 20),
            _getPasswordFormField(context),
            const SizedBox(height: 20),
            _getLoginButton(context),
            const SizedBox(height: 16),
            _getForgetPassword(context),
          ],
        ),
      ),
    );
  }

  Widget _getLoggedInForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _getLogo(),
          const SizedBox(height: 8),
          _getUserField(context),
          const SizedBox(height: 20),
          _getLogOutButton(context),
        ],
      ),
    );
  }

  Widget _getLogo() {
    return Semantics(
      label: LoginSemanticKeys.logo,
      enabled: true,
      child: SvgPicture.asset(
        Images.logoSVG,
        width: 180,
        height: 180,
      ),
    );
  }

  Widget _getUsernameFormField(BuildContext context) {
    return Semantics(
      label: LoginSemanticKeys.userName,
      enabled: true,
      child: TextFormField(
        controller: _usernameTextFieldController,
        focusNode: _usernameTextFieldFocusNode,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(_passwordTextFieldFocusNode);
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 22,
          ),
          hintText: LoginContent.userNameHint,
          hintStyle: TextStyle(fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        validator: (String value) {
          return (value == null || value.isEmpty)
              ? LoginContent.userNameEmptyError
              : null;
        },
      ),
    );
  }

  Widget _getPasswordFormField(BuildContext context) {
    return Semantics(
      label: LoginSemanticKeys.password,
      enabled: true,
      child: TextFormField(
        controller: _passwordTextFieldController,
        focusNode: _passwordTextFieldFocusNode,
        obscureText: true,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 22,
          ),
          hintText: LoginContent.passwordHint,
          hintStyle: TextStyle(fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        validator: (String value) {
          return (value == null || value.isEmpty)
              ? LoginContent.passwordEmptyError
              : null;
        },
      ),
    );
  }

  Widget _getLoginButton(BuildContext context) {
    return Semantics(
      label: LoginSemanticKeys.loginButton,
      enabled: true,
      child: RaisedButton(
        onPressed: () {
          _formKey.currentState.validate();
          if (_usernameTextFieldController.text.isNotEmpty &&
              _passwordTextFieldController.text.isNotEmpty) {
            BlocProvider.of<LoginBloc>(context).add(
              LoginAction(
                username: _usernameTextFieldController.text,
                password: _passwordTextFieldController.text,
              ),
            );
          }
        },
        child: Text(
          LoginContent.login,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 22,
        ),
        color: Palette.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _getForgetPassword(BuildContext context) {
    return Semantics(
      label: LoginSemanticKeys.forgotPassword,
      enabled: true,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Text(
            LoginContent.forgotPassword,
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }

  Widget _getUserField(BuildContext context) {
    return Semantics(
      label: LoginSemanticKeys.user,
      enabled: true,
      child: TextField(
        enabled: false,
        controller: _userTextFieldController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 22,
          ),
          labelText: LoginContent.userNameHint,
          labelStyle: TextStyle(fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _getLogOutButton(BuildContext context) {
    return Semantics(
      label: LoginSemanticKeys.logoutButton,
      enabled: true,
      child: RaisedButton(
        onPressed: () {
          BlocProvider.of<LoginBloc>(context).add(
            LogoutAction(),
          );
        },
        child: Text(
          LoginContent.logout,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 22,
        ),
        color: Palette.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
