import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/models/adsl_data_model.dart';
import 'package:xdsl_mt/models/modemClients/line_stats_collection.dart';
import '../components/snrm.dart';
import '../components/speed_line.dart';
import '../components/fec_line.dart';
import '../components/crc_line.dart';
import '../components/modem_latency.dart';
import '../components/external_latency.dart';
import 'currentScreen/status_bar.dart';
import 'currentScreen/current_speed_bar.dart';
import 'currentScreen/current_snr_bar.dart';
import 'currentScreen/rs_counters.dart';

class CurrentScreen extends StatelessWidget {
  //Name of screen
  // final String _name = 'Current stats monitoring';

  const CurrentScreen({super.key});

  //Returns name of screen
  // get name {
  //   return _name;
  // }

  @override
  Widget build(BuildContext context) {
    bool isMapEmpty = true;
    List<LineStatsCollection> collection = [];

    //Check collection for minimum two points in
    //Prevent red screen on mpcharts
    if (context.watch<ADSLDataModel>().collectionsCount == 0) {
      isMapEmpty = true;
    } else if (context.watch<ADSLDataModel>().getLastCollection.length < 2) {
      isMapEmpty = true;
    } else {
      isMapEmpty = false;
    }
    //Update collection
    if (!isMapEmpty) {
      collection = context.watch<ADSLDataModel>().getLastCollection;
    }

    debugPrint('render current screen');

    return Container(
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
      child: ListView(
        children: [
          StatusBar(),
          CurrentSpeedBar(),
          CurrentSNRBar(isMapEmpty),
          RsCounters(isMapEmpty),
          Column(
            children: [
              Container(
                margin: EdgeInsets.all(16),
                child: Text(
                  'Detailed histograms',
                  style: TextStyle(
                    color: Colors.blueGrey.shade900,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SpeedLineExpandable(
                isEmpty: isMapEmpty,
                collection: collection,
                showPeriod: Duration(minutes: 5),
              ),
              SNRMExpandable(
                isEmpty: isMapEmpty,
                collection: collection,
                showPeriod: Duration(minutes: 5),
              ),
              FECLineExpandable(
                isEmpty: isMapEmpty,
                collection: collection,
                showPeriod: Duration(minutes: 5),
              ),
              CRCLineExpandable(
                isEmpty: isMapEmpty,
                collection: collection,
                showPeriod: Duration(minutes: 5),
              ),
              ModemLatencyExpandable(
                isEmpty: isMapEmpty,
                collection: collection,
                showPeriod: Duration(minutes: 5),
              ),
              ExternalLatencyExpandable(
                isEmpty: isMapEmpty,
                collection: collection,
                showPeriod: Duration(minutes: 5),
              ),
            ],
          )
        ],
      ),
    );
  }
}
