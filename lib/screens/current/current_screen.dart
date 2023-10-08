import 'package:flutter/material.dart';
import 'package:xdslmt/screens/current/components/summary.dart';
import 'package:xdslmt/widgets/text_styles.dart';
import 'components/status_bar.dart';
import 'components/current_speed_bar.dart';
import 'components/current_snr_bar.dart';
import 'components/rs_counters.dart';

class CurrentScreen extends StatelessWidget {
  const CurrentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [Colors.cyan.shade100, Colors.white, Colors.cyan.shade100],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            StatusBar(),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: 16),
                    Text('Current / Attainable speed rates', style: TextStyles.f16w6.blueGrey900),
                    SizedBox(height: 16),
                    CurrentSpeedBar(),
                    SizedBox(height: 16),
                    Text('SNR Margin / Attenuation', style: TextStyles.f16w6.blueGrey900),
                    SizedBox(height: 16),
                    CurrentSNRBar(),
                    SizedBox(height: 16),
                    Text('Error correction', style: TextStyles.f16w6.blueGrey900),
                    SizedBox(height: 16),
                    RsCounters(),
                    SizedBox(height: 16),
                    Text('Summary stats', style: TextStyles.f16w6.blueGrey900),
                    SizedBox(height: 16),
                    Summary(),
                    SizedBox(height: 64),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
