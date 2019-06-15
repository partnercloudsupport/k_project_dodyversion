import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:k_project_dodyversion/blocs/bloc.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:k_project_dodyversion/utils/notification_utils.dart';
import 'package:k_project_dodyversion/utils/widget_utils.dart';

/// This page is for the user to add services they offer.

final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class AddServicePage extends StatefulWidget {
  AddServicePage({Key key}) : super(key: key);

  AddServicePageState createState() => AddServicePageState();
}

class AddServicePageState extends State<AddServicePage> {
  ServiceModel _serviceModel;
  ServiceBloc _serviceBloc;

  @override
  void initState() {
    super.initState();
    _serviceModel = ServiceModel(null);
    _serviceBloc = ServiceBloc();
  }

  Future addImage() async {
    File tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (tempImage == null) {
      NotificationUtils.showMessage(
          "Uploading image cancelled", _scaffoldKey, NotificationTone.NEGATIVE);
      return;
    }
    print(tempImage.toString());
    _serviceBloc.dispatch(new AddServiceMedia(tempImage));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _serviceBloc,
      listener: (BuildContext context, ServiceState state) {
        if (state is AddServiceSuccessful) {
          _serviceBloc.dispatch(ResetServiceEvent());
          Navigator.pop(context, true);
        } else if (state is AddingNewServiceState) {
          NotificationUtils.showMessage(
              "Profile is updating!", _scaffoldKey, NotificationTone.POSITIVE);
        } else if (state is AddingMediaSuccessful) {
          setState(() {
            _serviceModel.mediaURLs.add(state.url);
          });
          NotificationUtils.showMessage(
              "Image is uploaded successfully", _scaffoldKey);
        } else if (state is AddingMedia) {
          NotificationUtils.showMessage("Uploading Image", _scaffoldKey);
        } else {
          _serviceBloc.dispatch(ResetServiceEvent());
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Add Service"),
        ),
        body: Container(
          child: Form(
            key: _formKey,
            autovalidate: true,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                CarouselSlider(
                    enableInfiniteScroll: false,
                    autoPlay: true,
                    items: WidgetUtils.mapListToWidgetList(
                        _serviceModel.mediaURLs, (index, img, length) {
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
                    })),
                RaisedButton(
                  child: Text("Upload Image"),
                  onPressed: addImage,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Enter your service name',
                    labelText: 'Service name',
                  ),
                  keyboardType: TextInputType.url,
                  inputFormatters: [LengthLimitingTextInputFormatter(30)],
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (val) => (val == null || val == "")
                      ? "Name cannot be empty"
                      : null,
                  onSaved: (val) => {_serviceModel.serviceName = val},
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.language),
                    hintText: 'The duration of the service in minutes',
                    labelText: 'Duration',
                    suffixText: "mins",
                  ),
                  inputFormatters: [LengthLimitingTextInputFormatter(100)],
                  keyboardType: TextInputType.number,
                  validator: (val) => (val == null || val == "")
                      ? "Duration cannot be empty!"
                      : null,
                  onSaved: (duration) {
                    _serviceModel.serviceDuration = int.parse(duration);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.language),
                    hintText: 'Price for the whole duration',
                    labelText: 'Price',
                    suffixText: "SGD",
                  ),
                  inputFormatters: [LengthLimitingTextInputFormatter(100)],
                  keyboardType: TextInputType.number,
                  validator: (val) => (val == null || val == "")
                      ? "Price cannot be empty!"
                      : null,
                  onSaved: (price) {
                    _serviceModel.price = double.parse(price);
                  },
                ),
                TextFormField(
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText:
                        'The description of the service. Convince your customers to user your service.',
                    labelText: 'Description',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLength: 200,
                  inputFormatters: [LengthLimitingTextInputFormatter(200)],
                  onSaved: (desc) {
                    _serviceModel.description = desc;
                  },
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                  child: RaisedButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        _submitForm();
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      NotificationUtils.showMessage(
          'Form is not valid!  Please review and correct.',
          _scaffoldKey,
          NotificationTone.NEGATIVE);
    } else {
      form.save(); //This invokes each onSaved event
      _serviceBloc.dispatch(AddServiceEvent(_serviceModel));
      print('Form save called,  Contact is now up to date...');
      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');
    }
  }
}
