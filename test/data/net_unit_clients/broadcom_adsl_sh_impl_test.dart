// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/broadcom_adsl_sh_impl.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import '../../telnet_emulator/telnet_emulator.dart';

void main() {
  test('broadcom adsl sh impl  > success flow', () async {
    final closeEmu = await startEmulator(
      shellSkip: false,
      command2Stats: (
        cmd: 'adsl info --show',
        file: File('test/telnet_emulator/stats_examples/bcmstats_adsl.txt'),
      ),
    );

    final NetUnitClient client = BroadcomAdslShClientImpl(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      login: 'admin',
      password: 'admin',
    );

    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionUp);
    print(stats);
    await closeEmu();
  });
}
