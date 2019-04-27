import 'package:flutter/material.dart';

enum NotificationTone { POSITIVE, NEGATIVE, NEUTRAL }

class NotificationUtils {
  static void showMessage(String message, GlobalKey<ScaffoldState> scaffoldKey,
      [NotificationTone tone = NotificationTone.NEUTRAL]) {
    switch (tone) {
      case NotificationTone.NEUTRAL:
        scaffoldKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.black, content: new Text(message)));
        break;
      case NotificationTone.POSITIVE:
        scaffoldKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.green, content: new Text(message)));
        break;
      case NotificationTone.NEGATIVE:
        scaffoldKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.red, content: new Text(message)));

        break;
      default:
    }
  }
}
