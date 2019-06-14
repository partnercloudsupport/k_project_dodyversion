import 'package:flutter/material.dart';
import 'package:material_search/material_search.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

const _list = const [
  'Igor Minar',
  'Brad Green',
  'Dave Geddes',
  'Naomi Black',
  'Greg Weber',
  'Dean Sofer',
  'Wes Alvaro',
  'John Scott',
  'Daniel Nadasi',
];

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialSearch<String>(
        placeholder: "Search",
        results: _list
            .map((name) => new MaterialSearchResult<String>(
                  value: name, //The value must be of type <String>
                  text: name, //String that will be show in the list
                ))
            .toList(),
      ),
    );
  }
}
