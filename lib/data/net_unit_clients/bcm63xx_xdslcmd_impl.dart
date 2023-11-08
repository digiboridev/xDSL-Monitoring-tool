import 'package:xdslmt/data/net_unit_clients/components/common_telnet_client.dart';
import 'package:xdslmt/data/net_unit_clients/components/stats_parser/bcm_stats_parser.dart';

class BCM63xdslcmdClientImpl extends CommonTelnetClient {
  BCM63xdslcmdClientImpl({
    required super.unitIp,
    required super.snapshotId,
    required String login,
    required String password,
  }) : super(
          prepPrts: [
            (prompt: 'Login:', command: login),
            (prompt: 'Password:', command: password),
            (prompt: '>', command: 'sh'),
          ],
          errorPrts: const [
            'Bad Password!!!',
            'Login incorrect',
            'Login failed',
          ],
          readyPrt: '#',
          cmd2Stats: (command: 'xdslcmd info --show', tryParse: bcm63xxParser),
        );
}
