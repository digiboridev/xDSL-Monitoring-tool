// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import 'package:xdslmt/data/net_unit_clients/components/common_telnet_client.dart';
import 'package:xdslmt/data/net_unit_clients/components/stats_parser/bcm_stats_parser.dart';
import 'package:xdslmt/data/net_unit_clients/components/stats_parser/trendchip_stats_parser.dart';
import 'package:path/path.dart' as p;
import '../../telnet_emulator/telnet_emulator.dart';

Future<void> main() async {
  test('login error', () async {
    final closeEmu = await startEmulator(
      command2Stats: (
        cmd: 'adsl info --show',
        file: File(
          p.join(Directory.current.path, 'test', 'telnet_emulator', 'stats_examples', 'bcmstats_adsl.txt'),
        ),
      ),
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'wronglogin'),
        (prompt: 'Password:', command: 'admin'),
        (prompt: '>', command: 'sh'),
      ],
      errorPrts: const [
        'Bad Password!!!',
        'Login incorrect',
        'Login failed',
      ],
      readyPrt: '#',
      cmd2Stats: (command: 'adsl info --show', tryParse: bcm63xxParser),
    );

    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.samplingError);
    expect(stats.statusText, 'Login incorrect');
    print('Status:${stats.statusText}');
    print('Status:${stats.status}');
    await closeEmu();
  });

  test('password error', () async {
    final closeEmu = await startEmulator(
      command2Stats: (
        cmd: 'adsl info --show',
        file: File(
          p.join(Directory.current.path, 'test', 'telnet_emulator', 'stats_examples', 'bcmstats_adsl.txt'),
        ),
      ),
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'wrongpassword'),
        (prompt: '>', command: 'sh'),
      ],
      errorPrts: const [
        'Bad Password!!!',
        'Login incorrect',
        'Login failed',
      ],
      readyPrt: '#',
      cmd2Stats: (command: 'adsl info --show', tryParse: bcm63xxParser),
    );
    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.samplingError);
    expect(stats.statusText, 'Bad Password!!!');
    print('Status:${stats.statusText}');
    await closeEmu();
  });

  test('wrong stats prompt > timeout', () async {
    final closeEmu = await startEmulator(
      command2Stats: (
        cmd: 'adsl info --show',
        file: File(
          p.join(Directory.current.path, 'test', 'telnet_emulator', 'stats_examples', 'bcmstats_adsl.txt'),
        ),
      ),
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
        (prompt: '>', command: 'sh'),
      ],
      errorPrts: const [
        'Bad Password!!!',
        'Login incorrect',
        'Login failed',
      ],
      readyPrt: '#',
      cmd2Stats: (command: 'wrong cmd', tryParse: bcm63xxParser),
    );
    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.samplingError);
    expect(stats.statusText, 'Get stats timeout');
    print('Status:${stats.statusText}');
    await closeEmu();
  });

  test('broadcom parser', () async {
    final closeEmu = await startEmulator(
      command2Stats: (
        cmd: 'adsl info --show',
        file: File(
          p.join(Directory.current.path, 'test', 'telnet_emulator', 'stats_examples', 'bcmstats_adsl.txt'),
        ),
      ),
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
        (prompt: '>', command: 'sh'),
      ],
      errorPrts: const [
        'Bad Password!!!',
        'Login incorrect',
        'Login failed',
      ],
      readyPrt: '#',
      cmd2Stats: (command: 'adsl info --show', tryParse: bcm63xxParser),
    );
    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionUp);
    print(stats);
    await closeEmu();
  });

  test('trendchip parser', () async {
    final closeEmu = await startEmulator(
      command2Stats: (
        cmd: 'wan adsl diag',
        file: File(
          p.join(Directory.current.path, 'test', 'telnet_emulator', 'stats_examples', 'trendchip_diag.txt'),
        ),
      ),
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
      ],
      errorPrts: const [
        'Bad Password!!!',
        'Login incorrect',
        'Login failed',
      ],
      readyPrt: '>',
      cmd2Stats: (command: 'wan adsl diag', tryParse: trendchipParser),
    );
    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionUp);
    print(stats);
    await closeEmu();
  });
}
