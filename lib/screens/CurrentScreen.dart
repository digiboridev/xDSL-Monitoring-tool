import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dslstats/models/DataProvider.dart';

class CurrentScreen extends StatelessWidget {
  String _name = 'Current stats';
  get name {
    return _name;
  }

  @override
  Widget build(BuildContext context) {
    print('render current screen');
    return ListView(
      children: [Text('asd')],
    );
  }
}
