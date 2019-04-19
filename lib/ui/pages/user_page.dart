import 'package:flutter/material.dart';
import 'package:k_project_dodyversion/resources/repository.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {

UserRepository _userRepository = new UserRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Text(_userRepository.getCurrentUserName()),
    );
  }
}