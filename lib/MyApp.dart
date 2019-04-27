import 'package:flutter/material.dart';
import 'package:k_project_dodyversion/ui/pages/home_page.dart';
import 'package:k_project_dodyversion/ui/pages/login_page.dart';
import 'package:k_project_dodyversion/ui/pages/user_edit_page.dart';
import 'package:k_project_dodyversion/ui/pages/user_page.dart';
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
      routes: kRoute(),
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
