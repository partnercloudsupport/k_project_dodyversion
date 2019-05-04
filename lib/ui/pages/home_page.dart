import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_project_dodyversion/blocs/bloc.dart';

import 'package:k_project_dodyversion/ui/cards/service_card.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

// the 'widget' obj here is the HomePage from the State<>
class _HomePage extends State<HomePage> {
  ServiceBloc _serviceBloc;

  @override
  void initState() {
    super.initState();
    _serviceBloc = new ServiceBloc();
    _serviceBloc.dispatch(LoadAllServices());
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
        title: Text('Sample Code'),
      ),
      body: Container(
          child: BlocBuilder(
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
          return Text("oops");
        },
      )),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "ulala1",
              onPressed: () => setState(() {
                    _serviceBloc.dispatch(LoadAllServices());
                  }),
              tooltip: 'Refresh List',
              child: Icon(Icons.add),
            ),
            FloatingActionButton(
              heroTag: "ulala2",
              onPressed: () => {Navigator.pushNamed(context, '/profilePage')},
              tooltip: 'User Profile',
              child: Icon(Icons.airplanemode_active),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
