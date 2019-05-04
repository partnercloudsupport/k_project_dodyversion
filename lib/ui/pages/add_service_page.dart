import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_project_dodyversion/blocs/bloc.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:k_project_dodyversion/utils/notification_utils.dart';

/// This page is for the user to add services they offer.

final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class AddServicePage extends StatefulWidget {
  AddServicePage({Key key}) : super(key: key);

  AddServicePageState createState() => AddServicePageState();
}

class AddServicePageState extends State<AddServicePage> {
  ServiceModel _serviceModel;

  @override
  void initState() {
    super.initState();
    _serviceModel = new ServiceModel(null);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<ServiceBloc>(context),
      listener: (BuildContext context, ServiceState state) {
        if (state is AddServiceSuccessful) {
           BlocProvider.of<ServiceBloc>(context).dispatch(ResetServiceEvent());
          Navigator.pop(context, true);
        } else if (state is AddingNewServiceState) {
          NotificationUtils.showMessage(
              "Profile is updating!", _scaffoldKey, NotificationTone.POSITIVE);
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
            child: new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                new TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Enter your service name',
                    labelText: 'Service name',
                  ),
                  keyboardType: TextInputType.url,
                  inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (val) => (val == null || val == "")
                      ? "Name cannot be empty"
                      : null,
                  onSaved: (val) => {_serviceModel.serviceName = val},
                ),
                new TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.language),
                    hintText: 'The duration of the service in minutes',
                    labelText: 'Duration',
                    suffixText: "mins",
                  ),
                  inputFormatters: [new LengthLimitingTextInputFormatter(100)],
                  keyboardType: TextInputType.number,
                  validator: (val) => (val == null || val == "")
                      ? "Duration cannot be empty!"
                      : null,
                  onSaved: (duration) {
                    _serviceModel.serviceDuration = int.parse(duration);
                  },
                ),
                new TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.language),
                    hintText: 'Price for the whole duration',
                    labelText: 'Price',
                    suffixText: "SGD",
                  ),
                  inputFormatters: [new LengthLimitingTextInputFormatter(100)],
                  keyboardType: TextInputType.number,
                  validator: (val) => (val == null || val == "")
                      ? "Price cannot be empty!"
                      : null,
                  onSaved: (price) {
                    _serviceModel.price = double.parse(price);
                  },
                ),
                new TextFormField(
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText:
                        'The description of the service. Convince your customers to user your service.',
                    labelText: 'Description',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLength: 200,
                  inputFormatters: [new LengthLimitingTextInputFormatter(200)],
                  onSaved: (desc) {
                    _serviceModel.description = desc;
                  },
                ),
                BlocBuilder(
                  bloc: BlocProvider.of<UserBloc>(context),
                  builder: (BuildContext context, UserState state) {
                    return new Container(
                      padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                      child: new RaisedButton(
                          child: const Text('Submit'),
                          onPressed: () {
                            _submitForm();
                          }),
                    );
                  },
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
      BlocProvider.of<ServiceBloc>(context)
          .dispatch(AddServiceEvent(_serviceModel));
      print('Form save called, newContact is now up to date...');
      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');
    }
  }
}
