import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/DataProvider.dart';

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
                child: Text('Huawei_HG532e'),
                onPressed: () {
                  context.read<DataProvider>().setModemtype =
                      ModemTypes.Huawei_HG532e;
                  Navigator.pop(context, true);
                },
              ),
              SimpleDialogOption(
                child: Text('Dlink_2640u'),
                onPressed: () {
                  context.read<DataProvider>().setModemtype =
                      ModemTypes.Dlink_2640u;
                  Navigator.pop(context, true);
                },
              ),
              SimpleDialogOption(
                child: Text('ZTE_h108n'),
                onPressed: () {
                  context.read<DataProvider>().setModemtype =
                      ModemTypes.ZTE_h108n;
                  Navigator.pop(context, true);
                },
              ),
              SimpleDialogOption(
                child: Text('Tebda_D301'),
                onPressed: () {
                  context.read<DataProvider>().setModemtype =
                      ModemTypes.Tebda_D301;
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
      switch (context.watch<DataProvider>().getModemType) {
        case ModemTypes.Dlink_2640u:
          return 'Dlink_2640u';
          break;
        case ModemTypes.Huawei_HG532e:
          return 'Huawei_HG532e';
          break;
        case ModemTypes.Tebda_D301:
          return 'Tebda_D301';
          break;
        case ModemTypes.ZTE_h108n:
          return 'ZTE_h108n';
          break;
        default:
      }
      return 'asdasd';
    }

    return InkWell(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modem type',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Container(
              child: Text(modemName()),
            ),
          ],
        ),
      ),
      onTap: () => _showDialog(),
    );
  }
}
