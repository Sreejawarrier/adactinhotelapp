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
      label: 'username_textformfield',
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
          hintText: 'Username',
          hintStyle: TextStyle(fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        validator: (String value) {
          if (value == null || value.isEmpty) {
            return 'Enter a valid username';
          }
          return null;
        },
      ),
    );
  }

  Widget _getPasswordFormField() {
    return Semantics(
      label: 'password_textformfield',
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
          hintText: 'Password',
          hintStyle: TextStyle(fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        validator: (String value) {
          if (value == null || value.isEmpty) {
            return 'Enter a valid password';
          }
          return null;
        },
      ),
    );
  }

  Widget _getLoginButton() {
    return Semantics(
      label: 'login_button',
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
          'Login',
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
      label: 'forgetpassword_tapdetector',
      enabled: true,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Text(
            'Forgot password',
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }
}
