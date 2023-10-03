import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/screens/settings/vm.dart';
import 'package:xdsl_mt/utils/formatters.dart';
import 'package:xdsl_mt/utils/validators.dart';
import 'package:xdsl_mt/widgets/text_styles.dart';

class NuIP extends StatelessWidget {
  const NuIP({super.key});

  SettingsScreenViewModel _getVm(BuildContext context) => context.read<SettingsScreenViewModel>();
  String _watchHost(BuildContext context) => context.select<SettingsScreenViewModel, String>((v) => v.host);
  String _getHost(BuildContext context) => context.read<SettingsScreenViewModel>().host;

  _showDialog(BuildContext context) async {
    String currentHost = _getHost(context);
    SettingsScreenViewModel vm = _getVm(context);

    String? newHost = await showDialog(context: context, builder: (_) => Dialog(hostAdress: currentHost));
    if (newHost != null) vm.setHost = newHost;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Network unit IP',
                style: TextStyles.f16w6.blueGrey800,
              ),
              Text(
                _watchHost(context),
                style: TextStyles.f12.blueGrey600,
              ),
            ],
          ),
        ),
        onTap: () => _showDialog(context),
      ),
    );
  }
}

class Dialog extends StatefulWidget {
  final String hostAdress;
  const Dialog({super.key, required this.hostAdress});

  @override
  State<Dialog> createState() => _DialogState();
}

class _DialogState extends State<Dialog> {
  late String hostAdress = widget.hostAdress;
  final formKey = GlobalKey<FormState>();
  bool get resultValid => formKey.currentState?.validate() ?? false;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AlertDialog(
        title: Text('Network unit IP form', style: TextStyles.f18w6.blueGrey800),
        content: Form(key: formKey, child: ipField()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, hostAdress),
            child: Text('Save', style: resultValid ? TextStyles.f16.blueGrey800 : TextStyles.f16.blueGrey400),
          ),
        ],
      ),
    );
  }

  TextFormField ipField() {
    return TextFormField(
      style: TextStyles.f16.blueGrey800,
      initialValue: hostAdress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (v) => setState(() => hostAdress = v),
      inputFormatters: [AppFormatters.ipFormatter],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        if (AppValidators.isValidIp(value) == false) {
          return 'Please enter a valid ip adress';
        }
        return null;
      },
    );
  }
}
