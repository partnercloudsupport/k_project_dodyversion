import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_project_dodyversion/blocs/user_bloc/user_bloc.dart';
import 'package:k_project_dodyversion/blocs/user_bloc/user_event.dart';
import 'package:k_project_dodyversion/blocs/user_bloc/user_state.dart';
import 'package:k_project_dodyversion/resources/repository.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  UserBloc _userBloc;
  @override
  void initState() {
    super.initState();
    _userBloc = new UserBloc();
    _userBloc.dispatch(LoadUserEvent(true,"asd"));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _userBloc,
      builder: (BuildContext context, UserState state) {
        return Container(
          child: returnContainer(state),
        );
      },
    );
  }

  Widget returnContainer(UserState state) {
    if (state is LoadingUser) {
      return Text("Loading user");
    } else if (state is UserLoadedSuccessfully) {
      return Text(state.userModel.name);
    } else if (state is UserLoadedFailed) {
      return Text("failed");
    } else {
      return Text("null");
    }
  }
}
