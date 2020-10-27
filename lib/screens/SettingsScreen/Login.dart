import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/DataProvider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _dialogText = 'asd';

  _showDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Login input'),
              content: Container(
                  height: 40,
                  child: TextField(
                    onChanged: (v) => setState(() {
                      _dialogText = v;
                    }),
                  )),
              actions: [
                FlatButton(
                    onPressed: () {
                      context.read<DataProvider>().setLogin = _dialogText;
                      Navigator.pop(context, true);
                    },
                    child: Text('Save')),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text('Decline'))
              ]);
        });
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
              "Login",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.blueGrey[800]),
            ),
            Text(context.watch<DataProvider>().getLogin,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.blueGrey[600])),
          ],
        ),
      ),
      onTap: () {
        _showDialog();
      },
    );
  }
}
