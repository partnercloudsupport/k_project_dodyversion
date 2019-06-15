import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_project_dodyversion/blocs/bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:k_project_dodyversion/ui/cards/service_card.dart';
import 'package:k_project_dodyversion/ui/pages/pages.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

RefreshController _refreshController;

// the 'widget' obj here is the HomePage from the State<>
class _HomePage extends State<HomePage> {
  ServiceBloc _serviceBloc;

  @override
  void initState() {
    super.initState();
    _serviceBloc = new ServiceBloc();
    _serviceBloc.dispatch(LoadAllServices(query: "null"));
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    _serviceBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: Container(
            height: 10e308,
            child: Padding(
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: <Widget>[
                        Text("Search something"),
                        Icon(Icons.search),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ),
                ),
                onTap: () {
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) => SearchPage(),
                  );
                  Navigator.of(context).push(route);
                },
              ),
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 10,
                right: 10,
              ),
            ),
          ),
        ),
      ),
      body: Container(
          child: BlocBuilder(
        bloc: _serviceBloc,
        builder: (BuildContext context, ServiceState state) {
          if (state is LoadingState) return Text("loading");
          if (state is LoadServicesSuccessful)
            return SmartRefresher(
              child: ListView.builder(
                itemCount: state.serviceList.length,
                padding: EdgeInsets.all(8.0),
                itemBuilder: (BuildContext context, int i) {
                  return ListTile(
                    title: ServiceCard(state.serviceList[i]),
                  );
                },
              ),
              onRefresh: () async {
                await Future.delayed(Duration(milliseconds: 1000));
                _serviceBloc.dispatch(LoadAllServices(query: "null"));
                _refreshController.loadComplete();
                return null;
              },
              controller: _refreshController,
            );
          return Text("oops");
        },
      )),
      // floatingActionButton: Padding(
      //   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: <Widget>[
      //       // FloatingActionButton(
      //       //   heroTag: "ulala1",
      //       //   onPressed: () => setState(() {
      //       //         _serviceBloc.dispatch(LoadAllServices(query: "null"));
      //       //       }),
      //       //   tooltip: 'Refresh List',
      //       //   child: Icon(Icons.add),
      //       // ),
      //       FloatingActionButton(
      //         heroTag: "ulala2",
      //         onPressed: () => {Navigator.pushNamed(context, '/profilePage')},
      //         tooltip: 'User Profile',
      //         child: Icon(Icons.airplanemode_active),
      //       ),
      //     ],
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
