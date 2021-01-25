import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xDSL_Monitoring_tool/models/SettingsModel.dart';

class OrientToggler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Lock orientation',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Switch(
              value: context.watch<SettingsModel>().getOrient,
              onChanged: (b) => context.read<SettingsModel>().setOrient = b)
        ],
      ),
    );
  }
}
