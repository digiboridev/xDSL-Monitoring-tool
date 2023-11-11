import 'package:xdslmt/data/net_unit_clients/components/common_telnet_client.dart';
import 'package:xdslmt/data/net_unit_clients/components/stats_parser/trendchip_stats_parser.dart';

class TrendchipPerfomanceClientImpl extends CommonTelnetClient {
  TrendchipPerfomanceClientImpl({
    required super.unitIp,
    required super.snapshotId,
    required String login,
    required String password,
  }) : super(
          prepPrts: [
            (prompt: 'Login:', command: login),
            (prompt: 'Password:', command: password),
          ],
          errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
          readyPrt: '>',
          cmd2Stats: (
            command:
                'wan adsl status\nwan adsl opmode\nwan adsl chandata\nwan adsl perfdata\nwan adsl linedata near\nwan adsl linedata far\nwan dmt2 show cparams\nwan dmt2 show rparams\n',
            tryParse: trendchipParser
          ),
        );
}
