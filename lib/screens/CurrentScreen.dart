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
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              FlatButton(
                  onPressed: context.watch<DataProvider>().createCollection,
                  child: Text('Create collectiion')),
              FlatButton(
                  onPressed: context.watch<DataProvider>().updateCollections,
                  child: Text('update')),
              FlatButton(
                  onPressed: context.watch<DataProvider>().printCollections,
                  child: Text('print'))
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                    onPressed: context.watch<DataProvider>().startCounter,
                    child: Text('start counter')),
                FlatButton(
                    onPressed: context.watch<DataProvider>().stopCounter,
                    child: Text('stop counter'))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                    onPressed: context.watch<DataProvider>().startWakelock,
                    child: Text('start wakelock')),
                FlatButton(
                    onPressed: context.watch<DataProvider>().stopWakelock,
                    child: Text('stop wakelock'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
