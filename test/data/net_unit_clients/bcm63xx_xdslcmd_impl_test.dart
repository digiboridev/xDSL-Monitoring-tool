import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/bcm63xx_xdslcmd_impl.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import 'package:path/path.dart' as p;
import '../../telnet_emulator/telnet_emulator.dart';

void main() {
  test('bcm63xx impl parsing', () async {
    final closeEmu = await startEmulator(
      login: 'qwe',
      password: 'asd',
      command2Stats: (
        cmd: 'xdslcmd info --show',
        file: File(
          p.join(Directory.current.path, 'test', 'telnet_emulator', 'stats_examples', 'bcmstats_vdsl.txt'),
        ),
      ),
    );

    final NetUnitClient client = BCM63xdslcmdClientImpl(
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
}
