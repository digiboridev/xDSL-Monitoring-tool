import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/screens/settings/vm.dart';
import 'package:xdslmt/widgets/text_styles.dart';

class NuLogin extends StatelessWidget {
  const NuLogin({super.key});

  SettingsScreenViewModel _getVm(BuildContext context) => context.read<SettingsScreenViewModel>();
  String _watchLogin(BuildContext context) => context.select<SettingsScreenViewModel, String>((v) => v.login);
  String _getLogin(BuildContext context) => context.read<SettingsScreenViewModel>().login;

  _showDialog(BuildContext context) async {
    String currentLogin = _getLogin(context);
    SettingsScreenViewModel vm = _getVm(context);

    String? newLogin = await showDialog(context: context, builder: (_) => Dialog(login: currentLogin));
    if (newLogin != null) vm.setLogin = newLogin;
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
              Text('Network unit login', style: TextStyles.f16w6.blueGrey900),
              Text(_watchLogin(context), style: TextStyles.f12.blueGrey600),
            ],
          ),
        ),
        onTap: () => _showDialog(context),
      ),
    );
  }
}

class Dialog extends StatefulWidget {
  final String login;
  const Dialog({super.key, required this.login});

  @override
  State<Dialog> createState() => _DialogState();
}

class _DialogState extends State<Dialog> {
  late String login = widget.login;
  final formKey = GlobalKey<FormState>();
  bool get resultValid => formKey.currentState?.validate() ?? false;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AlertDialog(
        title: Text('Network unit login', style: TextStyles.f18w6.blueGrey800),
        content: Form(key: formKey, child: ipField()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, login),
            child: Text('Save', style: resultValid ? TextStyles.f16.blueGrey800 : TextStyles.f16.blueGrey400),
          ),
        ],
      ),
    );
  }

  TextFormField ipField() {
    return TextFormField(
      style: TextStyles.f16.blueGrey800,
      initialValue: login,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (v) => setState(() => login = v),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }

        return null;
      },
    );
  }
}
