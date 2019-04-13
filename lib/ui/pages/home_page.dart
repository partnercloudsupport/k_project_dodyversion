import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_project_dodyversion/blocs/bloc.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

// the 'widget' obj here is the HomePage from the State<>
class _HomePage extends State<HomePage> {
  var text = "HELLOO";

  SystemUiOverlayStyle _currentStyle = SystemUiOverlayStyle.light;
  FirebaseBloc _firebaseBloc;
  final _random = math.Random();

  @override
  void dispose() {
    _firebaseBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _firebaseBloc = FirebaseBloc();
    super.initState();
  }

  void _changeColor() {
    // _firebaseBloc.dispatch(AuthenticateFirebaseEvent(
    //     email: "dodysenz@gmail.com", hashedPassword: "ulala123123"));

    final color = Color.fromRGBO(
      _random.nextInt(255),
      _random.nextInt(255),
      _random.nextInt(255),
      1.0,
    );
    setState(() {
      _currentStyle = SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: color,
      );
    });
  }

  String customText(FirebaseState state) {
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
    return BlocBuilder(
        bloc: _firebaseBloc,
        builder: (BuildContext context, FirebaseState state) {
          return Scaffold(
            body: AnnotatedRegion(
              value: _currentStyle,
              child: Center(
                child: RaisedButton(
                  child: Text(customText(state)),
                  onPressed: _changeColor,
                ),
              ),
            ),
          );
        });
  }
}
