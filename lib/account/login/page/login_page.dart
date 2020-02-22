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
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  final AppBloc appBloc;

  Login({Key key, @required this.appBloc})
      : assert(appBloc != null),
        super(key: key);

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
  void initState() {
    super.initState();

    if (widget.appBloc.userDetails != null) {
      _userTextFieldController.text = widget.appBloc.userDetails.username;
    }
  }

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
            listener: (context, state) {
              if (state is LoginSuccess) {
                widget.appBloc
                    .add(AppUserChange(userDetails: state.userDetails));
              } else if (state is LogoutSuccess) {
                widget.appBloc.add(AppUserChange());
              } else if (state is LoginFailure) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      semanticLabel: LoginSemanticKeys.failureAlert,
                      title: Text(LoginContent.alertFailureTitle),
                      content: Text(state.error),
                      actions: <Widget>[
                        FlatButton(
                          child: Semantics(
                            enabled: true,
                            label: LoginSemanticKeys.failureAlertButton,
                            child: ExcludeSemantics(
                              child: Text(LoginContent.alertButtonOk),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                  barrierDismissible: false,
                );
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: Center(
                        child: (widget.appBloc.userDetails == null)
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
            const SizedBox(height: 16),
            _getSignUpText(context),
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
      child: ExcludeSemantics(
        child: SvgPicture.asset(
          Images.logoSVG,
          width: 180,
          height: 180,
        ),
      ),
    );
  }

  Widget _getUsernameFormField(BuildContext context) {
    return Semantics(
      label: LoginSemanticKeys.userName,
      enabled: true,
      child: ExcludeSemantics(
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
      ),
    );
  }

  Widget _getPasswordFormField(BuildContext context) {
    return Semantics(
      label: LoginSemanticKeys.password,
      enabled: true,
      child: ExcludeSemantics(
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
      ),
    );
  }

  Widget _getLoginButton(BuildContext context) {
    return Semantics(
      label: LoginSemanticKeys.loginButton,
      enabled: true,
      child: ExcludeSemantics(
        child: RaisedButton(
          onPressed: () {
            _removeFocus();
            _formKey.currentState.validate();
            if (_usernameTextFieldController.text.isNotEmpty &&
                _passwordTextFieldController.text.isNotEmpty) {
              widget.appBloc.add(AppUserChangeInProcess());
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _getForgetPassword(BuildContext context) {
    return Semantics(
      label: LoginSemanticKeys.forgotPassword,
      enabled: true,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _removeFocus();
            _launchWebURL();
          },
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 8, top: 8, bottom: 4),
            child: Text(
              LoginContent.forgotPassword,
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSignUpText(BuildContext context) {
    return Semantics(
      label: LoginSemanticKeys.signUp,
      enabled: true,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _removeFocus();
            _launchWebURL();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 8, bottom: 12),
            child: RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                text: LoginContent.notAMember,
                style: TextStyle(fontSize: 18, color: Colors.grey),
                children: [
                  TextSpan(
                    text: LoginContent.signUp,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getUserField(BuildContext context) {
    return Semantics(
      label: LoginSemanticKeys.user,
      enabled: true,
      child: ExcludeSemantics(
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
      ),
    );
  }

  Widget _getLogOutButton(BuildContext context) {
    return Semantics(
      label: LoginSemanticKeys.logoutButton,
      enabled: true,
      child: ExcludeSemantics(
        child: RaisedButton(
          onPressed: () {
            widget.appBloc.add(AppUserChangeInProcess());
            BlocProvider.of<LoginBloc>(context).add(
              LogoutAction(token: widget.appBloc.userDetails.token),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  /// Will remove focus from the current Focus node
  void _removeFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future _launchWebURL() async {
    if (await canLaunch(LoginContent.adactinSiteURL)) {
      await launch(LoginContent.adactinSiteURL);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            semanticLabel: LoginSemanticKeys.failureAlert,
            title: Text(LoginContent.alertFailureTitle),
            content: Text(
                '${LoginContent.errorCouldntLaunchURL} ${LoginContent.adactinSiteURL}'),
            actions: <Widget>[
              FlatButton(
                child: Semantics(
                  enabled: true,
                  label: LoginSemanticKeys.failureAlertButton,
                  child: ExcludeSemantics(
                    child: Text(LoginContent.alertButtonOk),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
        barrierDismissible: false,
      );
    }
  }
}
