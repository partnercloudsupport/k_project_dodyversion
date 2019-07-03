import 'package:flutter/material.dart';

class PastExperienceCard extends StatefulWidget {
  PastExperienceCard({Key key, List<String> data})
      : assert(data.length == 3),
        super(key: key);

  _PastExperienceCardState createState() => _PastExperienceCardState();
}

class _PastExperienceCardState extends State<PastExperienceCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: new Container(
        child: Column(
          children: <Widget>[
            Text("data"),
            Text("data"),
            Text("data"),
          ],
        ),
      ),
    );
  }
}
