// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import 'package:xdslmt/data/net_unit_clients/tcp31xx_impl.dart';
import 'package:path/path.dart' as p;
import '../../telnet_emulator/telnet_emulator.dart';

void main() {
  test('tcp31xx impl success flow', () async {
    final closeEmu = await startEmulator(
      login: 'qwe',
      password: 'asd',
      shellSkip: true,
      command2Stats: (
        cmd: 'wan adsl diag\nwan adsl status',
        file: File(
          p.join(Directory.current.path, 'test', 'telnet_emulator', 'stats_examples', 'trendchip_diag.txt'),
        ),
      ),
    );

    final NetUnitClient client = TCP31xxClientImpl(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      login: 'qwe',
      password: 'asd',
    );

    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionUp);
    print(stats);
    await closeEmu();
  });
}
