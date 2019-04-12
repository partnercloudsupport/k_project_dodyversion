// The following example creates a widget that changes the status bar color
// to a random value on Android.

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:k_project_dodyversion/MyApp.dart';
import 'package:k_project_dodyversion/blocs/bloc_delegate.dart';
import 'package:k_project_dodyversion/resources/repository.dart';

void main() {
  BlocSupervisor().delegate = KBlocDelegate();
  runApp(MyApp(firebaseRepository: new FirebaseRepository()));
}
