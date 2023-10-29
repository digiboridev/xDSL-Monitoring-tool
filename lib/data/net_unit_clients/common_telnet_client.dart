// ignore_for_file: unused_element, unused_field, avoid_print
import 'dart:async';
import 'dart:io';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';

class CommonTelnetClient extends NetUnitClient {
  CommonTelnetClient({
    required super.ip,
    required super.login,
    required super.password,
    required super.snapshotId,
    this.loginPrt = 'Login:',
    this.passwordPrt = 'Password:',
    this.shPrepPrt = '>',
    this.shPrepCmd = 'sh',
    this.shReadyPrt = '#',
    this.errorPrompts = const ['Bad Password!!!', 'Login incorrect', 'Login failed'],
  });

  /// Prompt that appears while unit waiting for login input
  /// Can be empty if no need to enter login (trendchip usually)
  String loginPrt;

  /// Prompt that appears while unit waiting for password input
  /// Can be empty if no need to enter password
  String passwordPrt;

  /// Prompt that appears after auth and uses to prepare shell for full access (if needed)
  /// Can be empty if no need to prepare shell
  String shPrepPrt;

  /// Command that uses to prepare shell for full access
  String shPrepCmd;

  /// Prompt that appears after shell prepared and ready for full access
  String shReadyPrt;

  /// Prompts for error recognition durning connect
  List<String> errorPrompts;

  Socket? _socket;
  Stream<String>? _socketStream;

  void _wipeSocket() {
    _socket?.destroy();
    _socket = null;
    _socketStream = null;
  }

  Future _connect() async {
    _wipeSocket();
    final completer = Completer();

    final socket = await Socket.connect(ip, 23);
    final socketStream = socket.map((event) => String.fromCharCodes(event).trim()).asBroadcastStream();
    socketStream.forEach((event) {
      print('Connect event: $event');

      /// Answer on prompts
      if (loginPrt.isNotEmpty && event.contains(loginPrt)) socket.writeln(login);
      if (passwordPrt.isNotEmpty && event.contains(passwordPrt)) socket.writeln(password);
      if (shPrepPrt.isNotEmpty && event.contains(shPrepPrt)) socket.writeln(shPrepCmd);

      // Complete with error on error prompt
      for (var error in errorPrompts) {
        if (event.contains(error)) {
          socket.destroy();
          completer.completeError(error);
        }
      }

      // Complete and assign socket on success connect flow
      if (event.contains(shReadyPrt)) {
        _socket = socket;
        _socketStream = socketStream;
        completer.complete();
      }
    });

    // Complete with error by timeout to prevent deadlocks
    Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        socket.destroy();
        completer.completeError('Connect timeout');
      }
    });

    return completer.future;
  }

  @override
  Future<LineStats> fetchStats() async {
    print('object');
    try {
      await _connect();
    } catch (e) {
      print('Connect error: $e');
      return LineStats.errored(snapshotId: snapshotId, statusText: 'Connect error: $e');
    }
    throw UnimplementedError();
  }
}
