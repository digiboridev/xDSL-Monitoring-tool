import 'package:flutter/material.dart';
import 'package:xdsl_mt/screens/SettingsScreen/external_adress.dart';
import 'package:xdsl_mt/screens/SettingsScreen/password.dart';
import 'SettingsScreen/modemSelection.dart';
import 'SettingsScreen/host_address.dart';
import 'SettingsScreen/login.dart';
import 'SettingsScreen/sampling_interval.dart';
import 'SettingsScreen/collect_data_interval.dart';
import 'SettingsScreen/animation_toggler.dart';
import 'SettingsScreen/orient_toggler.dart';

class SettingsScreen extends StatefulWidget {
  final String _name = 'Settings';

  const SettingsScreen({super.key});

  get name {
    return _name;
  }

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String dropdownValue = 'HG532e';

  @override
  Widget build(BuildContext context) {
    debugPrint('Render settings screen');
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            Colors.cyan.shade50,
            Colors.white,
            Colors.white,
          ],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          ModemSelection(),
          HostAdress(),
          Login(),
          Password(),
          SamplingInterval(),
          CollectDataInterval(),
          ExternalAdress(),
          const AnimationToggler(),
          OrientToggler()
        ],
      ),
    );
  }
}
