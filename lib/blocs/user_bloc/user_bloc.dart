import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    if (event is LoadUserEvent) {
      yield* mapLoadUserEvent(event.ownUser, event.uid);
    } else if (event is UpdateUserEvent) {
      yield* mapUpdateUserEvent(event.userModel);
    } else if (event is UpdateProfilePictureEvent) {
      yield* mapUpdateProfilePictureEvent(event.pictureData);
    } else if (event is UpdatePastExperiencePictureEvent) {
      // yield* mapUpdateProfilePictureEvent(event.pictureData);
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

  Stream<UserState> mapUpdateUserEvent(UserModel userModel) async* {
    yield UpdatingUser();
    _userRepository.updateCurrentUser(userModel);
    yield UpdateUserSuccess();
    dispatch(LoadUserEvent(true, ""));
  }

  Stream<UserState> mapUpdateProfilePictureEvent(Uint8List pictureData) async* {
    try {
      yield UpdatingProfilePicture();
      Stream<StorageTaskEvent> eventStream =
          await _userRepository.updateProfilePicture(pictureData);
      await for (StorageTaskEvent event in eventStream) {
        print("${event.snapshot.bytesTransferred} + bytes transferrrrred");
        if (event.type == StorageTaskEventType.success) {
          var url = await event.snapshot.ref.getDownloadURL();
          yield UpdateProfilePictureSuccessful(url);
          return;
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<UserState> mapUpdatePastExperiencesEvent(
      Uint8List pictureData) async* {
    try {
      yield UpdatingPastExperiencesPicture();
      Stream<StorageTaskEvent> eventStream =
          await _userRepository.updatePastExperiencePicture(pictureData);
      await for (StorageTaskEvent event in eventStream) {
        print("${event.snapshot.bytesTransferred} + bytes transferrrrred");
        if (event.type == StorageTaskEventType.success) {
          var url = await event.snapshot.ref.getDownloadURL();
          yield UpdatePastExperiencesPictureSuccessful(url);
          return;
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
