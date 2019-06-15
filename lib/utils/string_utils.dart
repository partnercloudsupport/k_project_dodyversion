import 'package:uuid/uuid.dart';

class StringUtils {
  static final Uuid uuid = new Uuid();
  static String appendRandom(int numOfRandomCharacters, String string) {
    return string + uuid.v1().substring(0, numOfRandomCharacters);
  }

  static String randomString() {
    return uuid.v1();
  }
}
