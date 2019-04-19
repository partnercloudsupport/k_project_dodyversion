import 'package:bloc/bloc.dart';
import 'package:k_project_dodyversion/blocs/user_bloc/user_event.dart';
export 'package:k_project_dodyversion/blocs/user_bloc/user_event.dart';
import 'package:k_project_dodyversion/blocs/user_bloc/user_state.dart';
export 'package:k_project_dodyversion/blocs/user_bloc/user_state.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:k_project_dodyversion/resources/repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserRepository _userRepository = UserRepository();
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  @override
  UserState get initialState => InitiateState();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is LoadUserEvent) {
      yield* mapLoadUserEvent(event.ownUser, event.uid);
    } else if (event is UpdateUserEvent) {
      yield* mapUpdateUserEvent();
    }
  }

  Stream<UserState> mapLoadUserEvent(bool ownUser, String uid) async* {
    try {
      yield LoadingUser();
      UserModel um;
      if (ownUser) {
        um = await _userRepository.loadUser(_firebaseRepository.uid);
        yield UserLoadedSuccessfully(um);
        return;
      }
      um = await _userRepository.loadUser(uid);
      yield UserLoadedSuccessfully(um);
    } catch (e) {
      print(e.toString());
      yield UserLoadedFailed();
    }
  }

  Stream<UserState> mapUpdateUserEvent() {}
}

class UserModal {}
