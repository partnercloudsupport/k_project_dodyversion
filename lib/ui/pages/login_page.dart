import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_project_dodyversion/blocs/bloc.dart';
import 'package:k_project_dodyversion/ui/themes/theme.dart';

class LogInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {
  AuthenticationBloc _authenticationBloc;
  AuthenticationBloc get authenticationBloc => _authenticationBloc;

  // int _containerType;
  // LogInContainer
  // _mContainer; // Getting new Container depends on the state of the page. 1: for email auth 2: for Google auth etc

  // EmailAuth _emailAuth;
  // EmailAuth get emailAuth => _emailAuth;

  // final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  // GlobalKey<FormState> get formKey => _formKey;

  @override // Initiate Vairables
  void initState() {
    _authenticationBloc = AuthenticationBloc();
    // _containerType = LogInContainer.SHOWLOGINOPTION;
    // _mContainer = LogInContainer(this);
    // _emailAuth = EmailAuth();

    super.initState();
  }

// Disabled email button
  // void onEmailSubmitPressed() {
  //   return;
  //   _authenticationBloc
  //       .dispatch(LoggingInEmailAuthenticationEvent(emailAuth: emailAuth));
  // }

  void onGoogleLoginPressed() {
    _authenticationBloc.dispatch(LoggingInGoogleAccountAuthenticationEvent());
    //  moveOn();
  }

  // void onEmailChoosePressed() {
  //   setState(() {
  //     _containerType = LogInContainer.EMAILPASS_LOGIN;
  //   });
  // }

  void moveOn() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 1.7976931348623157e+308,
        height: 1.7976931348623157e+308,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                KProjectTheme.GRADIENT_START_COLOR,
                KProjectTheme.GRADIENT_END_COLOR
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              stops: [0.5, 1.0]),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("K Project", style: KProjectTheme.getTitleTextTheme(),),
              blocWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget blocWidget() {
    return BlocListener(
        bloc: _authenticationBloc,
        listener: (BuildContext context, AuthenticationState state) {
          if (state is LoggedInState) {
            moveOn();
          }
        },
        child: BlocBuilder(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is LoggedOutState) return loginButton();
            if (state is LoggingInGoogleState)
              return CircularProgressIndicator();
            return Container();
          },
        ));
  }

  Widget loginButton() {
    return RaisedButton(
        child: Text("Sign in"),
        textColor: Colors.white,
        color: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {
          _authenticationBloc
              .dispatch(LoggingInGoogleAccountAuthenticationEvent());
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
