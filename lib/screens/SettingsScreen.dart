import 'package:dslstats/screens/SettingsScreen/Password.dart';
import 'package:flutter/material.dart';
import 'SettingsScreen/ModemSelection.dart';
import 'SettingsScreen/HostAdress.dart';
import 'SettingsScreen/Login.dart';
import 'SettingsScreen/SamplingInterval.dart';
import 'SettingsScreen/CollecDatatInterval.dart';

class SettingsScreen extends StatefulWidget {
  String _name = 'Settings';
  get name {
    return _name;
  }

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String dropdownValue = 'HG532e';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: ListView(
        children: [
          ModemSelection(),
          HostAdress(),
          Login(),
          Password(),
          SamplingInterval(),
          CollectDataInterval()
        ],
      ),
    );
  }
}
