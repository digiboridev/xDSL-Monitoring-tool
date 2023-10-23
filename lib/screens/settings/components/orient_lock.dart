import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/screens/settings/vm.dart';
import 'package:xdslmt/widgets/text_styles.dart';

class OrientLock extends StatelessWidget {
  const OrientLock({super.key});

  SettingsScreenViewModel _getVm(BuildContext context) => context.read<SettingsScreenViewModel>();
  bool watchOrientLock(BuildContext context) => context.select<SettingsScreenViewModel, bool>((v) => v.orientLock);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Lock orientation', style: TextStyles.f16w6.blueGrey900),
          const SizedBox(width: 8),
          SizedBox(
            height: 28,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Switch(
                value: watchOrientLock(context),
                onChanged: (v) => _getVm(context).setOrientLock = v,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
