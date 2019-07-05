import 'package:flutter/material.dart';
import 'package:k_project_dodyversion/models/service_model.dart';
import 'package:k_project_dodyversion/ui/pages/pages.dart';
import 'package:k_project_dodyversion/utils/utils.dart';

@immutable
class ServiceCard extends StatelessWidget {
  final ServiceModel _model;

  ServiceCard(this._model);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: new BorderRadius.all(Radius.circular(5)),
      elevation: 1,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          var route = new MaterialPageRoute(
            builder: (BuildContext context) => ServicePage(_model),
          );
          Navigator.of(context).push(route);
        },
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                    image: (_model.mediaURLs.length == 0)
                        ?  Constant.ASSET_USERPROFILE_PLACEHOLDER_PATH
                        : _model.mediaURLs[0],
                    placeholder: Constant.ASSET_USERPROFILE_PLACEHOLDER_PATH,
                  ),
                ),
                title: Text(_model.serviceName),
                subtitle: Text(_model.description),
              ),
              (!_model.isMyService)
                  ? ButtonTheme.bar(
                      // make buttons use the appropriate styles for cards
                      child: (_model.isBoughtByMe)
                          ? ButtonBar(
                              children: <Widget>[
                                FlatButton(
                                  child: Text("BOUGHT"),
                                  onPressed: null,
                                )
                              ],
                            )
                          : ButtonBar(
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
                    )
                  : new Container(),
            ],
          ),
        ),
      ),
    );
  }
}
