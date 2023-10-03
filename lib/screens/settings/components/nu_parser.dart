import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/data/model/nu_parsers.dart';
import 'package:xdsl_mt/screens/settings/vm.dart';
import 'package:xdsl_mt/widgets/text_styles.dart';

class NuParser extends StatelessWidget {
  const NuParser({super.key});

  SettingsScreenViewModel _getVm(BuildContext context) => context.read<SettingsScreenViewModel>();
  NUParsers _watchParser(BuildContext context) => context.select<SettingsScreenViewModel, NUParsers>((v) => v.nuParser);
  NUParsers _getParser(BuildContext context) => context.read<SettingsScreenViewModel>().nuParser;

  _showDialog(BuildContext context) async {
    NUParsers currentParser = _getParser(context);
    SettingsScreenViewModel vm = _getVm(context);

    NUParsers? newParser = await showDialog(context: context, builder: (_) => Dialog(currentParser: currentParser));
    if (newParser != null) vm.setNuParser = newParser;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        child: Tooltip(
          message: 'Type of network unit parser, used to parse data from network unit',
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Network unit parser', style: TextStyles.f16w6.blueGrey800),
                Text(_watchParser(context).name, style: TextStyles.f12.blueGrey600),
              ],
            ),
          ),
        ),
        onTap: () => _showDialog(context),
      ),
    );
  }
}

class Dialog extends StatelessWidget {
  final NUParsers currentParser;
  const Dialog({super.key, required this.currentParser});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: SimpleDialog(
        title: Text('Select network unit parser', style: TextStyles.f18w6.blueGrey800),
        children: NUParsers.values.map((p) {
          return SimpleDialogOption(
            child: Text(p.toString().split('.').last, style: currentParser == p ? TextStyles.f16w6.blueGrey800 : TextStyles.f16.blueGrey400),
            onPressed: () => Navigator.pop(context, p),
          );
        }).toList(),
      ),
    );
  }
}
