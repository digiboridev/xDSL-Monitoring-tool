// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/bcm63xx_impl.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import 'package:path/path.dart' as p;
import '../../telnet_emulator/telnet_emulator.dart';

void main() {
  test('bcm63xx impl parsing', () async {
    final closeEmu = await startEmulator(
      login: 'qwe',
      password: 'asd',
      command2Stats: (
        cmd: 'adsl info --show',
        file: File(
          p.join(Directory.current.path, 'test', 'telnet_emulator', 'stats_examples', 'bcmstats.txt'),
        ),
      ),
    );

    final NetUnitClient client = BCM63xxClientImpl(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      login: 'qwe',
      password: 'asd',
    );

    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionUp);
    expect(stats.connectionType, 'ADSL2+ Annex A');
    expect(stats.upAttainableRate, 2123);
    expect(stats.downAttainableRate, 18123);
    expect(stats.upRate, 1123);
    expect(stats.downRate, 15123);
    expect(stats.upMargin, 152);
    expect(stats.downMargin, 107);
    expect(stats.upAttenuation, 20);
    expect(stats.downAttenuation, 117);
    expect(stats.upCRC, 9);
    expect(stats.downCRC, 9);
    expect(stats.upFEC, 574);
    expect(stats.downFEC, 77);
    expect(stats.upCRCIncr, 0);
    expect(stats.downCRCIncr, 0);
    expect(stats.upFECIncr, 0);
    expect(stats.downFECIncr, 0);

    print(stats);
    await closeEmu();
  });
}
