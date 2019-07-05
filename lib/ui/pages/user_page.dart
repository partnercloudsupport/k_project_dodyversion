import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_project_dodyversion/blocs/bloc.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:k_project_dodyversion/resources/repository.dart';
import 'package:k_project_dodyversion/ui/Widgets/past_experience_edit_aler_dialog.dart';
import 'package:k_project_dodyversion/ui/Widgets/past_experiences_card.dart';
import 'package:k_project_dodyversion/ui/cards/service_card.dart';
import 'package:k_project_dodyversion/ui/pages/pages.dart';
import 'package:k_project_dodyversion/ui/themes/theme.dart';
import 'package:k_project_dodyversion/utils/constant_utils.dart';
import 'package:k_project_dodyversion/utils/notification_utils.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
  int numOfAlmamaters = 0;
  List<String> almamaters = [];
  int numOfPastExperiences = 0;
  List<String> pastExperiences = [];
  UserModel um;

  UserBloc _userBloc = UserBloc();
  ServiceBloc _mServicesBloc = new ServiceBloc();

  @override
  void initState() {
    _mServicesBloc.dispatch(LoadAllServicesWithQuery(
        parameter: ServiceModel.FIREBASE_OID, value: UserRepository.mUser.uid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _userBloc,
      listener: (BuildContext context, UserState state) {
        if (state is UpdateUserSuccess ||
            state is UpdatePastExperiencesPictureSuccessful) {
          NotificationUtils.showMessage("Profile is updated successfully",
              _scaffoldKey, NotificationTone.POSITIVE);
          _userBloc.dispatch(LoadUserEvent(ownUserMode, ""));
          return;
        } else if (state is InitiateState) {
          _userBloc.dispatch(LoadUserEvent(ownUserMode, ""));
          return;
        }

        if (state is UserLoadedSuccessfully) {
          um = state.userModel;
        }
      },
      child: BlocBuilder(
        bloc: _userBloc,
        builder: (BuildContext context, UserState state) {
          return BlocBuilder(
            bloc: _mServicesBloc,
            builder: (BuildContext context, ServiceState serviceState) {
              return Scaffold(
                key: _scaffoldKey,
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
    return null;
  }

  Widget myServicesSliver(ServiceState state) {
    if (state is LoadServicesSuccessful) {
      if (state.serviceList.length == 0)
        return SliverList(
          delegate: SliverChildListDelegate([
            Center(
              child: Text("Sell Some Services!"),
            ),
          ]),
        );

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
    return null;
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

  /// Third Card ( Experience )
  Widget educationCard(UserLoadedSuccessfully state) {
    almamaters = state.userModel.almamaters.cast<String>();
    numOfAlmamaters = almamaters.length ~/ 3;
    List<Widget> educationCards = new List<Widget>(numOfAlmamaters);
    for (int i = 0; i < numOfAlmamaters; i++) {
      educationCards[i] = PastExperienceCard(
          onTap: () {},
          data:
              almamaters.getRange(i * 3, (i + 1) * 3).toList().cast<String>());
    }
    return Padding(
      padding: padding1,
      child: GestureDetector(
        onLongPress: _addEducation,
        child: Card(
          child: Padding(
            padding: padding3,
            child: Column(
              children: <Widget>[
                Text("Educations"),
                Container(
                  constraints: BoxConstraints(maxHeight: 10),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: educationCards,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Forth Card (Education)
  Widget experienceCard(UserLoadedSuccessfully state) {
    pastExperiences = state.userModel.pastExperiences.cast<String>();
    numOfPastExperiences = pastExperiences.length ~/ 3;
    List<Widget> expericeCards = new List<Widget>(numOfPastExperiences.toInt());
    for (int i = 0; i < numOfPastExperiences; i++) {
      expericeCards[i] = PastExperienceCard(
          index: i,
          onTap: () {},
          data: pastExperiences
              .getRange(i * 3, (i + 1) * 3)
              .toList()
              .cast<String>());
    }
    return Padding(
      padding: padding1,
      child: GestureDetector(
        onLongPress: _addExperience,
        child: Card(
          child: Padding(
            padding: padding3,
            child: Column(
              children: <Widget>[
                Text("Past Experience"),
                Container(
                  constraints: BoxConstraints(maxHeight: 10),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: expericeCards,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
              ],
            ),
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

  Future<void> _addExperience() async {
    if (numOfPastExperiences == 3) {
      return showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
              content: Container(
                child: Text("You can only post 3 past experiences"),
              ),
            );
          });
    } else {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return PastExperienceAlertDialog(
              _userBloc, PastExperienceType.PastExperience, um);
        },
      );
    }
  }

  Future<void> _addEducation() async {
    if (numOfAlmamaters == 3) {
      return showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
              content: Container(
                child: Text("You can only post 3 past educations"),
              ),
            );
          });
    } else {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return PastExperienceAlertDialog(
              _userBloc, PastExperienceType.Almamater, um);
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _mServicesBloc.dispose();
  }
}
