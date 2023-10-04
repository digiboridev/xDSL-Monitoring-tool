import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/screens/settings/vm.dart';
import 'package:xdsl_mt/utils/formatters.dart';
import 'package:xdsl_mt/utils/validators.dart';
import 'package:xdsl_mt/widgets/text_styles.dart';

class ExternalHost extends StatelessWidget {
  const ExternalHost({super.key});

  SettingsScreenViewModel _getVm(BuildContext context) => context.read<SettingsScreenViewModel>();
  String _watchExternalHost(BuildContext context) => context.select<SettingsScreenViewModel, String>((v) => v.externalHost);
  String _getExternalHost(BuildContext context) => context.read<SettingsScreenViewModel>().externalHost;

  _showDialog(BuildContext context) async {
    String currentExternalHost = _getExternalHost(context);
    SettingsScreenViewModel vm = _getVm(context);

    String? newExternalHost = await showDialog(context: context, builder: (_) => Dialog(extHostAdress: currentExternalHost));
    if (newExternalHost != null) vm.setExternalHost = newExternalHost;
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
                'External host',
                style: TextStyles.f16w6.blueGrey800,
              ),
              Text(
                _watchExternalHost(context),
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
  final String extHostAdress;
  const Dialog({super.key, required this.extHostAdress});

  @override
  State<Dialog> createState() => _DialogState();
}

class _DialogState extends State<Dialog> {
  late String extHostAdress = widget.extHostAdress;
  final formKey = GlobalKey<FormState>();
  bool get resultValid => formKey.currentState?.validate() ?? false;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AlertDialog(
        title: Text('External host form', style: TextStyles.f18w6.blueGrey800),
        content: Form(key: formKey, child: hostField()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, extHostAdress),
            child: Text('Save', style: resultValid ? TextStyles.f16.blueGrey800 : TextStyles.f16.blueGrey400),
          ),
        ],
      ),
    );
  }

  TextFormField hostField() {
    return TextFormField(
      style: TextStyles.f16.blueGrey800,
      initialValue: extHostAdress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (v) => setState(() => extHostAdress = v),
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
