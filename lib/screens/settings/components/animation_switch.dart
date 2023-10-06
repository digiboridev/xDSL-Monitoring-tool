import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/screens/settings/vm.dart';
import 'package:xdsl_mt/widgets/text_styles.dart';

class AnimationSwitch extends StatelessWidget {
  const AnimationSwitch({super.key});

  SettingsScreenViewModel _getVm(BuildContext context) => context.read<SettingsScreenViewModel>();
  bool watchAnimations(BuildContext context) => context.select<SettingsScreenViewModel, bool>((v) => v.animations);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: Row(
        children: [
          Text('Animations', style: TextStyles.f16w6.blueGrey800),
          SizedBox(width: 8),
          SizedBox(
            height: 28,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Switch(
                value: watchAnimations(context),
                onChanged: (v) => _getVm(context).setAnimations = v,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
