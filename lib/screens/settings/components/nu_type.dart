import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/data/models/network_unit_type.dart';
import 'package:xdsl_mt/screens/settings/vm.dart';
import 'package:xdsl_mt/widgets/text_styles.dart';

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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Network unit type', style: TextStyles.f16w6.blueGrey800),
              Text(_watchType(context).name, style: TextStyles.f12.blueGrey600),
            ],
          ),
        ),
        onTap: () => _showDialog(context),
      ),
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
