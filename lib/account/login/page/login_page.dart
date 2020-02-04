import 'package:adactin_hotel_app/api/repo/user_repo.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextFieldController =
      TextEditingController();
  final TextEditingController _passwordTextFieldController =
      TextEditingController();
  final FocusNode _emailTextFieldFocusNode = FocusNode();
  final FocusNode _passwordTextFieldFocusNode = FocusNode();

  @override
  void dispose() {
    _emailTextFieldController.dispose();
    _passwordTextFieldController.dispose();
    _emailTextFieldFocusNode.dispose();
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
                  _getEmailFormField(),
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

  Widget _getEmailFormField() {
    return Semantics(
      label: 'Email',
      textField: true,
      child: TextFormField(
        controller: _emailTextFieldController,
        focusNode: _emailTextFieldFocusNode,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(_passwordTextFieldFocusNode);
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 22,
          ),
          hintText: 'Email Address',
          hintStyle: TextStyle(fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        validator: (String value) {
          if (!EmailValidator.validate(value)) {
            return 'Enter a valid email address';
          }
          return null;
        },
      ),
    );
  }

  Widget _getPasswordFormField() {
    return Semantics(
      label: 'Password',
      textField: true,
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
      label: 'Login',
      button: true,
      child: RaisedButton(
        onPressed: () {
          _formKey.currentState.validate();
          if (_emailTextFieldController.text.isNotEmpty &&
              _passwordTextFieldController.text.isNotEmpty) {
            UserRepository().authenticate(
              email: _emailTextFieldController.text,
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
      label: 'Forget password',
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
