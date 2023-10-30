// ignore_for_file: unused_element, unused_field, avoid_print
import 'dart:async';
import 'dart:io';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';

class CommonTelnetClient implements NetUnitClient {
  @override
  final String snapshotId;
  final String ip;
  final String login;
  final String password;

  CommonTelnetClient({
    required this.ip,
    required this.login,
    required this.password,
    required this.snapshotId,
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

  /// Start connect flow and return future that completes on success or throws error
  /// After successfull negotiation socket and socketStream will be available in [_socket] and [_socketStream]
  Future _connect() async {
    _wipeSocket();
    final completer = Completer();

    final socket = await Socket.connect(ip, 23);
    final socketStream = socket.map((event) => String.fromCharCodes(event).trim()).asBroadcastStream();
    socketStream.forEach((event) => print('Socket event: $event'));

    /// Attaching prompts answerers
    if (loginPrt.isNotEmpty) {
      socketStream.firstWhere((event) => event.contains(loginPrt)).then((_) => socket.writeln(login)).ignore();
    }
    if (passwordPrt.isNotEmpty) {
      socketStream.firstWhere((event) => event.contains(passwordPrt)).then((_) => socket.writeln(password)).ignore();
    }
    if (shPrepPrt.isNotEmpty) {
      socketStream.firstWhere((event) => event.contains(shPrepPrt)).then((_) => socket.writeln(shPrepCmd)).ignore();
    }

    // Handle successfull connect
    // Exposes socket and socketStream to class and complete flow
    socketStream.firstWhere((event) => event.contains(shReadyPrt)).then((_) {
      if (!completer.isCompleted) {
        _socket = socket;
        _socketStream = socketStream;
        socket.done.then((value) => _wipeSocket());
        completer.complete();
      }
    }).ignore();

    // Handle connect errors and complete with error
    for (var error in errorPrompts) {
      socketStream.firstWhere((event) => event.contains(error)).then((_) {
        if (!completer.isCompleted) {
          socket.destroy();
          completer.completeError(error);
        }
      }).ignore();
    }

    // Auto complete by timeout to prevent deadlocks
    Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        socket.destroy();
        completer.completeError('Connect timeout');
      }
    });

    return completer.future;
  }

  Future<LineStats> _getStats() {
    throw UnimplementedError();
  }

  @override
  Future<LineStats> fetchStats() async {
    try {
      await _connect();
    } catch (e) {
      print('Connect error: $e');
      return LineStats.errored(snapshotId: snapshotId, statusText: 'Connect error: $e');
    }
    throw UnimplementedError();
  }
}
