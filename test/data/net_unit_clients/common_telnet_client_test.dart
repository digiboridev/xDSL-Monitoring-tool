import 'package:flutter_test/flutter_test.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import 'package:xdslmt/data/net_unit_clients/common_telnet_client.dart';

import '../../telnet_emulator/telnet_emulator.dart';

Future<void> main() async {
  await startEmulator();

  test('login error', () {
    final NetUnitClient client = CommonTelnetClient(
      ip: '0.0.0.0',
      login: 'wronglogin',
      password: 'wrongpassword',
      snapshotId: 'test',
    );
    final f = client.fetchStats();
    expect(f, completes);
    f.then((stats) => expect(stats.status, SampleStatus.samplingError));
  });

  test('login success and unimplemented', () {
    final NetUnitClient client = CommonTelnetClient(
      ip: '0.0.0.0',
      login: 'loginau',
      password: 'passwordook',
      snapshotId: 'test',
    );
    final f = client.fetchStats();
    expect(f, throwsUnimplementedError);
  });
}
