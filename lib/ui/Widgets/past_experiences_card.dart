import 'package:flutter/material.dart';
import 'package:k_project_dodyversion/utils/utils.dart';

class PastExperienceCard extends StatefulWidget {
  PastExperienceCard({Key key, this.data, this.onTap, this.index})
      : assert(data.length == 3),
        super(key: key);

  final List<String> data;
  final GestureTapCallback onTap;
  final int index;

  _PastExperienceCardState createState() => _PastExperienceCardState();
}

class _PastExperienceCardState extends State<PastExperienceCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: new Container(
        constraints: BoxConstraints(
          maxWidth: 100,
        ),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                width: 75,
                height: 75,
                image: widget.data[0],
                placeholder: Constant.ASSET_USERPROFILE_PLACEHOLDER_PATH,
              ),
            ),
            Text(
              widget.data[1],
              textAlign: TextAlign.center,
            ),
            Text(
              widget.data[2],
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
