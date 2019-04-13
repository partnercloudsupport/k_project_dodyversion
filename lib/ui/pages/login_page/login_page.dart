import 'package:flutter/material.dart';
import 'package:k_project_dodyversion/blocs/bloc.dart';
import 'package:k_project_dodyversion/models/emailAuth_model.dart';
import 'package:k_project_dodyversion/ui/pages/login_page/login_page_containers.dart';

class LogInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {
  FirebaseBloc _firebaseBloc;
  FirebaseBloc get firebaseBloc => _firebaseBloc;
  
  int _containerType;
  LogInContainer _mContainer; // Getting new Container depends on the state of the page. 1: for email auth 2: for Google auth etc

  EmailAuth _emailAuth;
  EmailAuth get emailAuth => _emailAuth;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  @override // Initiate Vairables
  void initState() {
    _firebaseBloc = FirebaseBloc();
    _containerType = LogInContainer.SHOWLOGINOPTION;
    _mContainer = LogInContainer(this);
    _emailAuth = EmailAuth();
    super.initState();
  }

  void onEmailSubmitPressed() {
    _firebaseBloc.dispatch(EmailAuthenticationFirebaseEvent(emailAuth: emailAuth));
  }

  void onGoogleLoginPressed() {
    // setState(() {
    //   _containerType = LogInContainer.GMAIL_LOGIN;
    // });

    _firebaseBloc.dispatch(GoogleAuthenticationFirebaseEvent());
  }

  void onEmailChoosePressed() {
    setState(() {
      _containerType = LogInContainer.EMAILPASS_LOGIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _mContainer.getContainer(_containerType);
  }
}
