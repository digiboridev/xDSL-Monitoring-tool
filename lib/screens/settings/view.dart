// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:xdslmt/screens/settings/components/animation_switch.dart';
import 'package:xdslmt/screens/settings/components/split_interval.dart';
import 'package:xdslmt/screens/settings/components/ext_host.dart';
import 'package:xdslmt/screens/settings/components/nu_host.dart';
import 'package:xdslmt/screens/settings/components/nu_login.dart';
import 'package:xdslmt/screens/settings/components/nu_type.dart';
import 'package:xdslmt/screens/settings/components/orient_lock.dart';
import 'package:xdslmt/screens/settings/components/nu_password.dart';
import 'package:xdslmt/screens/settings/components/sampling_interval.dart';
import 'package:xdslmt/widgets/app_colors.dart';
import 'package:xdslmt/widgets/fillable_scrollable_wrapper.dart';
import 'package:xdslmt/widgets/min_spacer.dart';
import 'package:xdslmt/widgets/text_styles.dart';
import 'package:xdslmt/widgets/version.dart';

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
              Colors.white,
              AppColors.cyan100,
            ],
          ),
        ),
        child: FillableScrollableWrapper(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const NuType(),
                const NuHost(),
                const NuLogin(),
                const NuPassword(),
                const ExternalHost(),
                const SamplingInterval(),
                const SplitInterval(),
                const AnimationSwitch(),
                const OrientLock(),
                const MinSpacer(minHeight: 50),
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
