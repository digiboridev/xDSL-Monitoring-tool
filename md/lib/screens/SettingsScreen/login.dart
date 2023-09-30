import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/models/data_sampling_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _dialogText = 'asd';

  _showDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login input'),
          content: SizedBox(
            height: 40,
            child: TextField(
              onChanged: (v) => setState(() {
                _dialogText = v;
              }),
            ),
          ),
          actions: [
            // FlatButton(
            //     onPressed: () {
            //       context.read<DataSamplingService>().setLogin = _dialogText;
            //       Navigator.pop(context, true);
            //     },
            //     child: Text('Save')),
            // FlatButton(
            //     onPressed: () {
            //       Navigator.pop(context, true);
            //     },
            //     child: Text('Decline'))
            TextButton(
              onPressed: () {
                context.read<DataSamplingService>().setLogin = _dialogText;
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
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.blueGrey.shade800,
              ),
            ),
            Text(
              context.watch<DataSamplingService>().getLogin,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colors.blueGrey.shade600,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        _showDialog();
      },
    );
  }
}
