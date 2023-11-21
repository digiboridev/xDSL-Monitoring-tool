import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xdslmt/core/text_styles.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        child: Text('About', style: TextStyles.f16w6.blueGrey900),
        onTap: () => showDialog(context: context, builder: (_) => const AppAboutDialog()),
      ),
    );
  }
}

class AppAboutDialog extends StatefulWidget {
  const AppAboutDialog({super.key});

  @override
  State<AppAboutDialog> createState() => _AppAboutDialogState();
}

class _AppAboutDialogState extends State<AppAboutDialog> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AboutDialog(
              applicationName: 'xDSL MT',
              applicationVersion: (snapshot.data as PackageInfo).version,
              applicationIcon: Image.asset(
                'assets/app_icon/app_icon_512.png',
                width: width / 4,
                height: width / 4,
              ),
              applicationLegalese: '© 2019 - ${DateTime.now().year}\nVladislav Komelkov',
              children: [
                const SizedBox(height: 8),
                Text(
                  'This app is open source and licensed under the MIT license.',
                  style: TextStyles.f12.blueGrey600,
                ),
                Text.rich(
                  TextSpan(
                    text: 'Source code and detailed documentation can be found on ',
                    children: [
                      TextSpan(
                        text: 'GitHub',
                        recognizer: TapGestureRecognizer()..onTap = () => launchUrl(Uri.parse('https://github.com/digiboridev/xDSL-Monitoring-tool')),
                        style: TextStyles.f12.cyan400.copyWith(decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                  style: TextStyles.f12.blueGrey600,
                ),
                Text.rich(
                  TextSpan(
                    text: 'If you have any questions or suggestions, please contact me via ',
                    children: [
                      TextSpan(
                        text: 'Email',
                        recognizer: TapGestureRecognizer()..onTap = () => launchUrl(Uri.parse('mailto:digiborideveloper@gmail.com?subject=xdslmt')),
                        style: TextStyles.f12.cyan400.copyWith(decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                  style: TextStyles.f12.blueGrey600,
                ),
                Text(
                  'If you have network equipment (G.DMT/ADSL/VDSL only) that is not supported by this app or behave wrong, send me a dump of the terminal session as example.',
                  style: TextStyles.f12.blueGrey600,
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
