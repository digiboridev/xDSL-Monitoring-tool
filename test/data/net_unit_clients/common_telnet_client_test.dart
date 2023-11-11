// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import 'package:xdslmt/data/net_unit_clients/components/common_telnet_client.dart';
import 'package:xdslmt/data/net_unit_clients/components/stats_parser/bcm_stats_parser.dart';
import 'package:xdslmt/data/net_unit_clients/components/stats_parser/trendchip_stats_parser.dart';
import '../../telnet_emulator/telnet_emulator.dart';

Future<void> main() async {
  test('wrong login > login error', () async {
    final closeEmu = await startEmulator(
      cmdResponses: [
        (
          cmd: 'adsl info --show',
          response: File('test/telnet_emulator/stats_examples/bcmstats_adsl.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'wronglogin'),
        (prompt: 'Password:', command: 'admin'),
        (prompt: '>', command: 'sh'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
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

  test('wrong password > password error', () async {
    final closeEmu = await startEmulator(
      cmdResponses: [
        (
          cmd: 'adsl info --show',
          response: File('test/telnet_emulator/stats_examples/bcmstats_adsl.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'wrongpassword'),
        (prompt: '>', command: 'sh'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '#',
      cmd2Stats: (command: 'adsl info --show', tryParse: bcm63xxParser),
    );
    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.samplingError);
    expect(stats.statusText, 'Bad Password!!!');
    print('Status:${stats.statusText}');
    await closeEmu();
  });

  test('incorrect shell command > timeout', () async {
    final closeEmu = await startEmulator(
      cmdResponses: [
        (
          cmd: 'adsl info --show',
          response: File('test/telnet_emulator/stats_examples/bcmstats_adsl.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
        (prompt: '>', command: 'incorrect command'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '#',
      cmd2Stats: (command: 'adsl info --show', tryParse: bcm63xxParser),
    );
    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.samplingError);
    expect(stats.statusText, 'Connect timeout');
    print('Status:${stats.statusText}');
    await closeEmu();
  });

  test('incorrect ready prompt > timeout', () async {
    final closeEmu = await startEmulator(
      cmdResponses: [
        (
          cmd: 'adsl info --show',
          response: File('test/telnet_emulator/stats_examples/bcmstats_adsl.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
        (prompt: '>', command: 'sh'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: 'incorrect prompt',
      cmd2Stats: (command: 'adsl info --show', tryParse: bcm63xxParser),
    );
    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.samplingError);
    expect(stats.statusText, 'Connect timeout');
    print('Status:${stats.statusText}');
    await closeEmu();
  });

  test('incorrect stats command > timeout', () async {
    final closeEmu = await startEmulator(
      cmdResponses: [
        (
          cmd: 'adsl info --show',
          response: File('test/telnet_emulator/stats_examples/bcmstats_adsl.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
        (prompt: '>', command: 'sh'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '#',
      cmd2Stats: (command: 'incorrect cmd', tryParse: bcm63xxParser),
    );
    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.samplingError);
    expect(stats.statusText, 'Get stats timeout');
    print('Status:${stats.statusText}');
    await closeEmu();
  });

  test('broadcom parser > connection training', () async {
    final closeEmu = await startEmulator(
      cmdResponses: [
        (
          cmd: 'adsl info --show',
          response: File('test/telnet_emulator/stats_examples/bcmstats_training.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
        (prompt: '>', command: 'sh'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '#',
      cmd2Stats: (command: 'adsl info --show', tryParse: bcm63xxParser),
    );
    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionDown);
    expect(stats.statusText, 'G.994 Training');
    print(stats);
    await closeEmu();
  });

  test('broadcom parser > connection training', () async {
    final closeEmu = await startEmulator(
      cmdResponses: [
        (
          cmd: 'adsl info --show',
          response: File('test/telnet_emulator/stats_examples/bcmstats_started.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
        (prompt: '>', command: 'sh'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '#',
      cmd2Stats: (command: 'adsl info --show', tryParse: bcm63xxParser),
    );
    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionDown);
    expect(stats.statusText, 'G.993 Started');
    print(stats);
    await closeEmu();
  });

  test('broadcom parser > correctness adsl', () async {
    final closeEmu = await startEmulator(
      cmdResponses: [
        (
          cmd: 'adsl info --show',
          response: File('test/telnet_emulator/stats_examples/bcmstats_adsl.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
        (prompt: '>', command: 'sh'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '#',
      cmd2Stats: (command: 'adsl info --show', tryParse: bcm63xxParser),
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

  test('broadcom parser > correctness adsl2', () async {
    final closeEmu = await startEmulator(
      cmdResponses: [
        (
          cmd: 'adsl info --show',
          response: File('test/telnet_emulator/stats_examples/bcmstats_adsl2.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
        (prompt: '>', command: 'sh'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '#',
      cmd2Stats: (command: 'adsl info --show', tryParse: bcm63xxParser),
    );
    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionUp);
    expect(stats.connectionType, 'ADSL2 Annex A');
    expect(stats.upAttainableRate, 570);
    expect(stats.downAttainableRate, 3056);
    expect(stats.upRate, 646);
    expect(stats.downRate, 2755);
    expect(stats.upMargin, 58);
    expect(stats.downMargin, 29);
    expect(stats.upAttenuation, 410);
    expect(stats.downAttenuation, 650);
    expect(stats.upCRC, 22);
    expect(stats.downCRC, 3);
    expect(stats.upFEC, 10092);
    expect(stats.downFEC, 7242);
    expect(stats.upCRCIncr, 0);
    expect(stats.downCRCIncr, 0);
    expect(stats.upFECIncr, 0);
    expect(stats.downFECIncr, 0);
    print(stats);
    await closeEmu();
  });

  test('broadcom parser > correctness vdsl', () async {
    final closeEmu = await startEmulator(
      cmdResponses: [
        (
          cmd: 'adsl info --show',
          response: File('test/telnet_emulator/stats_examples/bcmstats_vdsl.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
        (prompt: '>', command: 'sh'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '#',
      cmd2Stats: (command: 'adsl info --show', tryParse: bcm63xxParser),
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

  test('broadcom parser > correctness vdsl2', () async {
    final closeEmu = await startEmulator(
      cmdResponses: [
        (
          cmd: 'adsl info --show',
          response: File('test/telnet_emulator/stats_examples/bcmstats_vdsl2.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
        (prompt: '>', command: 'sh'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '#',
      cmd2Stats: (command: 'adsl info --show', tryParse: bcm63xxParser),
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

  test('broadcom parser > correctness vdsl3', () async {
    final closeEmu = await startEmulator(
      cmdResponses: [
        (
          cmd: 'adsl info --show',
          response: File('test/telnet_emulator/stats_examples/bcmstats_vdsl3.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
        (prompt: '>', command: 'sh'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '#',
      cmd2Stats: (command: 'adsl info --show', tryParse: bcm63xxParser),
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

  test('trendchip parser > connection down', () async {
    final closeEmu = await startEmulator(
      shellSkip: true,
      cmdResponses: [
        (
          cmd: 'wan adsl status',
          response: File('test/telnet_emulator/stats_examples/trendchip_status_down.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '>',
      cmd2Stats: (command: 'wan adsl status\nwan adsl diag', tryParse: trendchipParser),
    );

    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionDown);
    expect(stats.statusText, 'down');

    print(stats);
    await closeEmu();
  });

  test('trendchip parser > connection initializing', () async {
    final closeEmu = await startEmulator(
      shellSkip: true,
      cmdResponses: [
        (
          cmd: 'wan adsl status',
          response: File('test/telnet_emulator/stats_examples/trendchip_status_initializing.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '>',
      cmd2Stats: (command: 'wan adsl status\nwan adsl diag', tryParse: trendchipParser),
    );

    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionDown);
    expect(stats.statusText, 'initializing');
    print(stats);
    await closeEmu();
  });

  test('trendchip parser > correctness diag', () async {
    final closeEmu = await startEmulator(
      login: 'admin',
      password: 'admin',
      shellSkip: true,
      cmdResponses: [
        (
          cmd: 'wan adsl diag',
          response: File('test/telnet_emulator/stats_examples/trendchip_diag.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '>',
      cmd2Stats: (command: 'wan adsl diag', tryParse: trendchipParser),
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

  test('trendchip parser > correctness diag2', () async {
    final closeEmu = await startEmulator(
      login: 'admin',
      password: 'admin',
      shellSkip: true,
      cmdResponses: [
        (
          cmd: 'wan adsl diag',
          response: File('test/telnet_emulator/stats_examples/trendchip_diag2.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '>',
      cmd2Stats: (command: 'wan adsl diag', tryParse: trendchipParser),
    );

    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionUp);
    expect(stats.connectionType, 'ADSL2+ Mode');
    expect(stats.upAttainableRate, 2437);
    expect(stats.downAttainableRate, 16513);
    expect(stats.upRate, 700);
    expect(stats.downRate, 8192);
    expect(stats.upMargin, 310);
    expect(stats.downMargin, 210);
    expect(stats.upAttenuation, 120);
    expect(stats.downAttenuation, 240);
    expect(stats.upCRC, 0);
    expect(stats.downCRC, 0);
    expect(stats.upFEC, 0);
    expect(stats.downFEC, 87);
    expect(stats.upCRCIncr, 0);
    expect(stats.downCRCIncr, 0);
    expect(stats.upFECIncr, 0);
    expect(stats.downFECIncr, 0);
    print(stats);
    await closeEmu();
  });

  test('trendchip parser > correctness diag alt', () async {
    final closeEmu = await startEmulator(
      login: 'admin',
      password: 'admin',
      shellSkip: true,
      cmdResponses: [
        (
          cmd: 'wan adsl diag',
          response: File('test/telnet_emulator/stats_examples/trendchip_diag_alt.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '>',
      cmd2Stats: (command: 'wan adsl diag', tryParse: trendchipParser),
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

  test('trendchip parser > correctness multi-command', () async {
    final closeEmu = await startEmulator(
      login: 'admin',
      password: 'admin',
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

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '>',
      cmd2Stats: (
        command:
            'wan adsl status\nwan adsl opmode\nwan adsl chandata\nwan adsl perfdata\nwan adsl linedata near\nwan adsl linedata far\nwan dmt2 show cparams\nwan dmt2 show rparams\n',
        tryParse: trendchipParser
      ),
    );

    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionUp);
    expect(stats.connectionType, 'ADSL2+ Mode');
    expect(stats.upAttainableRate, 831);
    expect(stats.downAttainableRate, 13764);
    expect(stats.upRate, 448);
    expect(stats.downRate, 4032);
    expect(stats.upMargin, 80);
    expect(stats.downMargin, 120);
    expect(stats.upAttenuation, 240);
    expect(stats.downAttenuation, 390);
    expect(stats.upCRC, 23);
    expect(stats.downCRC, 120);
    expect(stats.upFEC, 12);
    expect(stats.downFEC, 8119);
    expect(stats.upCRCIncr, 0);
    expect(stats.downCRCIncr, 0);
    expect(stats.upFECIncr, 0);
    expect(stats.downFECIncr, 0);
    print(stats);
    await closeEmu();
  });

  test('trendchip parser > correctness multi-command 2', () async {
    final closeEmu = await startEmulator(
      login: 'admin',
      password: 'admin',
      shellSkip: true,
      cmdResponses: [
        (
          cmd: 'wan adsl status',
          response: File('test/telnet_emulator/stats_examples/trendchip_status_up.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan adsl opmode',
          response: File('test/telnet_emulator/stats_examples/trendchip_opmode2.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan adsl chandata',
          response: File('test/telnet_emulator/stats_examples/trendchip_chandata2.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan adsl perfdata',
          response: File('test/telnet_emulator/stats_examples/trendchip_perfdata2.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan adsl linedata near',
          response: File('test/telnet_emulator/stats_examples/trendchip_linedata_near2.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan adsl linedata far',
          response: File('test/telnet_emulator/stats_examples/trendchip_linedata_far2.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan dmt2 show cparams',
          response: File('test/telnet_emulator/stats_examples/trendchip_cparams2.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan dmt2 show rparams',
          response: File('test/telnet_emulator/stats_examples/trendchip_rparams2.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '>',
      cmd2Stats: (
        command:
            'wan adsl status\nwan adsl opmode\nwan adsl chandata\nwan adsl perfdata\nwan adsl linedata near\nwan adsl linedata far\nwan dmt2 show cparams\nwan dmt2 show rparams\n',
        tryParse: trendchipParser
      ),
    );

    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionUp);
    expect(stats.connectionType, 'ADSL2PLUS');
    expect(stats.upAttainableRate, 1107);
    expect(stats.downAttainableRate, 18488);
    expect(stats.upRate, 2323);
    expect(stats.downRate, 18123);
    expect(stats.upMargin, 310);
    expect(stats.downMargin, 210);
    expect(stats.upAttenuation, 120);
    expect(stats.downAttenuation, 240);
    expect(stats.upCRC, 4);
    expect(stats.downCRC, 94);
    expect(stats.upFEC, 5);
    expect(stats.downFEC, 52019);
    expect(stats.upCRCIncr, 0);
    expect(stats.downCRCIncr, 0);
    expect(stats.upFECIncr, 0);
    expect(stats.downFECIncr, 0);
    print(stats);
    await closeEmu();
  });

  test('trendchip parser > correctness multi-command alt', () async {
    final closeEmu = await startEmulator(
      login: 'admin',
      password: 'admin',
      shellSkip: true,
      cmdResponses: [
        (
          cmd: 'wan adsl status',
          response: File('test/telnet_emulator/stats_examples/trendchip_status_up.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan adsl opmode',
          response: File('test/telnet_emulator/stats_examples/trendchip_opmode_alt.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan adsl chandata',
          response: File('test/telnet_emulator/stats_examples/trendchip_chandata_alt.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan adsl perfdata',
          response: File('test/telnet_emulator/stats_examples/trendchip_perfdata_alt.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan adsl linedata near',
          response: File('test/telnet_emulator/stats_examples/trendchip_linedata_near2.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan adsl linedata far',
          response: File('test/telnet_emulator/stats_examples/trendchip_linedata_far2.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan dmt2 show cparams',
          response: File('test/telnet_emulator/stats_examples/trendchip_cparams2.txt').readAsStringSync(),
        ),
        (
          cmd: 'wan dmt2 show rparams',
          response: File('test/telnet_emulator/stats_examples/trendchip_rparams2.txt').readAsStringSync(),
        ),
      ],
    );

    final NetUnitClient client = CommonTelnetClient(
      unitIp: '0.0.0.0',
      snapshotId: 'test',
      prepPrts: [
        (prompt: 'Login:', command: 'admin'),
        (prompt: 'Password:', command: 'admin'),
      ],
      errorPrts: const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
      readyPrt: '>',
      cmd2Stats: (
        command:
            'wan adsl status\nwan adsl opmode\nwan adsl chandata\nwan adsl perfdata\nwan adsl linedata near\nwan adsl linedata far\nwan dmt2 show cparams\nwan dmt2 show rparams\n',
        tryParse: trendchipParser
      ),
    );

    final stats = await client.fetchStats();
    expect(stats.status, SampleStatus.connectionUp);
    expect(stats.connectionType, 'ITU G.992.1(G.DMT)');
    expect(stats.upAttainableRate, 1107);
    expect(stats.downAttainableRate, 18488);
    expect(stats.upRate, 831);
    expect(stats.downRate, 11000);
    expect(stats.upMargin, 310);
    expect(stats.downMargin, 210);
    expect(stats.upAttenuation, 120);
    expect(stats.downAttenuation, 240);
    expect(stats.upCRC, 4);
    expect(stats.downCRC, 94);
    expect(stats.upFEC, 5);
    expect(stats.downFEC, 52019);
    expect(stats.upCRCIncr, 0);
    expect(stats.downCRCIncr, 0);
    expect(stats.upFECIncr, 0);
    expect(stats.downFECIncr, 0);
    print(stats);
    await closeEmu();
  });
}
