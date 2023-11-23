import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/core/colors.dart';
import 'package:xdslmt/screens/settings/vm.dart';
import 'package:xdslmt/core/text_styles.dart';

class OrientLockSwitch extends StatelessWidget {
  const OrientLockSwitch({super.key});

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
          const Spacer(),
          const Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            decoration: BoxDecoration(color: AppColors.blueGrey800, borderRadius: BorderRadius.all(Radius.circular(4))),
            padding: EdgeInsets.all(8),
            showDuration: Duration(seconds: 6),
            message: 'Locks screen orientation to portrait mode.',
            child: Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
    );
  }
}
