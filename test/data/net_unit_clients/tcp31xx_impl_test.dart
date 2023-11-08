// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import 'package:xdslmt/data/net_unit_clients/tcp31xx_impl.dart';
import 'package:path/path.dart' as p;
import '../../telnet_emulator/telnet_emulator.dart';

void main() {
  test('tcp31xx impl diag parsing', () async {
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
    expect(stats.connectionType, 'ADSL2+ Mode');
    expect(stats.upAttainableRate, 831);
    expect(stats.downAttainableRate, 13764);
    expect(stats.upRate, 831);
    expect(stats.downRate, 11000);
    expect(stats.upMargin, 80);
    expect(stats.downMargin, 120);
    expect(stats.upAttenuation, 240);
    expect(stats.downAttenuation, 390);
    expect(stats.upCRC, 0);
    expect(stats.downCRC, 10);
    expect(stats.upFEC, 0);
    expect(stats.downFEC, 819);
    expect(stats.upCRCIncr, 0);
    expect(stats.downCRCIncr, 0);
    expect(stats.upFECIncr, 0);
    expect(stats.downFECIncr, 0);
    print(stats);
    await closeEmu();
  });

  test('tcp31xx impl alt diag parsing', () async {
    final closeEmu = await startEmulator(
      login: 'qwe',
      password: 'asd',
      shellSkip: true,
      command2Stats: (
        cmd: 'wan adsl diag\nwan adsl status',
        file: File(
          p.join(Directory.current.path, 'test', 'telnet_emulator', 'stats_examples', 'trendchip_diag_alt.txt'),
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
    expect(stats.connectionType, 'ITU G.992.1(G.DMT)');
    expect(stats.upAttainableRate, 831);
    expect(stats.downAttainableRate, 13764);
    expect(stats.upRate, 448);
    expect(stats.downRate, 4032);
    expect(stats.upMargin, 80);
    expect(stats.downMargin, 120);
    expect(stats.upAttenuation, 240);
    expect(stats.downAttenuation, 390);
    expect(stats.upCRC, 0);
    expect(stats.downCRC, 10);
    expect(stats.upFEC, 0);
    expect(stats.downFEC, 819);
    expect(stats.upCRCIncr, 0);
    expect(stats.downCRCIncr, 0);
    expect(stats.upFECIncr, 0);
    expect(stats.downFECIncr, 0);
    print(stats);
    await closeEmu();
  });
}
