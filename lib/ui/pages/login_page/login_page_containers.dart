import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_project_dodyversion/blocs/bloc.dart';
import 'package:k_project_dodyversion/models/emailAuth_model.dart';
import 'package:k_project_dodyversion/ui/pages/login_page/login_page.dart';

class LogInContainer {
  LogInContainer(LogInPageState _lgp) {
    this._parent = _lgp;
  }

  static const EMAILPASS_LOGIN = 0;
  static const GMAIL_LOGIN = 1;
  static const SHOWLOGINOPTION = -1;

  LogInPageState _parent;

  Widget getContainer(int type) {
    if (_parent.firebaseBloc == null) throw Exception();
    switch (type) {
      case EMAILPASS_LOGIN:
        return _emailpassLogin();
      case GMAIL_LOGIN:
        return _gmailLogin();
      case SHOWLOGINOPTION:
        return _showLoginOption();
      default:
        return null;
    }
  }

  Widget _emailpassLogin() {
    return BlocBuilder(
      bloc: _parent.firebaseBloc,
      builder: (BuildContext context, FirebaseState state) {
        return Container(
            width: 1.7976931348623157e+308,
            height: 1.7976931348623157e+308,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFD3B8AE), Color(0xFFAFC9D2)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  stops: [0.6, 1.0]),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_textStatus(state)),
                  Text("Welcome to the second page"),
                  Material(
                    child: new Form(
                      autovalidate: false,
                      key: _parent.formKey,
                      child: Column(
                        children: <Widget>[
                          new TextFormField(
                            validator: EmailAuth.validateEmail,
                            decoration: new InputDecoration(
                                hintText: 'you@example.com',
                                labelText: 'E-mail Address'),
                            onSaved: (str) {
                              _parent.emailAuth.email = str;
                            },
                          ),
                          new TextFormField(
                            obscureText: true,
                            validator: EmailAuth.validatePassword,
                            decoration: new InputDecoration(
                                hintText: '****', labelText: 'Password'),
                            onSaved: (str) {
                              _parent.emailAuth.password = str;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text("Log In"),
                    onPressed: _onEmailSubmitPressed,
                  )
                ],
              ),
            ));
      },
    );
  }

  Widget _showLoginOption() {
    return BlocBuilder(
      bloc: _parent.firebaseBloc,
      builder: (BuildContext context, FirebaseState state) {
        return Container(
            width: 1.7976931348623157e+308,
            height: 1.7976931348623157e+308,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFD3B8AE), Color(0xFFAFC9D2)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  stops: [0.6, 1.0]),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_textStatus(state)),
                  RaisedButton(
                    child: Text("log in with google account"),
                    onPressed: _parent.onGoogleLoginPressed,
                  ),
                  RaisedButton(
                    child: Text("log in with email"),
                    onPressed: _parent.onEmailChoosePressed,
                  )
                ],
              ),
            ));
      },
    );
  }

  Widget _gmailLogin() {
    return null; //TODO
  }

  String _textStatus(FirebaseState state) {
    if (state is InitialFirebaseState) {
      return ("Initializing");
    } else if (state is AuthenticatingFirebaseState) {
      return ("Authenticating.. Please wait");
    } else if (state is AuthenticateSuccessState) {
      String uid = state.uid;
      return ("$uid");
    } else {
      return ("FAILLL");
    }
  }

  void _onEmailSubmitPressed() {
    if (_parent.formKey.currentState.validate()) {
      _parent.formKey.currentState.save(); // Save our form now.

      print('Printing the login data.');
      print('Email: ${_parent.emailAuth.email}');
      print('Password: ${_parent.emailAuth.password}');
      _parent.onEmailSubmitPressed();
    }
  }
}