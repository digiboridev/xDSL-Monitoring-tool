import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersion extends StatelessWidget {
  final TextStyle textStyle;

  const AppVersion({
    super.key,
    this.textStyle = const TextStyle(),
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            (snapshot.data as PackageInfo).version,
            style: textStyle,
          );
        }
        return const SizedBox();
      },
    );
  }
}
