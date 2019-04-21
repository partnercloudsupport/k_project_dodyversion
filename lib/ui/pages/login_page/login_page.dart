import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_project_dodyversion/blocs/bloc.dart';
import 'package:k_project_dodyversion/models/emailAuth_model.dart';
import 'package:k_project_dodyversion/ui/pages/login_page/login_page_containers.dart';

class LogInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {
  AuthenticationBloc _authenticationBloc;
  AuthenticationBloc get authenticationBloc => _authenticationBloc;

  int _containerType;
  LogInContainer
      _mContainer; // Getting new Container depends on the state of the page. 1: for email auth 2: for Google auth etc

  EmailAuth _emailAuth;
  EmailAuth get emailAuth => _emailAuth;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  @override // Initiate Vairables
  void initState() {
    _authenticationBloc = AuthenticationBloc();
    _containerType = LogInContainer.SHOWLOGINOPTION;
    _mContainer = LogInContainer(this);
    _emailAuth = EmailAuth();

    super.initState();
  }

// Disabled email button
  void onEmailSubmitPressed() {
    return;
    _authenticationBloc
        .dispatch(LoggingInEmailAuthenticationEvent(emailAuth: emailAuth));
  }

  void onGoogleLoginPressed() {
    _authenticationBloc.dispatch(LoggingInGoogleAccountAuthenticationEvent());
    //  moveOn();
  }

  void onEmailChoosePressed() {
    setState(() {
      _containerType = LogInContainer.EMAILPASS_LOGIN;
    });
  }

  void moveOn() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _authenticationBloc,
      listener: (BuildContext context, AuthenticationState state) {
        if(state is LoggedInState){
          moveOn();
        }
      },
      child: BlocBuilder(
        bloc: authenticationBloc,
        builder: (BuildContext context, AuthenticationState state) {
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
                      onPressed: onGoogleLoginPressed,
                    ),
                    RaisedButton(
                      child: Text("log in with email"),
                      onPressed: onEmailChoosePressed,
                    )
                  ],
                ),
              ));
        },
      ),
    );
  }

  String _textStatus(AuthenticationState state) {
    if (state is LoggedOutState) {
      return ("Logged out");
    } else if (state is LoggingInEmailState) {
      return ("Authenticating.. Please wait");
    } else if (state is LoggingInGoogleState) {
      return ("Authenticating.. Please wait");
    } else if (state is LoggedInState) {
      String uid = "Authenticated!!!!";
      return ("$uid");
    } else if (state is LogginInGoogleFailedState) {
      return ("FAILLL");
    } else {
      return state.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
