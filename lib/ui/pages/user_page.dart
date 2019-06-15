import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_project_dodyversion/blocs/bloc.dart';
import 'package:k_project_dodyversion/resources/repository.dart';
import 'package:k_project_dodyversion/ui/cards/service_card.dart';
import 'package:k_project_dodyversion/ui/pages/pages.dart';
import 'package:k_project_dodyversion/ui/themes/theme.dart';
import 'package:k_project_dodyversion/utils/constant_utils.dart';
import 'package:k_project_dodyversion/utils/notification_utils.dart';
import 'package:image_picker/image_picker.dart';

final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

class UserProfilePage extends StatefulWidget {
  UserProfilePage({Key key}) : super(key: key);
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  var padding1 = EdgeInsets.fromLTRB(10, 10, 10, 0);
  var padding1end = EdgeInsets.fromLTRB(10, 10, 10, 10);
  var padding2 = EdgeInsets.fromLTRB(20, 20, 20, 10);
  var padding3 = EdgeInsets.fromLTRB(20, 10, 20, 10);

  bool ownUserMode = true;

  UserBloc _userBloc = UserBloc();
  ServiceBloc _mServicesBloc = new ServiceBloc();

  @override
  void initState() {
    _mServicesBloc.dispatch(LoadAllServicesWithQuery(
        parameter: "ownerID", value: UserRepository.mUser.uid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _userBloc,
      listener: (BuildContext context, UserState state) {
        if (state is UpdateUserSuccess) {
          NotificationUtils.showMessage("Profile is updated successfully",
              scaffoldKey, NotificationTone.POSITIVE);
          _userBloc.dispatch(LoadUserEvent(ownUserMode, ""));
          return;
        }
        if (state is InitiateState) {
          _userBloc.dispatch(LoadUserEvent(ownUserMode, ""));
          return;
        }
      },
      child: BlocBuilder(
        bloc: _userBloc,
        builder: (BuildContext context, UserState state) {
          return BlocBuilder(
            bloc: _mServicesBloc,
            builder: (BuildContext context, ServiceState serviceState) {
              return Scaffold(
                key: scaffoldKey,
                appBar: AppBar(
                  title: getUserName(state),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.add),
                      tooltip: 'Add Services',
                      onPressed: () {
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) => AddServicePage(),
                        );
                        Navigator.push(context, route);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      tooltip: 'Edit Profile',
                      onPressed: () {
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              EditUserProfilePage(_userBloc),
                        );
                        Navigator.push(context, route);
                      },
                    ),
                  ],
                ),
                backgroundColor: KProjectTheme.primarySwatch.shade400,
                body: getBody(state, serviceState),
              );
            },
          );
        },
      ),
    );
  }

  Widget getBody(UserState state, ServiceState serviceState) {
    if (state is UserLoadedSuccessfully) {
      return CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                profileCard(state),
                bioCard(state),
                educationCard(state),
                experienceCard(state),
              ],
            ),
          ),
          myServicesSliver(serviceState),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                height: 15,
              ),
            ]),
          )
        ],
      );
    } else {
      return Center(
          child: Container(
              width: 50, height: 50, child: CircularProgressIndicator()));
    }
  }

  Widget profileCard(UserLoadedSuccessfully state) {
    return Padding(
      padding: padding1,
      child: Card(
        child: Padding(
          padding: padding2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                  image: state.userModel.profilePictureURL,
                  placeholder: Constant.ASSET_USERPROFILE_PLACEHOLDER_PATH,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(state.userModel.name),
                  Text(state.userModel.email),
                  Text(state.userModel.languages),
                  Text("Age : ${state.userModel.age}"),
                  Text("Member for ${state.userModel.membershipDuration}"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getUserName(UserState state) {
    if (state is LoadingUser) {
      return Text("Loading user");
    } else if (state is UserLoadedSuccessfully) {
      return Text(state.userModel.name);
    } else if (state is UserLoadedFailed) {
      return Text("failed");
    } else if (state is UpdateUserSuccess) {
    } else {
      return Text("null");
    }
  }

  Widget myServicesSliver(ServiceState state) {
    if (state is LoadServicesSuccessful) {
      if (state.serviceList.length == 0)
        return Center(child: Text("Sell Some Services!"));

      return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          if (index >= state.serviceList.length) return null;
          return Padding(
            padding: padding1,
            child: ServiceCard(state.serviceList[index]),
          );
        }),
      );
    }
  }
  
  Widget bioCard(UserLoadedSuccessfully state) {
    return Padding(
      padding: padding1,
      child: Card(
        child: Padding(
          padding: padding3,
          child: Column(
            children: <Widget>[
              Text("Biography"),
              Text(
                state.userModel.description,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Third Card (Education)
  Widget educationCard(UserState state) {
    return Padding(
      padding: padding1,
      child: Card(
        child: Padding(
          padding: padding3,
          child: Column(
            children: <Widget>[
              Text("Past Experience"),
              Row(
                children: <Widget>[
                  RaisedButton(child: Text("asd")),
                  RaisedButton(child: Text("asd")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Forth Card ( Experience )
  Widget experienceCard(UserState state) {
    return Padding(
      padding: padding1,
      child: Card(
        child: Padding(
          padding: padding3,
          child: Column(
            children: <Widget>[
              Text("Past Education"),
              Row(
                children: <Widget>[
                  RaisedButton(child: Text("asd")),
                  RaisedButton(child: Text("asd")),
                ],
              ),
            ],
          ),
        ),
      ),
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

  @override
  void dispose() {
    super.dispose();
    _mServicesBloc.dispose();
  }
}
