import 'package:flutter/material.dart';
import 'package:k_project_dodyversion/resources/repository.dart';
import 'package:k_project_dodyversion/ui/pages/homePage.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final FirebaseRepository firebaseRepository;

  MyApp({Key key, @required this.firebaseRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          'Flutter Code Sample for services.SystemChrome.setSystemUIOverlayStyle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(firebaseRepository: this.firebaseRepository),
    );
  }
}
