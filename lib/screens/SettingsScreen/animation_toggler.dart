import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/models/settings_model.dart';

class AnimationToggler extends StatelessWidget {
  const AnimationToggler({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Animations',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Switch(
            value: context.watch<SettingsModel>().getAnimated,
            onChanged: (b) => context.read<SettingsModel>().setAnimated = b,
          )
        ],
      ),
    );
  }
}
