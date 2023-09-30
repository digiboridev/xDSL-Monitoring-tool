import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/models/data_sampling_service.dart';

class Password extends StatefulWidget {
  const Password({super.key});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  String _dialogText = 'asd';

  _showDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Password input'),
              content: SizedBox(
                height: 40,
                child: TextField(
                  onChanged: (v) => setState(() {
                    _dialogText = v;
                  }),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    context.read<DataSamplingService>().setPassword = _dialogText;
                    Navigator.pop(context, true);
                  },
                  child: const Text('Save'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Decline'),
                ),

                // FlatButton(
                //     onPressed: () {
                //       context.read<DataSamplingService>().setPassword = _dialogText;
                //       Navigator.pop(context, true);
                //     },
                //     child: const Text('Save')),
                // FlatButton(
                //     onPressed: () {
                //       Navigator.pop(context, true);
                //     },
                //     child: const Text('Decline'))
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Password",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.blueGrey.shade800),
            ),
            Text(context.watch<DataSamplingService>().getPassword,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.blueGrey.shade600)),
          ],
        ),
      ),
      onTap: () {
        _showDialog();
      },
    );
  }
}
