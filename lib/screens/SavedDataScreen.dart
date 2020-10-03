import 'package:flutter/material.dart';

class SavedDataScreen extends StatelessWidget {
  String _name = 'Collected data';
  get name {
    return _name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('second'),
      ),
    );
  }
}
