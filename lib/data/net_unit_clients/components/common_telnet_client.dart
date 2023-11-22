import 'dart:async';
import 'dart:io';
import 'package:xdslmt/core/app_logger.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import 'package:xdslmt/data/models/raw_line_stats.dart';
import 'package:xdslmt/utils/debouncebuffer.dart';

/// Alias for function that responds to specific prompt with command
/// `prompt` - prompt that needs to be responded
/// `command` - command that will be sent after prompt appears
typedef P2C = ({String prompt, String command});

/// Alias for function that requests stats using specific command and trying parse the response
/// `command` - command that will be sent to request stats
/// `tryParse` - function that will try to parse response and return [RawLineStats] or null
typedef Cmd2Stats = ({String command, RawLineStats? Function(String) tryParse});

class CommonTelnetClient implements NetUnitClient {
  CommonTelnetClient({
    required this.unitIp,
    required this.prepPrts,
    required this.errorPrts,
    required this.readyPrt,
    required this.cmd2Stats,
  });

  final String unitIp;

  /// Prompts for auth and shell preparation
  final List<P2C> prepPrts;

  /// Prompts for error recognition durning connect
  final List<String> errorPrts;

  /// Prompt that appears after shell prepared and ready for full access
  final String readyPrt;

  final Cmd2Stats cmd2Stats;

  Socket? _socket;
  Stream<String>? _socketStream;
  bool get _isConnected => _socket != null && _socketStream != null;
  bool _disposed = false;

  @override
  Future<RawLineStats> fetchStats() async {
    try {
      if (!_isConnected) await _connect();
      final lineStats = await _getStats();
      return lineStats;
    } catch (e, s) {
      AppLogger.warning(name: 'CommonTelnetClient', 'Fetch error: $e', error: e, stack: s);
      _wipeSocket();
      return RawLineStats.errored(statusText: e.toString());
    }
  }

  @override
  dispose() {
    _wipeSocket();
    _disposed = true;
  }

  void _wipeSocket() {
    _socket?.destroy();
    _socket = null;
    _socketStream = null;
  }

  /// Start connect flow and return future that completes on success or throws error
  /// After successfull negotiation socket and socketStream will be available in [_socket] and [_socketStream]
  Future _connect() async {
    final completer = Completer();

    AppLogger.debug(name: 'CommonTelnetClient', 'Connect start');

    final socket = await Socket.connect(unitIp, 23, timeout: const Duration(seconds: 5));
    final socketStream = socket.map((event) => String.fromCharCodes(event).trim()).asBroadcastStream();

    AppLogger.debug(name: 'CommonTelnetClient', 'Connect established');
    AppLogger.debug(name: 'CommonTelnetClient', 'Socket local address: ${socket.address}:${socket.port}');
    AppLogger.debug(name: 'CommonTelnetClient', 'Socket remote address: ${socket.remoteAddress.address}:${socket.remotePort}');

    late StreamSubscription tempSub;
    tempSub = socketStream.listen(
      (event) {
        AppLogger.debug(name: 'CommonTelnetClient', 'Connect stream event > \n$event');

        // If client disposed during connection flow
        if (_disposed) socket.destroy();

        // Handle preparing prompts
        for (var p2c in prepPrts) {
          if (event.contains(p2c.prompt)) {
            AppLogger.debug(name: 'CommonTelnetClient', 'Connect matched preparing prompt: $p2c');
            socket.write('${p2c.command}\n');
          }
        }

        // Handle success prompt
        if (event.contains(readyPrt)) {
          AppLogger.debug(name: 'CommonTelnetClient', 'Connect matched ready prompt: $readyPrt');
          AppLogger.debug(name: 'CommonTelnetClient', 'Completed: ${completer.isCompleted}');
          if (!completer.isCompleted) {
            _socket = socket;
            _socketStream = socketStream;
            socket.done.then((value) => _wipeSocket());
            tempSub.cancel();
            completer.complete();
          }
        }

        // Handle errors prompt
        for (var error in errorPrts) {
          if (event.contains(error)) {
            AppLogger.debug(name: 'CommonTelnetClient', 'Connect matched error prompt: $error');
            AppLogger.debug(name: 'CommonTelnetClient', 'Completed: ${completer.isCompleted}');
            if (!completer.isCompleted) {
              tempSub.cancel();
              socket.destroy();
              completer.completeError(error);
            }
          }
        }
      },
      onError: (e, s) {
        AppLogger.debug(name: 'CommonTelnetClient', 'Connect stream error: $e');
        AppLogger.debug(name: 'CommonTelnetClient', 'Completed: ${completer.isCompleted}');
        if (!completer.isCompleted) completer.completeError(e, s);
      },
      cancelOnError: true,
    );

    // Auto complete by timeout if no success prompt received
    Timer(const Duration(seconds: 5), () {
      AppLogger.debug(name: 'CommonTelnetClient', 'Connect timeout');
      AppLogger.debug(name: 'CommonTelnetClient', 'Completed: ${completer.isCompleted}');
      if (!completer.isCompleted) {
        tempSub.cancel();
        socket.destroy();
        completer.completeError(TimeoutException('Hasnt connected to unit in time'));
      }
    });

    return completer.future;
  }

  Future<RawLineStats> _getStats() {
    final completer = Completer<RawLineStats>();

    AppLogger.debug(name: 'CommonTelnetClient', 'Get stats start');

    late StreamSubscription tempSub;
    tempSub = _socketStream!.transform(DebounceBuffer(const Duration(milliseconds: 300))).listen(
      (event) {
        AppLogger.debug(name: 'CommonTelnetClient', 'Get stats stream event > \n$event');

        // Wait and parse stats pessimistically due to possible garbage in stream
        RawLineStats? maybeStats = cmd2Stats.tryParse(event);
        if (maybeStats != null && !completer.isCompleted) {
          AppLogger.debug(name: 'CommonTelnetClient', 'Get stats parsed');

          tempSub.cancel();
          completer.complete(maybeStats);
        }
      },
      onError: (e, s) {
        AppLogger.debug(name: 'CommonTelnetClient', 'Get stats stream error: $e');
        AppLogger.debug(name: 'CommonTelnetClient', 'Completed: ${completer.isCompleted}');
        if (!completer.isCompleted) completer.completeError(e, s);
      },
      cancelOnError: true,
    );

    // Send command to get stats
    AppLogger.debug(name: 'CommonTelnetClient', 'Get stats send: ${cmd2Stats.command}');
    _socket!.write('${cmd2Stats.command}\n');

    // Auto complete by timeout if no stats received
    Timer(const Duration(seconds: 10), () {
      AppLogger.debug(name: 'CommonTelnetClient', 'Get stats timeout');
      AppLogger.debug(name: 'CommonTelnetClient', 'Completed: ${completer.isCompleted}');
      if (!completer.isCompleted) {
        tempSub.cancel();
        completer.completeError(TimeoutException('Hasnt received stats in time'));
      }
    });

    return completer.future;
  }
}
