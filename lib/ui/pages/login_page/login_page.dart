import 'package:flutter/material.dart';
import 'package:k_project_dodyversion/blocs/bloc.dart';
import 'package:k_project_dodyversion/models/emailAuth_model.dart';
import 'package:k_project_dodyversion/ui/pages/login_page/login_page_containers.dart';

class LogInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {
  int _containerType;
  FirebaseBloc _firebaseBloc;
  LogInContainer _mContainer;

  EmailAuth _emailAuth;
  EmailAuth get emailAuth => _emailAuth;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  @override
  void initState() {
    _firebaseBloc = FirebaseBloc();
    _containerType = LogInContainer.SHOWLOGINOPTION;
    _mContainer = LogInContainer(this);
    _emailAuth = EmailAuth();
    super.initState();
  }

  get firebaseBloc => _firebaseBloc;

  void onEmailSubmitPressed() {
    _firebaseBloc.dispatch(AuthenticateFirebaseEvent(
        emailAuth: emailAuth));
  }

  void onGoogleLoginPressed() {
    setState(() {
      _containerType = LogInContainer.GMAIL_LOGIN;
    });
  }

  void onEmailChoosePressed() {
    setState(() {
      _containerType = LogInContainer.EMAILPASS_LOGIN;
    });
  }

  String textStatus(FirebaseState state) {
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

  @override
  Widget build(BuildContext context) {
    return _mContainer.getContainer(_containerType);
  }
}
