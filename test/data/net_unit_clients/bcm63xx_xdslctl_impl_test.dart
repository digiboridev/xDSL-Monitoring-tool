// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/bcm63xx_xdslctl_impl.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import 'package:path/path.dart' as p;
import '../../telnet_emulator/telnet_emulator.dart';

void main() {
  test('bcm63xx xdslctl impl parsing', () async {
    final closeEmu = await startEmulator(
      login: 'qwe',
      password: 'asd',
      command2Stats: (
        cmd: 'xdslctl info --show',
        file: File(
          p.join(Directory.current.path, 'test', 'telnet_emulator', 'stats_examples', 'bcmstats_vdsl.txt'),
        ),
      ),
    );

    final NetUnitClient client = BCM63xdslctlClientImpl(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      login: 'qwe',
      password: 'asd',
    );

    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionUp);
    expect(stats.connectionType, 'VDSL2 Annex B');
    expect(stats.upAttainableRate, 5654);
    expect(stats.downAttainableRate, 32148);
    expect(stats.upRate, 5795);
    expect(stats.downRate, 29624);
    expect(stats.upMargin, 57);
    expect(stats.downMargin, 41);
    expect(stats.upAttenuation, 32);
    expect(stats.downAttenuation, 51);
    expect(stats.upCRC, 1);
    expect(stats.downCRC, 140410);
    expect(stats.upFEC, 273);
    expect(stats.downFEC, 4855931);
    expect(stats.upCRCIncr, 0);
    expect(stats.downCRCIncr, 0);
    expect(stats.upFECIncr, 0);
    expect(stats.downFECIncr, 0);

    print(stats);
    await closeEmu();
  });

  test('bcm63xx xdslctl impl parsing 2', () async {
    final closeEmu = await startEmulator(
      login: 'qwe',
      password: 'asd',
      command2Stats: (
        cmd: 'xdslctl info --show',
        file: File(
          p.join(Directory.current.path, 'test', 'telnet_emulator', 'stats_examples', 'bcmstats_vdsl2.txt'),
        ),
      ),
    );

    final NetUnitClient client = BCM63xdslctlClientImpl(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      login: 'qwe',
      password: 'asd',
    );

    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionUp);
    expect(stats.connectionType, 'VDSL2 Annex B');
    expect(stats.upAttainableRate, 21366);
    expect(stats.downAttainableRate, 54572);
    expect(stats.upRate, 20000);
    expect(stats.downRate, 58121);
    expect(stats.upMargin, 65);
    expect(stats.downMargin, 55);
    expect(stats.upAttenuation, 0);
    expect(stats.downAttenuation, 182);
    expect(stats.upCRC, 0);
    expect(stats.downCRC, 0);
    expect(stats.upFEC, 0);
    expect(stats.downFEC, 50716);
    expect(stats.upCRCIncr, 0);
    expect(stats.downCRCIncr, 0);
    expect(stats.upFECIncr, 0);
    expect(stats.downFECIncr, 0);

    print(stats);
    await closeEmu();
  });

  test('bcm63xx xdslctl impl parsing 3', () async {
    final closeEmu = await startEmulator(
      login: 'qwe',
      password: 'asd',
      command2Stats: (
        cmd: 'xdslctl info --show',
        file: File(
          p.join(Directory.current.path, 'test', 'telnet_emulator', 'stats_examples', 'bcmstats_vdsl3.txt'),
        ),
      ),
    );

    final NetUnitClient client = BCM63xdslctlClientImpl(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      login: 'qwe',
      password: 'asd',
    );

    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionUp);
    expect(stats.connectionType, 'VDSL2 Annex B');
    expect(stats.upAttainableRate, 30956);
    expect(stats.downAttainableRate, 95624);
    expect(stats.upRate, 20000);
    expect(stats.downRate, 63404);
    expect(stats.upMargin, 129);
    expect(stats.downMargin, 106);
    expect(stats.upAttenuation, 0);
    expect(stats.downAttenuation, 128);
    expect(stats.upCRC, 0);
    expect(stats.downCRC, 4096);
    expect(stats.upFEC, 1);
    expect(stats.downFEC, 316177384);
    expect(stats.upCRCIncr, 0);
    expect(stats.downCRCIncr, 0);
    expect(stats.upFECIncr, 0);
    expect(stats.downFECIncr, 0);

    print(stats);
    await closeEmu();
  });
}
