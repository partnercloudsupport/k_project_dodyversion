import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_project_dodyversion/blocs/bloc.dart';
import 'package:k_project_dodyversion/models/models.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> _list = List<String>();
  ServiceBloc _serviceBloc;
  TextEditingController _controller;
  String _criteria = "";
  Timer _resultsTimer;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _serviceBloc = ServiceBloc();
    _controller = TextEditingController();
    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _criteria = _controller.value.text;
          _getResultsDebounced();
        });
      }
    });
  }
  
  @override
  void dispose() {
    super.dispose();
    _serviceBloc.dispose();
    _controller.dispose();
  }

  void popValue(String value) {
    _serviceBloc.dispose();
    if (_resultsTimer.isActive) {
      _resultsTimer.cancel();
    }
    Navigator.of(context).pop(value);
  }

  /// It will delay the getResult function for 0.4s
  /// so request count to server is minimized
  Future _getResultsDebounced() async {
    if (_resultsTimer != null && _resultsTimer.isActive) {
      _resultsTimer.cancel();
    }

    _resultsTimer = new Timer(new Duration(milliseconds: 400), () async {
      if (mounted) {
        setState(() {
          _loading = true;
        });
      } else {
        return;
      }
      getResults(_criteria);
    });
  }

  getResults(String criteria) {
    print(criteria);
    _serviceBloc.dispatch(new LoadAllServicesWithQuery(
        parameter: ServiceModel.FIREBASE_SNAME, value: criteria));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _serviceBloc,
      listener: (BuildContext context, ServiceState state) {
        print("state returned");
        if (mounted) {
          if (state is LoadingState) {
            setState(() {
              _loading = true;
            });
          } else if (state is LoadServicesSuccessful) {
            setState(() {
              _loading = false;
              _list = new List<String>();
              for (ServiceModel serviceModel in state.serviceList) {
                _list.add(serviceModel.serviceName);
              }
            });
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: new TextField(
            controller: _controller,
            autofocus: true,
            decoration: new InputDecoration.collapsed(hintText: "Search La"),
            style: Theme.of(context).textTheme.title,
            onSubmitted: (String value) {
              popValue(value);
            },
          ),
          actions: _criteria.length == 0
              ? []
              : [
                  new IconButton(
                      icon: new Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _controller.text = _criteria = '';
                        });
                      }),
                  new IconButton(
                      icon: new Icon(Icons.check_circle_outline),
                      onPressed: () {
                        popValue(_controller.value.text);
                      }),
                ],
        ),
        body: _loading
            ? new Center(
                child: new Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: new CircularProgressIndicator()),
              )
            : new SingleChildScrollView(
                child: new Column(
                  children: _list.map((String result) {
                    return new InkWell(
                      child: _searchCard(result, null),
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }

  Widget _searchCard(String text, IconData icon) {
    return InkWell(
      onTap: () {
        popValue(text);
      },
      child: Container(
        child: new Row(
          children: <Widget>[
            new Container(width: 70.0, child: new Icon(icon)),
            new Expanded(
                child:
                    new Text(text, style: Theme.of(context).textTheme.subhead)),
          ],
        ),
        height: 56.0,
      ),
    );
  }
}
