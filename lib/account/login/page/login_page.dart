import 'package:adactin_hotel_app/account/login/constants/login_content.dart';
import 'package:adactin_hotel_app/account/login/constants/login_semantic_keys.dart';
import 'package:adactin_hotel_app/api/repo/user_repo.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameTextFieldController =
      TextEditingController();
  final TextEditingController _passwordTextFieldController =
      TextEditingController();
  final FocusNode _usernameTextFieldFocusNode = FocusNode();
  final FocusNode _passwordTextFieldFocusNode = FocusNode();

  @override
  void dispose() {
    _usernameTextFieldController.dispose();
    _passwordTextFieldController.dispose();
    _usernameTextFieldFocusNode.dispose();
    _passwordTextFieldFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Form(
            key: _formKey,
            autovalidate: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _getLogo(),
                  const SizedBox(height: 24),
                  _getUsernameFormField(),
                  const SizedBox(height: 20),
                  _getPasswordFormField(),
                  const SizedBox(height: 20),
                  _getLoginButton(),
                  const SizedBox(height: 16),
                  _getForgetPassword(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getLogo() {
    return const SizedBox();
  }

  Widget _getUsernameFormField() {
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

  Widget _getPasswordFormField() {
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

  Widget _getLoginButton() {
    return Semantics(
      label: LoginSemanticKeys.loginButton,
      enabled: true,
      child: RaisedButton(
        onPressed: () {
          _formKey.currentState.validate();
          if (_usernameTextFieldController.text.isNotEmpty &&
              _passwordTextFieldController.text.isNotEmpty) {
            UserRepository().authenticate(
              username: _usernameTextFieldController.text,
              password: _passwordTextFieldController.text,
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

  Widget _getForgetPassword() {
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
}
