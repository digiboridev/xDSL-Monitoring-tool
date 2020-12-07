import 'package:dslstats/models/DataSamplingService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExternalAdress extends StatefulWidget {
  @override
  _ExternalAdressState createState() => _ExternalAdressState();
}

class _ExternalAdressState extends State<ExternalAdress> {
  String _dialogText = 'asd';

  _showDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('External adress input'),
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
                      context.read<DataSamplingService>().setExternalAdress =
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
              "External adress for ping",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.blueGrey[800]),
            ),
            Text(context.watch<DataSamplingService>().getExternalAdress,
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
