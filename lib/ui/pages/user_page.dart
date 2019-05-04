import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_project_dodyversion/blocs/bloc.dart';
import 'package:k_project_dodyversion/resources/user_repo/user_provider.dart';
import 'package:k_project_dodyversion/ui/cards/service_card.dart';
import 'package:k_project_dodyversion/ui/pages/pages.dart';
import 'package:k_project_dodyversion/ui/themes/theme.dart';
import 'package:k_project_dodyversion/utils/constant_utils.dart';
import 'package:k_project_dodyversion/utils/notification_utils.dart';

final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  bool ownUserMode = true;
  TabController _controller;
  int _index;

  UserBloc _userBloc = UserBloc();
  ServiceBloc _serviceBloc = ServiceBloc();

  @override
  void initState() {
    super.initState();
    _controller = new TabController(
      length: 3,
      vsync: this,
    );
    _index = 0;
    _controller.addListener(_handleTabSelection);
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
          return Scaffold(
            key: scaffoldKey,
            floatingActionButton: buildFAB(_index),
            appBar: AppBar(
              title: getUserName(state),
              bottom: TabBar(
                controller: _controller,
                tabs: <Widget>[
                  Tab(text: "Profile"),
                  Tab(text: "My Orders"),
                  Tab(text: "My Services"),
                ],
              ),
            ),
            backgroundColor: KProjectTheme.primarySwatch.shade400,
            body: TabBarView(
              controller: _controller,
              children: [
                getProfileTab(state),
                Icon(Icons.directions_bike),
                getMyServices(state),
              ],
            ),
          );
        },
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

  Widget getMyServices(UserState state) {
    _serviceBloc.dispatch(LoadAllServicesWithQuery(parameter: "ownerID", value: UserProvider.mUser.uid));
    return BlocBuilder(
      bloc: _serviceBloc,
      builder: (BuildContext context, ServiceState state) {
        if (state is LoadingState) return Text("loading");
        if (state is LoadServicesSuccessful)
          return ListView.builder(
            itemCount: state.serviceList.length,
            padding: EdgeInsets.all(8.0),
            itemBuilder: (BuildContext context, int i) {
              return ListTile(
                title: ServiceCard(state.serviceList[i]),
              );
            },
          );
        return Text(state.toString());
      },
    );
  }

  Widget getProfileTab(UserState state) {
    var padding1 = EdgeInsets.fromLTRB(10, 10, 10, 0);
    var padding1end = EdgeInsets.fromLTRB(10, 10, 10, 10);
    var padding2 = EdgeInsets.fromLTRB(20, 20, 20, 10);
    var padding3 = EdgeInsets.fromLTRB(20, 10, 20, 10);
    if (state is UserLoadedSuccessfully) {
      print("user service ids here : " + state.userModel.serviceIDs.toString());
      return Container(
        width: 1.7976931348623157e+308,
        height: 1.7976931348623157e+308,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            /// First Card (Personal Data)
            Padding(
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
                          placeholder:
                              Constant.ASSET_USERPROFILE_PLACEHOLDER_PATH,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(state.userModel.name),
                          Text(state.userModel.email),
                          Text(state.userModel.languages),
                          Text("Age : ${state.userModel.age}"),
                          Text(
                              "Member for ${state.userModel.membershipDuration}"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Second Card (Biography)
            Padding(
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
            ),

            /// Third Card (Education)
            Padding(
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
            ),

            /// Forth Card ( Experience )
            Padding(
              padding: padding1end,
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
            ),
          ],
        ),
      );
    } else {
      return Center(
          child: Container(
              width: 50, height: 50, child: CircularProgressIndicator()));
    }
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

  Widget buildFAB(int index) {
    switch (index) {
      case 0:
        return FloatingActionButton(
          heroTag: "FirstFAB",
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => BlocProviderTree(
                        blocProviders: [
                          BlocProvider<UserBloc>(bloc: _userBloc),
                          BlocProvider<ServiceBloc>(bloc: _serviceBloc),
                        ],
                        child: EditUserProfilePage(),
                      ),
                ));
          },
          tooltip: 'Edit Profile',
          child: Icon(Icons.edit),
        );
        break;
      case 1:
        return FloatingActionButton(
          onPressed: () => {},
          tooltip: 'Add Orders',
          child: Icon(Icons.add),
        );
        break;
      case 2:
        return FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => BlocProviderTree(
                        blocProviders: [
                          BlocProvider<UserBloc>(bloc: _userBloc),
                          BlocProvider<ServiceBloc>(bloc: _serviceBloc),
                        ],
                        child: AddServicePage(),
                      ),
                ));
          },
          tooltip: 'Sell Services',
          child: Icon(Icons.add),
        );
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _index = _controller.index;
    });
  }
}
