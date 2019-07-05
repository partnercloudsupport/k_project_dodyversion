import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:k_project_dodyversion/blocs/user_bloc/user_bloc.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:k_project_dodyversion/utils/utils.dart';

final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

enum PastExperienceType { PastExperience, Almamater }

class PastExperienceAlertDialog extends StatefulWidget {
  PastExperienceAlertDialog(this._userBloc, this.type, this.um, {Key key})
      : super(key: key);

  final UserModel um;
  final PastExperienceType type;

  final UserBloc _userBloc;
  _PastExperienceAlertDialogState createState() =>
      _PastExperienceAlertDialogState();
}

class _PastExperienceAlertDialogState extends State<PastExperienceAlertDialog> {
  List<String> data = new List<String>(3);

  @override
  Widget build(BuildContext context) {
    data[0] = (data[0] == null) ? "asd" : data[0];
    return BlocListener(
      bloc: widget._userBloc,
      listener: (BuildContext context, UserState state) {
        if (state is UpdateProfilePictureSuccessful) {
          setState(() {
            data[0] = state.cloudPath;
          });
        } else if (state is UpdateUserSuccess) {
          Navigator.pop(context);
          return;
        }
      },
      child: Container(
        child: AlertDialog(
          title: Text('Create'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                          image: data[0],
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
                  TextFormField(
                    initialValue: "",
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    keyboardType: TextInputType.url,
                    inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (val) => (val == null || val == "")
                        ? "Name cannot be empty"
                        : null,
                    onSaved: (val) => data[1] = val,
                  ),
                  TextFormField(
                    initialValue: "",
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    keyboardType: TextInputType.url,
                    inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (val) => (val == null || val == "")
                        ? "Description cannot be empty"
                        : null,
                    onSaved: (val) => data[2] = val,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Add'),
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
    } else {
      form.save(); //This invokes each onSaved event

      if (widget.type == PastExperienceType.PastExperience) {
        List<String> temp = List.of(
            widget.um.pastExperiences
                .getRange(0, 3 * (widget.um.pastExperiences.length ~/ 3))
                .cast<String>(),
            growable: true);
        temp.addAll(data.getRange(0, 3).cast<String>());
        widget.um.pastExperiences = temp;
        widget._userBloc.dispatch(UpdateUserEvent(widget.um));
      } else if (widget.type == PastExperienceType.Almamater) {
        List<String> temp = List.of(
            widget.um.almamaters
                .getRange(0, 3 * (widget.um.almamaters.length ~/ 3))
                .cast<String>(),
            growable: true);
        temp.addAll(data.getRange(0, 3).cast<String>());
        widget.um.almamaters = temp;
        widget._userBloc.dispatch(UpdateUserEvent(widget.um));
      }
    }
  }

  Future getImage() async {
    File tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    print(tempImage.toString());
    widget._userBloc.dispatch(new UpdatePastExperiencePictureEvent(tempImage));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
