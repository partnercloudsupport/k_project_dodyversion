import 'package:flutter/material.dart';
import 'package:k_project_dodyversion/models/models.dart';

class ServicePage extends StatefulWidget {
  ServiceModel model;
  ServicePage(this.model, {Key key})
      : assert(model != null),
        super(key: key);

  _ServicePageState createState() => _ServicePageState(model);
}

class _ServicePageState extends State<ServicePage> {
  ServiceModel _model;
  _ServicePageState(this._model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_model.serviceName),
      ),
      body: Container(
        child: Center(
          child: Column(children: <Widget>[
            ...displayModelData(),
            ...displayActionButtons(),
            Text(_model.serviceID),
          ]),
        ),
      ),
    );
  }

  Set<Widget> displayModelData() {
    return {
      Text(_model.serviceName),
      Text(_model.serviceID),
    };
  }

  Set<Widget> displayActionButtons() {
    return {
      RaisedButton(
        child: Text("Make Offer"),
      ),
      RaisedButton(
        child: Text("Chat"),
      )
    };
  }
}
