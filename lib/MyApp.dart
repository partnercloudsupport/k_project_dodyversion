import 'package:flutter/material.dart';
import 'package:k_project_dodyversion/ui/pages/pages.dart';
import 'package:k_project_dodyversion/ui/themes/theme.dart';

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
      theme: KProjectTheme.getTheme(context),
      home: defaultHomePage(),
    );
  }

  Widget defaultHomePage() => isLoggedIn ? HomePage() : LogInPage();

  kRoute() {
    return {
      '/home': (context) => HomePage(),
      '/loginPage': (context) => LogInPage(),
      '/profilePage':(context) => UserProfilePage(),
      // '/editProfilePage':(context) => EditUserProfilePage(),
    };
  }
}
