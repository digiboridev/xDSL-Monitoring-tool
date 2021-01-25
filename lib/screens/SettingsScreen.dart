import 'package:flutter/material.dart';
import 'package:xDSL_Monitoring_tool/screens/SettingsScreen/Password.dart';
import 'SettingsScreen/ModemSelection.dart';
import 'SettingsScreen/HostAdress.dart';
import 'SettingsScreen/Login.dart';
import 'SettingsScreen/SamplingInterval.dart';
import 'SettingsScreen/CollecDatatInterval.dart';
import 'SettingsScreen/ExternalAdress.dart';
import 'SettingsScreen/AnimationToggler.dart';
import 'SettingsScreen/OrientToggler.dart';

//asdasd

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
    print('Render settings screen');
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [Colors.cyan[50], Colors.white, Colors.white])),
      padding: EdgeInsets.all(20),
      child: ListView(
        children: [
          ModemSelection(),
          HostAdress(),
          Login(),
          Password(),
          SamplingInterval(),
          CollectDataInterval(),
          ExternalAdress(),
          AnimationToggler(),
          OrientToggler()
        ],
      ),
    );
  }
}
