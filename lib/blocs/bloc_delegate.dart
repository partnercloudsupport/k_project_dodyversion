import 'package:bloc/bloc.dart';

class KBlocDelegate extends BlocDelegate {
  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    // TODO: implement onError
    print("Error : $error with stacktrace :: $stacktrace");
  }

  @override
  void onTransition(Transition transition) {
    super.onTransition(transition);
    // TODO: implement onTransition
    print('This is on Transistion $transition');
  }
}