import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:shoppy/services/auth.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _LoginForm(),
            Divider(),
            SocialSignInButtons()
          ],
        )
    );
  }

}

class _LoginForm extends StatelessWidget {
  final _formKey = new GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    maxLines: 1,
                    autovalidate: true,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => EmailValidator.validate(value) ? null : "Bitte eine E-Mail eingeben.",
                    onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                        hintText: "Email",
                        icon: Icon(
                          Icons.mail_outline,
                          color: Colors.black,
                        )
                    ),
                  ),
                  TextFormField(
                      onFieldSubmitted: (_) => submit(),
                      maxLines: 1,
                      autovalidate: true,
                      obscureText: true,
                      validator: (value) => value.isEmpty ? "Bitte Ihr Passwort eingeben." : null,
                      onSaved: (value) => _password = value,
                      decoration: InputDecoration(
                          hintText: "Passwort",
                          icon: Icon(
                            Icons.lock_outline,
                            color: Colors.black,
                          )
                      )
                  ),
                ],
              ),
            ),
            MaterialButton(
              child: Text(
                "Log in",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              onPressed: () => submit(),
              color: Colors.blueAccent,
            )
          ],
        )
    );
  }

  void submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      authService.signInWithMail(_email, _password);
    }
  }

}

class SocialSignInButtons extends StatelessWidget {
  final String prependedString;

  SocialSignInButtons({this.prependedString = "Einloggen"});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SignInButton(
          Buttons.Google,
          onPressed: () => authService.signIn(AuthenticationType.Google),
          text: "$prependedString mit Google",
        ),
        SignInButton(
          Buttons.Facebook,
          onPressed: () => authService.signIn(AuthenticationType.Facebook),
          text: "$prependedString mit Facebook",
        ),
        SignInButton(
          Buttons.Twitter,
          onPressed: () => authService.signIn(AuthenticationType.Twitter),
          text: "$prependedString mit Twitter",
        ),
      ],
    );
  }


}