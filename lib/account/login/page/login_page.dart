import 'package:adactin_hotel_app/account/login/bloc/login_bloc.dart';
import 'package:adactin_hotel_app/account/login/constants/login_content.dart';
import 'package:adactin_hotel_app/account/login/constants/login_semantic_keys.dart';
import 'package:adactin_hotel_app/api/repo/user_repo.dart';
import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:adactin_hotel_app/base/adactin_button/widget/adactin_button.dart';
import 'package:adactin_hotel_app/base/custom_alert/custom_alert.dart';
import 'package:adactin_hotel_app/theme/images.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  final AppBloc appBloc;

  LoginPage({Key key, @required this.appBloc})
      : assert(appBloc != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              widget.appBloc.add(AppUserChange(userDetails: state.userDetails));
            } else if (state is LogoutSuccess) {
              widget.appBloc.add(AppUserChange());
            } else if (state is LoginFailure) {
              widget.appBloc.add(AppUserChangeError());
              CustomAlert.displayGeneralAlert(
                context: context,
                title: LoginContent.alertFailureTitle,
                message: state.error,
                actions: <Widget>[
                  FlatButton(
                    child: Semantics(
                      enabled: true,
                      explicitChildNodes: true,
                      label: LoginSemanticKeys.failureAlertButton,
                      child: Text(LoginContent.alertButtonOk),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: (widget.appBloc.userDetails == null)
                      ? _getLoginForm(context)
                      : _getLoggedInForm(context),
                ),
              );
            },
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
            _getForgotPasswordAndSignUp(context),
            const SizedBox(height: 20),
            _getCopyright(context),
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
      explicitChildNodes: true,
      child: SvgPicture.asset(
        Images.logoSVG,
        width: 160,
        height: 160,
      ),
    );
  }

  Widget _getUsernameFormField(BuildContext context) {
    return Semantics(
      label: LoginSemanticKeys.userName,
      enabled: true,
      explicitChildNodes: true,
      child: TextFormField(
        controller: _usernameTextFieldController,
        focusNode: _usernameTextFieldFocusNode,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(_passwordTextFieldFocusNode);
        },
        decoration: _getFormFieldInputDecoration(
          hint: LoginContent.userNameHint,
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
      explicitChildNodes: true,
      child: TextFormField(
        controller: _passwordTextFieldController,
        focusNode: _passwordTextFieldFocusNode,
        obscureText: true,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        decoration: _getFormFieldInputDecoration(
          hint: LoginContent.passwordHint,
        ),
        validator: (String value) {
          return (value == null || value.isEmpty)
              ? LoginContent.passwordEmptyError
              : null;
        },
      ),
    );
  }

  InputDecoration _getFormFieldInputDecoration({
    @required String hint,
    Color fillColor,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 22,
      ),
      labelText: hint,
      labelStyle: TextStyle(fontSize: 18),
      hintText: hint,
      hintStyle: TextStyle(fontSize: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey),
      ),
      fillColor: fillColor,
      filled: fillColor != null,
    );
  }

  Widget _getLoginButton(BuildContext context) {
    return AdactinButton(
      semanticKey: LoginSemanticKeys.loginButton,
      title: LoginContent.login,
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
    );
  }

  Widget _getForgotPasswordAndSignUp(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _getSignUpText(context),
        _getForgetPassword(context),
      ],
    );
  }

  Widget _getForgetPassword(BuildContext context) {
    return Semantics(
      label: LoginSemanticKeys.forgotPassword,
      enabled: true,
      explicitChildNodes: true,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _removeFocus();
          _launchWebURL(context, LoginContent.forgotPasswordURL);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 12),
          child: Text(
            LoginContent.forgotPassword,
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }

  Widget _getSignUpText(BuildContext context) {
    return Semantics(
      label: LoginSemanticKeys.signUp,
      enabled: true,
      explicitChildNodes: true,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _removeFocus();
          _launchWebURL(context, LoginContent.signUpURL);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 12),
          child: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              text: LoginContent.signUp,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getCopyright(BuildContext context) {
    return Semantics(
      label: LoginSemanticKeys.copyright,
      enabled: true,
      explicitChildNodes: true,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _removeFocus();
          _launchWebURL(context, LoginContent.copyrightURL);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: LoginContent.copyrightMessage,
              style: TextStyle(fontSize: 16, color: Colors.grey),
              children: [
                TextSpan(
                  text: LoginContent.copyrightClickHere,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Palette.primaryColor,
                  ),
                ),
              ],
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
      explicitChildNodes: true,
      child: TextField(
        enabled: false,
        controller: _userTextFieldController,
        decoration: _getFormFieldInputDecoration(
          hint: LoginContent.userNameHint,
          fillColor: Colors.grey.withOpacity(0.1),
        ),
      ),
    );
  }

  Widget _getLogOutButton(BuildContext context) {
    return AdactinButton(
      semanticKey: LoginSemanticKeys.logoutButton,
      title: LoginContent.logout,
      onPressed: () {
        widget.appBloc.add(AppUserChangeInProcess());
        BlocProvider.of<LoginBloc>(context).add(
          LogoutAction(token: widget.appBloc.userDetails.token),
        );
      },
    );
  }

  /// Will remove focus from the current Focus node
  void _removeFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future _launchWebURL(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      CustomAlert.displayGeneralAlert(
        context: context,
        title: LoginContent.alertFailureTitle,
        message: '${LoginContent.errorCouldNotLaunchURL} $url',
        actions: <Widget>[
          FlatButton(
            child: Semantics(
              enabled: true,
              explicitChildNodes: true,
              label: LoginSemanticKeys.failureAlertButton,
              child: Text(LoginContent.alertButtonOk),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  }
}
