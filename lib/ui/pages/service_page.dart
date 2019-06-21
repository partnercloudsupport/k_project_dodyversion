import 'package:flutter/material.dart';
import 'package:k_project_dodyversion/models/models.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:k_project_dodyversion/resources/repository.dart';
import 'package:k_project_dodyversion/ui/pages/pages.dart';
import 'package:k_project_dodyversion/utils/widget_utils.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class ServicePage extends StatefulWidget {
  final ServiceModel model;
  ServicePage(this.model, {Key key})
      : assert(model != null),
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
        title: Text(widget.model.serviceName),
      ),
      body: getBody(),
      // body: Container(
      //   child: Center(
      //     child: Column(children: <Widget>[
      //       ...displayModelData(),
      //       ...displayActionButtons(),
      //       Text(widget.model.serviceID),
      //     ]),
      //   ),
      // ),
    );
  }

  Widget getBody() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            CarouselSlider(
              viewportFraction: 0.9,
              aspectRatio: 16 / 9,
              autoPlay: (widget.model.mediaURLs.length == 0) ? false : true,
              enlargeCenterPage: true,
              pauseAutoPlayOnTouch: Duration(seconds: 3),
              items: WidgetUtils.mapListToWidgetList(widget.model.mediaURLs,
                  (index, img, length) {
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
              }),
            ),
            ...displayModelData(),
            ...displayActionButtons(),
            Container(
              height: 100,
              color: Colors.black,
            ),
            getOwner(),
            Container(
              height: 100,
              color: Colors.black,
            ),
          ]),
        ),
      ],
    );
  }

  Set<Widget> displayModelData() {
    return {
      Text(widget.model.serviceName),
      Text(widget.model.serviceID),
    };
  }

  Set<Widget> displayActionButtons() {
    return {
      RaisedButton(
        child: Text("Make Offer"),
        onPressed: _makeOffer,
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
        child: (widget.model.ownerID == UserRepository.mUser.uid)
            ? Text("This is your service")
            : Text("The seller is ${widget.model.ownerName}"),
      ),
    );
  }

  _startChatting() {
    var route = new MaterialPageRoute(
      builder: (BuildContext context) =>
          ChatsPage(widget.model.ownerID, widget.model.ownerName),
    );
    Navigator.of(context).push(route);
  }

  _makeOffer() {
    widget.model.customerIDs.add(UserRepository.mUser.uid);
    print(widget.model.serviceName);
    print(widget.model.ownerName);
    print(widget.model.customerIDs);
  }
}
