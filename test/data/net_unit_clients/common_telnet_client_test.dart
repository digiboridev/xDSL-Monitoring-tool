// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import 'package:xdslmt/data/net_unit_clients/common_telnet_client.dart';
import 'package:xdslmt/data/net_unit_clients/stats_parser/bcm_stats_parser.dart';

import '../../telnet_emulator/telnet_emulator.dart';

Future<void> main() async {
  await startEmulator();

  test('login error', () {
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
    final f = client.fetchStats();
    expect(f, completes);
    f.then((stats) => expect(stats.status, SampleStatus.samplingError));
    f.then((stats) => expect(stats.statusText, 'Login incorrect'));
    f.then((value) => print('Status:${value.statusText}'));
  });

  test('password error', () {
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
    final f = client.fetchStats();
    expect(f, completes);
    f.then((stats) => expect(stats.status, SampleStatus.samplingError));
    f.then((stats) => expect(stats.statusText, 'Bad Password!!!'));
    f.then((value) => print('Status:${value.statusText}'));
  });

  test('login success and wrong stats prompt', () {
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
    final f = client.fetchStats();
    expect(f, completes);
    f.then((stats) => expect(stats.status, SampleStatus.samplingError));
    f.then((stats) => expect(stats.statusText, 'Get stats timeout'));
    f.then((value) => print('Status:${value.statusText}'));
  });

  test('login success and parsed for bcm63xx', () {
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
    final f = client.fetchStats();
    expect(f, completes);
    f.then((stats) => expect(stats.status, SampleStatus.connectionUp));
    f.then((value) => print('Status:${value.statusText}'));
  });
}
