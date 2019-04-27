import 'package:intl/intl.dart';

class TimeUtils {
  static int getCurrentTime() => DateTime.now().millisecondsSinceEpoch;

  static DateTime convertMillisToDate(int timeInMillis) {
    return DateTime.fromMillisecondsSinceEpoch(timeInMillis);
  }

  static int convertToMillis(DateTime dateTime) =>
      dateTime.millisecondsSinceEpoch;

  static int getDay(DateTime dateTime) => dateTime.day;
  static int getHour(DateTime dateTime) => dateTime.hour;
  static int getMinute(DateTime dateTime) => dateTime.minute;
  static int getSecond(DateTime dateTime) => dateTime.second;

  static int getAge(DateTime dateOfBirth) =>
      DateTime.now().difference(dateOfBirth).inDays ~/ 365;

  static int getAgeInDays(DateTime time) =>
      DateTime.now().difference(time).inDays;

  static bool isValidDob(String dob) {
    if (dob.isEmpty) return false;
    var d = convertStringToDate(dob);
    return d != null && d.isBefore(new DateTime.now());
  }

  static DateTime convertStringToDate(String input) {
    try {
      var d = DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  static String convertDateToString(DateTime dt) => DateFormat.yMd().format(dt);
}
