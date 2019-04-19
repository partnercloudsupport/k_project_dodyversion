import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_project_dodyversion/blocs/bloc.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

// the 'widget' obj here is the HomePage from the State<>
class _HomePage extends State<HomePage> {
  FirebaseBloc _firebaseBloc;

  @override
  void initState() {
    super.initState();
    _firebaseBloc = new FirebaseBloc();
    _firebaseBloc
        .dispatch(PullServicesDataFromFiresStoreCloudEvent(query: "asd"));
  }

  @override
  void dispose() {
    _firebaseBloc.dispose();
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
        bloc: _firebaseBloc,
        builder: (BuildContext context, FirebaseState state) {
          if (state is FireStoreLoading) return Text("loading");
          if (state is ServicesCollected)
            return ListView.builder(
              itemCount: state.serviceList.length,
              padding: EdgeInsets.all(8.0),
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  title: Text(" ${state.serviceList[i].title}"),
                );
              },
            );
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
              onPressed: () => setState(() {
                    _firebaseBloc.dispatch(
                        PullServicesDataFromFiresStoreCloudEvent(query: "asd"));
                  }),
              tooltip: 'Refresh List',
              child: Icon(Icons.add),
            ),
            FloatingActionButton(
              onPressed: () => setState(() {
                    _firebaseBloc.dispatch(
                        PullServicesDataFromFiresStoreCloudEvent(query: "asd"));
                  }),
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
