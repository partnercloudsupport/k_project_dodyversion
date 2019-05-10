import 'package:flutter/material.dart';
import 'package:k_project_dodyversion/models/service_model.dart';
import 'package:k_project_dodyversion/ui/pages/pages.dart';

@immutable
class ServiceCard extends StatelessWidget {
  final ServiceModel _model;

  ServiceCard(this._model);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ServicePage(_model))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album),
              title: Text(_model.serviceName),
              subtitle: Text(_model.description),
            ),
            ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text('MAKE OFFER'),
                    onPressed: () {/* ... */},
                  ),
                  FlatButton(
                    child: Text('CHAT'),
                    onPressed: () {/* ... */},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
