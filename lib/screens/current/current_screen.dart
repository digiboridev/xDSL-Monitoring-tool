import 'package:flutter/material.dart';
import 'package:xdsl_mt/widgets/fillable_scrollable_wrapper.dart';
import 'package:xdsl_mt/widgets/min_spacer.dart';
import 'package:xdsl_mt/widgets/text_styles.dart';
import 'components/status_bar.dart';
import 'components/current_speed_bar.dart';
import 'components/current_snr_bar.dart';
import 'components/rs_counters.dart';

class CurrentScreen extends StatelessWidget {
  const CurrentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [Colors.cyan.shade100, Colors.white, Colors.cyan.shade100],
        ),
      ),
      child: Column(
        children: [
          StatusBar(),
          Expanded(
            child: FillableScrollableWrapper(
              child: Column(
                children: [
                  MinSpacer(minHeight: 16),
                  Text('Current / Attainable speed rates', style: TextStyles.f16w6.blueGrey900),
                  MinSpacer(minHeight: 16),
                  CurrentSpeedBar(),
                  MinSpacer(minHeight: 16),
                  Text('SNR Margin / Attenuation', style: TextStyles.f16w6.blueGrey900),
                  MinSpacer(minHeight: 16),
                  CurrentSNRBar(),
                  MinSpacer(minHeight: 16),
                  Text('Error correction', style: TextStyles.f16w6.blueGrey900),
                  MinSpacer(minHeight: 16),
                  RsCounters(),
                  MinSpacer(minHeight: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
