import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:k_project_dodyversion/blocs/bloc.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:k_project_dodyversion/resources/repository.dart';
import 'package:k_project_dodyversion/utils/notification_utils.dart';
import 'package:k_project_dodyversion/utils/time_utils.dart';
import 'package:k_project_dodyversion/utils/utils.dart';

final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class EditUserProfilePage extends StatefulWidget {
  UserBloc userBloc;
  EditUserProfilePage(this.userBloc, {Key key}) : super(key: key);

  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  final TextEditingController _controller = new TextEditingController();
  UserModel _userModel;

  var _userBloc;
  @override
  void initState() {
    super.initState();
    _userBloc = widget.userBloc;
    _userModel = UserRepository.mUser;
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

  Future getImage() async {
    File tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (tempImage == null) {
      NotificationUtils.showMessage(
          "Uploading image cancelled", _scaffoldKey, NotificationTone.NEGATIVE);
      return;
    }
    print(tempImage.toString());
    _userBloc.dispatch(new UpdateProfilePictureEvent(tempImage));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _userBloc,
      listener: (BuildContext context, UserState state) {
        if (state is UpdateUserSuccess) {
          Navigator.pop(context, true);
        } else if (state is UpdatingUser) {
          NotificationUtils.showMessage(
              "Profile is updating!", _scaffoldKey, NotificationTone.POSITIVE);
        } else if (state is UpdatingProfilePicture) {
          NotificationUtils.showMessage("Uploading new image", _scaffoldKey);
        } else if (state is UpdateProfilePictureSuccessful) {
          setState(() {
             _userModel.profilePictureURL = state.cloudPath;
          });
          NotificationUtils.showMessage(
              "Profile picture updated", _scaffoldKey);
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
                Row(
                  children: <Widget>[
                    Container(
                      child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                        image: _userModel.profilePictureURL,
                        placeholder:
                            Constant.ASSET_USERPROFILE_PLACEHOLDER_PATH,
                      ),
                    ),
                    RaisedButton(
                      child: Text("Upload Image"),
                      onPressed: getImage,
                    )
                  ],
                ),
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
                  bloc: _userBloc,
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
      _userBloc.dispatch(UpdateUserEvent(_userModel));
    }
  }
}
