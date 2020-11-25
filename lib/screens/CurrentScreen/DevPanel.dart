import 'package:flutter/material.dart';
import '../../models/DataProvider.dart';
import '../../models/TsModel.dart';
import '../../models/TsModel2.dart';
import 'package:provider/provider.dart';

class DevPanel extends StatelessWidget {
  const DevPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('test render');
    return Container(
      color: Colors.blueGrey,
      child: Column(
        children: [
          Text('sdsdfsdf'),
          Test1(),
          Test2(),
          FloatingActionButton(
            onPressed: () {
              context.read<TsModel>().increaseCounter();
            },
            child: Text('increase'),
          ),
          FloatingActionButton(
            onPressed: () {
              context.read<TsModel2>().increaseCounter();
            },
            child: Text('increase'),
          )
        ],
      ),
    );
  }
}

class Test1 extends StatelessWidget {
  const Test1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('test1 render');
    return Container(
      child: Text(context.watch<TsModel>().tsCounter.toString()),
    );
  }
}

class Test2 extends StatelessWidget {
  const Test2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('test2 render');
    return Container(
      child: Text(context.watch<TsModel2>().tsCounter.toString()),
    );
  }
}
