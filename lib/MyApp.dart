import 'package:flutter/material.dart';
import 'package:k_project_dodyversion/ui/pages/home_page.dart';
import 'package:k_project_dodyversion/ui/pages/login_page/login_page.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  //TODO ->> locally save this variable
  bool isLoggedIn = false;

  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          'Flutter Code Sample for services.SystemChrome.setSystemUIOverlayStyle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: defaultHomePage(),
      routes: {
        '/home': (context) => HomePage(),
        '/loginPage': (context) => LogInPage(),
      },
    );
  }

  Widget defaultHomePage() => isLoggedIn ? HomePage() : LogInPage();

  kRoute() {
    return {
      '/home': (context) => HomePage(),
      '/loginPage': (context) => LogInPage(),
    };
  }
}
