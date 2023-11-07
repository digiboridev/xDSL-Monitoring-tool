import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/core/colors.dart';
import 'package:xdslmt/data/models/network_unit_type.dart';
import 'package:xdslmt/screens/settings/vm.dart';
import 'package:xdslmt/core/text_styles.dart';

class NuType extends StatelessWidget {
  const NuType({super.key});

  SettingsScreenViewModel _getVm(BuildContext context) => context.read<SettingsScreenViewModel>();
  NetworkUnitType _watchType(BuildContext context) => context.select<SettingsScreenViewModel, NetworkUnitType>((v) => v.nuType);
  NetworkUnitType _getType(BuildContext context) => context.read<SettingsScreenViewModel>().nuType;

  _showDialog(BuildContext context) async {
    NetworkUnitType currentType = _getType(context);
    SettingsScreenViewModel vm = _getVm(context);

    NetworkUnitType? newType = await showDialog(context: context, builder: (_) => Dialog(currentType: currentType));
    if (newType != null) vm.setNuType = newType;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Network unit type', style: TextStyles.f16w6.blueGrey900),
                    Text(_watchType(context).name, style: TextStyles.f12.blueGrey600),
                  ],
                ),
              ),
              onTap: () => _showDialog(context),
            ),
          ),
        ),
        const Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          decoration: BoxDecoration(color: AppColors.blueGrey800, borderRadius: BorderRadius.all(Radius.circular(4))),
          padding: EdgeInsets.all(8),
          showDuration: Duration(seconds: 6),
          message: 'Select the type of your network unit. This will change the way data is parsed and interpreted.',
          child: Icon(Icons.info_outline_rounded),
        ),
      ],
    );
  }
}

class Dialog extends StatelessWidget {
  final NetworkUnitType currentType;
  const Dialog({super.key, required this.currentType});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: SimpleDialog(
        title: Text('Select network unit type', style: TextStyles.f18w6.blueGrey800),
        children: NetworkUnitType.values.map((p) {
          return SimpleDialogOption(
            child: Text(p.toString().split('.').last, style: currentType == p ? TextStyles.f16w6.blueGrey800 : TextStyles.f16.blueGrey400),
            onPressed: () => Navigator.pop(context, p),
          );
        }).toList(),
      ),
    );
  }
}
