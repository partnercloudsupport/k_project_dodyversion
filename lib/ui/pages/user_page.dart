import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_project_dodyversion/blocs/user_bloc/user_bloc.dart';
import 'package:k_project_dodyversion/blocs/user_bloc/user_event.dart';
import 'package:k_project_dodyversion/blocs/user_bloc/user_state.dart';
import 'package:k_project_dodyversion/ui/themes/theme.dart';
import 'package:k_project_dodyversion/utils/constant_utils.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  UserBloc _userBloc;
  TabController _controller;
  int _index;

  @override
  void initState() {
    super.initState();
    _userBloc = new UserBloc();
    _userBloc.dispatch(LoadUserEvent(true, "asd"));
    _controller = new TabController(
      length: 3,
      vsync: this,
    );
    _index = 0;
    _controller.addListener(_handleTabSelection);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _userBloc,
      builder: (BuildContext context, UserState state) {
        return Scaffold(
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
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        );
      },
    );
  }

  Widget getUserName(UserState state) {
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

  Widget getProfileTab(UserState state) {
    var padding1 = EdgeInsets.fromLTRB(10, 10, 10, 0);
    var padding1end = EdgeInsets.fromLTRB(10, 10, 10, 10);
    var padding2 = EdgeInsets.fromLTRB(20, 20, 20, 10);
    var padding3 = EdgeInsets.fromLTRB(20, 10, 20, 10);
    if (state is UserLoadedSuccessfully) {
      return Container(
        width: 1.7976931348623157e+308,
        height: 1.7976931348623157e+308,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
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
                          fit: BoxFit.fitHeight,
                          width: 100,
                          height: 100,
                          image: 'https://picsum.photos/250?image=9',
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
                          Text(state.userModel.uid),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
          onPressed: () => {},
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
          onPressed: () => {},
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
