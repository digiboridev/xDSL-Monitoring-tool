import 'package:dslstats/models/DataSamplingService.dart';
import 'package:dslstats/models/misc/ModemTypes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModemSelection extends StatefulWidget {
  const ModemSelection({Key key}) : super(key: key);

  @override
  _ModemSelectionState createState() => _ModemSelectionState();
}

class _ModemSelectionState extends State<ModemSelection> {
  String dropdownValue = 'HG532e';
  var asd;
  _showDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Select model type'),
            children: [
              SimpleDialogOption(
                child: Text('Client_simulation'),
                onPressed: () {
                  context.read<DataSamplingService>().setModemtype =
                      ModemTypes.Client_simulation;
                  Navigator.pop(context, true);
                },
              ),
              SimpleDialogOption(
                child: Text('Huawei_HG532e'),
                onPressed: () {
                  context.read<DataSamplingService>().setModemtype =
                      ModemTypes.Huawei_HG532e;
                  Navigator.pop(context, true);
                },
              ),
              SimpleDialogOption(
                child: Text('TPLink_w8901_via_telnet'),
                onPressed: () {
                  context.read<DataSamplingService>().setModemtype =
                      ModemTypes.TPLink_w8901_via_telnet;
                  Navigator.pop(context, true);
                },
              ),
              SimpleDialogOption(
                child: Text('ZTE_H108n_v1_via_telnet'),
                onPressed: () {
                  context.read<DataSamplingService>().setModemtype =
                      ModemTypes.ZTE_H108n_v1_via_telnet;
                  Navigator.pop(context, true);
                },
              ),
              SimpleDialogOption(
                child: Text('Dlink_2640u_via_telnet'),
                onPressed: () {
                  context.read<DataSamplingService>().setModemtype =
                      ModemTypes.Dlink_2640u_via_telnet;
                  Navigator.pop(context, true);
                },
              ),
              SimpleDialogOption(
                child: Text('Tenda_d301_via_telnet'),
                onPressed: () {
                  context.read<DataSamplingService>().setModemtype =
                      ModemTypes.Tenda_d301_via_telnet;
                  Navigator.pop(context, true);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String modemName() {
      return context
          .watch<DataSamplingService>()
          .getModemType
          .toString()
          .split('.')
          .last;
    }

    return InkWell(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modem type',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.blueGrey[800]),
            ),
            Container(
              child: Text(modemName(),
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.blueGrey[600])),
            ),
          ],
        ),
      ),
      onTap: () => _showDialog(),
    );
  }
}
