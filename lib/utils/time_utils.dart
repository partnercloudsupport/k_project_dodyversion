class TimeUtils {
  static int getCurrentTime() => DateTime.now().millisecondsSinceEpoch;

  static DateTime getFormatedTime(int timeInMillis) {
    return DateTime.fromMicrosecondsSinceEpoch(timeInMillis);
  }

  static int converToMillis(DateTime dateTime) => dateTime.millisecondsSinceEpoch;

  static int getDay(DateTime dateTime) => dateTime.day;
  static int getHour(DateTime dateTime) => dateTime.hour;
  static int getMinute(DateTime dateTime) => dateTime.minute;
  static int getSecond(DateTime dateTime) => dateTime.second;

  static int getAge(DateTime dateOfBirth) =>  dateOfBirth.difference(DateTime.now()).inDays ~/ 365;
}
