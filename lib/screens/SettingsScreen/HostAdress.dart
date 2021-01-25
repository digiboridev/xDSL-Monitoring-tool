import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xDSL_Monitoring_tool/models/DataSamplingService.dart';

class HostAdress extends StatefulWidget {
  @override
  _HostAdressState createState() => _HostAdressState();
}

class _HostAdressState extends State<HostAdress> {
  String _dialogText = 'asd';

  _showDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Host adress input'),
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
                      context.read<DataSamplingService>().setHostAdress =
                          _dialogText;
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
              "Host adress",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.blueGrey[800]),
            ),
            Text(context.watch<DataSamplingService>().getHostAdress,
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
