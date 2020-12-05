import 'package:dslstats/models/SettingsModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimationToggler extends StatelessWidget {
  const AnimationToggler({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'On/Off animation',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Switch(
              value: context.watch<SettingsModel>().getAnimated,
              onChanged: (b) => context.read<SettingsModel>().setAnimated = b)
        ],
      ),
    );
  }
}
