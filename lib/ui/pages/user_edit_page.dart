import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_project_dodyversion/blocs/bloc.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:k_project_dodyversion/resources/user_repo/user_provider.dart';
import 'package:k_project_dodyversion/utils/notification_utils.dart';
import 'package:k_project_dodyversion/utils/time_utils.dart';

final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class EditUserProfilePage extends StatefulWidget {
  EditUserProfilePage({Key key}) : super(key: key);

  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  final TextEditingController _controller = new TextEditingController();
  UserModel _userModel;

  @override
  void initState() {
    super.initState();
    _userModel = UserProvider.mUser;
    _controller.text = TimeUtils.convertDateToString(
        TimeUtils.convertMillisToDate(_userModel.dateOfBirth));
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = TimeUtils.convertStringToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    setState(() {
      _controller.text = TimeUtils.convertDateToString(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<UserBloc>(context),
      listener: (BuildContext context, UserState state) {
        if (state is UpdateUserSuccess) {
          Navigator.pop(context, true);
        } else if (state is UpdatingUser) {
          NotificationUtils.showMessage(
              "Profile is updating!", _scaffoldKey, NotificationTone.POSITIVE);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Edit Profile"),
        ),
        body: Container(
          child: Form(
            key: _formKey,
            autovalidate: true,
            child: new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                new TextFormField(
                  initialValue: _userModel.name,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Enter your first and last name',
                    labelText: 'Name',
                  ),
                  keyboardType: TextInputType.url,
                  inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (val) => (val == null || val == "")
                      ? "Name cannot be empty"
                      : null,
                  onSaved: (val) => _userModel.name = val,
                ),
                new Row(children: <Widget>[
                  new Expanded(
                    child: new TextFormField(
                      decoration: new InputDecoration(
                        icon: const Icon(Icons.calendar_today),
                        hintText: 'Enter your date of birth',
                        labelText: 'Dob',
                      ),
                      controller: _controller,
                      keyboardType: TextInputType.datetime,
                      validator: (dob) =>
                          TimeUtils.isValidDob(dob) ? null : "Not a valid date",
                      onSaved: (dob) => {
                            _userModel.dateOfBirth = TimeUtils.convertToMillis(
                                TimeUtils.convertStringToDate(dob))
                          },
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(10)
                      ],
                    ),
                  ),
                  new IconButton(
                    icon: new Icon(Icons.add),
                    tooltip: 'Choose date',
                    onPressed: (() {
                      _chooseDate(context, _controller.text);
                    }),
                  )
                ]),
                new TextFormField(
                  initialValue: _userModel.languages,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.language),
                    hintText: 'Enter languages that you are fluent at.',
                    labelText: 'Languages',
                  ),
                  inputFormatters: [new LengthLimitingTextInputFormatter(100)],
                  keyboardType: TextInputType.text,
                  validator: (val) => (val == null || val == "")
                      ? "Languages cannot be empty"
                      : null,
                  onSaved: (lang) {
                    _userModel.languages = lang;
                  },
                ),
                new TextFormField(
                  initialValue: _userModel.description,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Write a short introduction!',
                    labelText: 'Bio',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLength: 200,
                  inputFormatters: [new LengthLimitingTextInputFormatter(200)],
                  onSaved: (desc) {
                    _userModel.description = desc;
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
      BlocProvider.of<UserBloc>(context)
          .dispatch(new UpdateUserEvent(_userModel));
      print('Form save called, newContact is now up to date...');
      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');
    }
  }
}
