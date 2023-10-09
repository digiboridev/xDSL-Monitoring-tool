import 'package:flutter/material.dart';
import 'package:xdslmt/screens/current/components/summary.dart';
import 'package:xdslmt/widgets/text_styles.dart';
import 'components/status_bar.dart';
import 'components/bandwidth_bar.dart';
import 'components/snr_bar.dart';
import 'components/rsc_bar.dart';

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
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.transparent, Colors.transparent, Colors.white],
                    stops: [0.0, 0.025, 0.950, 1.0],
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Text('Current / Attainable bandwidth', style: TextStyles.f16w6.blueGrey900, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    const BandwidthBar(),
                    const SizedBox(height: 16),
                    Text('SNR Margin / Attenuation', style: TextStyles.f16w6.blueGrey900, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    const SNRBar(),
                    const SizedBox(height: 16),
                    Text('Error correction', style: TextStyles.f16w6.blueGrey900, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    const RSCBar(),
                    const SizedBox(height: 16),
                    Text('Summary stats', style: TextStyles.f16w6.blueGrey900, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    const Summary(),
                    const SizedBox(height: 64),
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
