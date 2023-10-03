// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:xdsl_mt/screens/settings/components/animation_switch.dart';
import 'package:xdsl_mt/screens/settings/components/split_interval.dart';
import 'package:xdsl_mt/screens/settings/components/ext_ip.dart';
import 'package:xdsl_mt/screens/settings/components/nu_ip.dart';
import 'package:xdsl_mt/screens/settings/components/nu_login.dart';
import 'package:xdsl_mt/screens/settings/components/nu_parser.dart';
import 'package:xdsl_mt/screens/settings/components/orient_lock.dart';
import 'package:xdsl_mt/screens/settings/components/nu_password.dart';
import 'package:xdsl_mt/screens/settings/components/sampling_interval.dart';
import 'package:xdsl_mt/widgets/fillable_scrollable_wrapper.dart';
import 'package:xdsl_mt/widgets/min_spacer.dart';
import 'package:xdsl_mt/widgets/text_styles.dart';
import 'package:xdsl_mt/widgets/version.dart';

class SettingsScreenView extends StatelessWidget {
  const SettingsScreenView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Colors.cyan.shade100,
              Colors.white,
              Colors.cyan.shade100,
            ],
          ),
        ),
        child: FillableScrollableWrapper(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NuParser(),
                NuIP(),
                NuLogin(),
                NuPassword(),
                ExternalIp(),
                SamplingInterval(),
                SplitInterval(),
                AnimationSwitch(),
                OrientLock(),
                MinSpacer(minHeight: 50),
                version(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget version() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Build: ', style: TextStyles.f12.blueGrey600),
          AppVersion(textStyle: TextStyles.f12.blueGrey600),
        ],
      );
}
