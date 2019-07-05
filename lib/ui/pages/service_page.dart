import 'package:flutter/material.dart';
import 'package:k_project_dodyversion/models/models.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:k_project_dodyversion/resources/repository.dart';
import 'package:k_project_dodyversion/ui/pages/pages.dart';
import 'package:k_project_dodyversion/utils/widget_utils.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class ServicePage extends StatefulWidget {
  final ServiceModel _model;
  ServicePage(this._model, {Key key})
      : assert(_model != null),
        super(key: key);

  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  _ServicePageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget._model.serviceName),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    List<Widget> items = WidgetUtils.mapListToWidgetList(
        widget._model.mediaURLs, (index, img, length) {
      if (length == 0) {
        return Container(
          child: Center(
            child: Text("No picture"),
          ),
        );
      }
      return Container(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Image.network(
            img,
            fit: BoxFit.cover,
            width: 1000,
          ),
        ),
      );
    });

    items.add(Center(child: Text("ADD new")));
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            CarouselSlider(
              viewportFraction: 1.0,
              aspectRatio: 1 / 1,
              // autoPlay: (widget._model.mediaURLs.length == 0) ? false : true,
              // enlargeCenterPage: true,
              // pauseAutoPlayOnTouch: Duration(seconds: 3),
              items: items,
            ),
            ...displayModelData(),
            ...displayActionButtons(),
          ]),
        ),
      ],
    );
  }

  Set<Widget> displayModelData() {
    return {
      Text(widget._model.serviceName),
      Text(widget._model.serviceID),
    };
  }

  // Your own service should not have button
  Set<Widget> displayActionButtons() {
    if (widget._model.isMyService) {
      return {};
    }
    return {
      RaisedButton(
        child: Text("Make Offer"),
        onPressed: (widget._model.isBoughtByMe) ? null : _makeOffer,
      ),
      RaisedButton(
        child: Text("Chat"),
        onPressed: _startChatting,
      )
    };
  }

  Widget getOwner() {
    return Container(
      child: Center(
        child: (widget._model.ownerID == UserRepository.mUser.uid)
            ? Text("This is your service")
            : Text("The seller is ${widget._model.ownerName}"),
      ),
    );
  }

  _startChatting() {
    var route = new MaterialPageRoute(
      builder: (BuildContext context) =>
          ChatsPage(widget._model.ownerID, widget._model.ownerName),
    );
    Navigator.of(context).push(route);
  }

  _makeOffer() {
    widget._model.customerIDs.add(UserRepository.mUser.uid);
    print(widget._model.serviceName);
    print(widget._model.ownerName);
    print(widget._model.customerIDs);
  }
}
