// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import 'package:xdslmt/data/net_unit_clients/trendchip_perfomance_impl.dart';
import '../../telnet_emulator/telnet_emulator.dart';

void main() {
  test('trendchip perfomance impl > success flow', () async {
    final closeEmu = await startEmulator(
      login: 'qwe',
      password: 'asd',
      shellSkip: true,
      cmdResponses: [
        (
          cmd: 'wan adsl status',
          response: File('test/telnet_emulator/stats_examples/trendchip_status_up.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan adsl opmode',
          response: File('test/telnet_emulator/stats_examples/trendchip_opmode.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan adsl chandata',
          response: File('test/telnet_emulator/stats_examples/trendchip_chandata.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan adsl perfdata',
          response: File('test/telnet_emulator/stats_examples/trendchip_perfdata.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan adsl linedata near',
          response: File('test/telnet_emulator/stats_examples/trendchip_linedata_near.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan adsl linedata far',
          response: File('test/telnet_emulator/stats_examples/trendchip_linedata_far.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan dmt2 show cparams',
          response: File('test/telnet_emulator/stats_examples/trendchip_cparams.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan dmt2 show rparams',
          response: File('test/telnet_emulator/stats_examples/trendchip_rparams.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = TrendchipPerfomanceClientImpl(
      unitIp: '0.0.0.0',
      login: 'qwe',
      password: 'asd',
    );

    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionUp);
    print(stats);
    await closeEmu();
  });
}
