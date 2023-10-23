import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';
import 'package:xdslmt/utils/formatters.dart';
import 'package:xdslmt/widgets/text_styles.dart';

class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {
    SnapshotStats? stats = context.watch<StatsSamplingService>().snapshotStats;
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Start time:', style: TextStyles.f14w3, overflow: TextOverflow.ellipsis),
              Text('Last sample time:', style: TextStyles.f14w3, overflow: TextOverflow.ellipsis),
              Text('Sampling duration:', style: TextStyles.f14w3, overflow: TextOverflow.ellipsis),
              Text('Total uplink:', style: TextStyles.f14w3, overflow: TextOverflow.ellipsis),
              Text('Uplink drops:', style: TextStyles.f14w3, overflow: TextOverflow.ellipsis),
              Text('Samples total:', style: TextStyles.f14w3, overflow: TextOverflow.ellipsis),
              Text('Sampling errors:', style: TextStyles.f14w3, overflow: TextOverflow.ellipsis),
            ],
          ),
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(stats?.startTime.ymdhms ?? 'N/A', style: TextStyles.f14, overflow: TextOverflow.ellipsis),
                Text(stats?.lastSampleTime?.ymdhms ?? 'N/A', style: TextStyles.f14, overflow: TextOverflow.ellipsis),
                Text(stats?.samplingDuration.hms ?? 'N/A', style: TextStyles.f14, overflow: TextOverflow.ellipsis),
                Text(stats?.uplinkDuration.hms ?? 'N/A', style: TextStyles.f14, overflow: TextOverflow.ellipsis),
                Text(stats?.disconnects.toString() ?? 'N/A', style: TextStyles.f14, overflow: TextOverflow.ellipsis),
                Text(stats?.samples.toString() ?? 'N/A', style: TextStyles.f14, overflow: TextOverflow.ellipsis),
                Text(stats?.samplingErrors.toString() ?? 'N/A', style: TextStyles.f14, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
