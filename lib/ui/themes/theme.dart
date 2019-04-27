import 'package:flutter/material.dart';

class KProjectTheme {
  static const int PRIMARY_COLOR_VALUE = 0xffd3b8ae;
  static const int SECONDARY_COLOR_VALUE = 0xffaec9d3;
  static const Color PRIMARY_COLOR = Color(PRIMARY_COLOR_VALUE);
  static const Color SECONDARY_COLOR = Color(SECONDARY_COLOR_VALUE);

  static const Color NEGATIVE_COLOR = Colors.red;
  static const Color POSITIVE_COLOR = Colors.blue;
  static const Color NEUTRAL_COLOR = Colors.white;

  static const Color NEUTRAL_TEXT_COLOR = Colors.black;
  static const double BORDER_KERNEL_RADIUS = 30;

  static const Color GRADIENT_END_COLOR = Color(SECONDARY_COLOR_VALUE);
  static const Color GRADIENT_START_COLOR = Color(PRIMARY_COLOR_VALUE);

  static Shader linearGradient = LinearGradient(
    colors: <Color>[GRADIENT_END_COLOR, GRADIENT_START_COLOR],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  static const MaterialColor primarySwatch = MaterialColor(
    PRIMARY_COLOR_VALUE,
    <int, Color>{
      50: Color(0xfffaede6),
      100: Color(0xffe8d4cc),
      200: Color(PRIMARY_COLOR_VALUE),
      300: Color(0xffbd9b8e),
      400: Color(0xffab8474),
      500: Color(0xff9a6d5b),
      600: Color(0xff8d6354),
      700: Color(0xff7b5649),
      800: Color(0xff6c4940),
      900: Color(0xff5b3b34),
    },
  );

  static const MaterialColor secondarySwatch =
      MaterialColor(SECONDARY_COLOR_VALUE, <int, Color>{
    50: Color(0xffe5f3fa),
    100: Color(0xffcae0e6),
    200: Color(SECONDARY_COLOR_VALUE),
    300: Color(0xff90b2bf),
    400: Color(0xff79a0ae),
    500: Color(0xff618e9e),
    600: Color(0xff557f8c),
    700: Color(0xff466a76),
    800: Color(0xff385661),
    900: Color(0xff274049),
  });

  static getTheme(BuildContext context) {
    return ThemeData(
      primarySwatch: primarySwatch,
      accentColor: SECONDARY_COLOR,
      textTheme: Theme.of(context).textTheme.copyWith(
            body1: new TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w300,
              fontSize: 14,
              letterSpacing: 3,
            ),
            body2: new TextStyle(
              color: primarySwatch.shade800,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              letterSpacing: 3,
            ),
            display1: new TextStyle(
              color: primarySwatch.shade800,
              fontWeight: FontWeight.w500,
              fontSize: 20,
              letterSpacing: 1,
            ),
            button: new TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: 3,
            ),
          ),
    );
  }

  static TextStyle getTitleTextTheme() {
    return TextStyle(
      color: primarySwatch.shade800,
      fontWeight: FontWeight.w100,
      fontSize: 64,
      letterSpacing: 10,
    );
  }

  static BoxDecoration getDecoration(bool whiteBackground) {
    if (whiteBackground) {
      return BoxDecoration(color: Colors.white);
    }
    return BoxDecoration(color: primarySwatch.shade100);
  }
}
