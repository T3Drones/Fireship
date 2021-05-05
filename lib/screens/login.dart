import 'dart:ffi';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireship/services/auth.dart';
import 'package:fireship/shared/exception_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fireship/services/validators.dart';

enum EmailSignInFormType { signIn, register }

class LoginScreen extends StatefulWidget with EmailAndPasswordalidators {
  createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  AuthService auth = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _submit() async {
    setState(() {
      _submitted = true;
    });
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInEmailPassword(_email, _password);
      } else {
        await auth.createUserEmailPassword(_email, _password);
      }
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
    auth.getUser.then((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/topics');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    auth.getUser.then(
      (user) {
        if (user != null) {
          Navigator.pushReplacementNamed(context, '/topics');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password);
    bool emailValid = _submitted && !widget.emailValidator.isValid(_email);
    bool passwordValid =
        _submitted && !widget.passwordValidator.isValid(_password);

    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlutterLogo(
              size: 100,
            ),
            Text(
              'Login to Start',
              style: Theme.of(context).textTheme.headline,
              textAlign: TextAlign.center,
            ),
            Text('Your Tagline'),
            LoginButton(
              text: 'LOGIN WITH GOOGLE',
              icon: FontAwesomeIcons.google,
              color: Colors.black45,
              loginMethod: auth.googleSignIn,
            ),
            LoginButton(text: 'Continue as Guest', loginMethod: auth.anonLogin),
            TextField(
              controller: _emailController,
              onEditingComplete: _emailEditingComplete,
              focusNode: _emailFocusNode,
              onChanged: (email) => _updateState(),
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'test@test.com',
                errorText: emailValid ? widget.invalidEmailErrorText : null,
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText:
                    passwordValid ? widget.invalidPasswordErrorText : null,
              ),
              obscureText: true,
              onChanged: (password) => _updateState(),
              focusNode: _passwordFocusNode,
            ),
            FlatButton(
              child: Text(primaryText),
              onPressed: submitEnabled ? _submit : null,
            ),
            FlatButton(
              child: Text(secondaryText),
              onPressed: _toggleFormType,
            ),
          ],
        ),
      ),
    );
  }

  _updateState() {
    setState(() {});
  }
}

/// A resuable login button for multiple auth methods
class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {Key key, this.text, this.icon, this.color, this.loginMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: FlatButton.icon(
        padding: EdgeInsets.all(30),
        icon: Icon(icon, color: Colors.white),
        color: color,
        onPressed: () async {
          var user = await loginMethod();
          if (user != null) {
            Navigator.pushReplacementNamed(context, '/topics');
          }
        },
        label: Expanded(
          child: Text('$text', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
