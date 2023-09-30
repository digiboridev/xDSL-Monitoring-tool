import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/models/settings_model.dart';

class OrientToggler extends StatelessWidget {
  const OrientToggler({super.key});

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
            onChanged: (b) => context.read<SettingsModel>().setOrient = b,
          ),
        ],
      ),
    );
  }
}
