import 'package:xdslmt/data/net_unit_clients/components/common_telnet_client.dart';
import 'package:xdslmt/data/net_unit_clients/components/stats_parser/trendchip_stats_parser.dart';

class TCP31xxClientImpl extends CommonTelnetClient {
  TCP31xxClientImpl({
    required super.unitIp,
    required super.snapshotId,
    required String login,
    required String password,
  }) : super(
          prepPrts: [
            (prompt: 'Login:', command: login),
            (prompt: 'Password:', command: password),
          ],
          errorPrts: const [
            'Bad Password!!!',
            'Login incorrect',
            'Login failed',
          ],
          readyPrt: '>',
          cmd2Stats: (command: 'wan adsl diag\nwan adsl status\n', tryParse: trendchipParser),
        );
}
