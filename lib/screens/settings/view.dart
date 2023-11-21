// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:xdslmt/screens/settings/components/about.dart';
import 'package:xdslmt/screens/settings/components/animation_switch.dart';
import 'package:xdslmt/screens/settings/components/foreground_switch.dart';
import 'package:xdslmt/screens/settings/components/recent_size.dart';
import 'package:xdslmt/screens/settings/components/split_interval.dart';
import 'package:xdslmt/screens/settings/components/nu_host.dart';
import 'package:xdslmt/screens/settings/components/nu_login.dart';
import 'package:xdslmt/screens/settings/components/nu_type.dart';
import 'package:xdslmt/screens/settings/components/orient_lock_switch.dart';
import 'package:xdslmt/screens/settings/components/nu_password.dart';
import 'package:xdslmt/screens/settings/components/sampling_interval.dart';
import 'package:xdslmt/core/colors.dart';
import 'package:xdslmt/screens/settings/components/wakelock_switch.dart';
import 'package:xdslmt/utils/fillable_scrollable_wrapper.dart';
import 'package:xdslmt/utils/min_spacer.dart';

class SettingsScreenView extends StatelessWidget {
  const SettingsScreenView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.cyan100,
              AppColors.cyan50,
              AppColors.cyan100,
            ],
          ),
        ),
        child: const FillableScrollableWrapper(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NuType(),
                NuHost(),
                NuLogin(),
                NuPassword(),
                SizedBox(height: 4),
                Divider(),
                SizedBox(height: 4),
                SamplingInterval(),
                SplitInterval(),
                RecentSize(),
                SizedBox(height: 4),
                Divider(),
                SizedBox(height: 4),
                AnimationSwitch(),
                OrientLockSwitch(),
                WakelockSwitch(),
                ForegroundSwitch(),
                SizedBox(height: 4),
                Divider(),
                SizedBox(height: 4),
                About(),
                MinSpacer(minHeight: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
