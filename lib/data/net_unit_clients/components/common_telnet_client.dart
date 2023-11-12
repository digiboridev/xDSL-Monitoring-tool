// ignore_for_file: unused_element, unused_field, avoid_print
import 'dart:async';
import 'dart:io';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import 'package:xdslmt/data/net_unit_clients/components/stats_parser/raw_line_stats.dart';
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
    required this.snapshotId,
    required this.prepPrts,
    required this.errorPrts,
    required this.readyPrt,
    required this.cmd2Stats,
  });

  @override
  final String snapshotId;
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
  LineStats? _prevStats;

  @override
  Future<LineStats> fetchStats() async {
    try {
      if (!_isConnected) await _connect();
      final lineStats = await _getStats();
      return lineStats;
    } catch (e) {
      print('Fetch error: $e');
      _wipeSocket();
      return LineStats.errored(snapshotId: snapshotId, statusText: e.toString());
    }
  }

  @override
  dispose() {
    print('CommonTelnetClient dispose');
    _wipeSocket();
    _disposed = true;
  }

  void _wipeSocket() {
    print('Wiping socket');
    _socket?.destroy();
    _socket = null;
    _socketStream = null;
  }

  /// Start connect flow and return future that completes on success or throws error
  /// After successfull negotiation socket and socketStream will be available in [_socket] and [_socketStream]
  Future _connect() async {
    final completer = Completer();

    final socket = await Socket.connect(unitIp, 23, timeout: const Duration(seconds: 5));
    final socketStream = socket.map((event) => String.fromCharCodes(event).trim()).asBroadcastStream();

    late StreamSubscription tempSub;

    tempSub = socketStream.listen(
      (event) {
        print('Socket event: $event');

        // If client disposed during connection flow
        if (_disposed) socket.destroy();

        // Handle preparing prompts
        for (var p2c in prepPrts) {
          if (event.contains(p2c.prompt)) {
            print('Matched preparing prompt: ${p2c.prompt}');
            print('Sending command: ${p2c.command}');
            socket.write('${p2c.command}\n');
          }
        }

        // Handle success prompt
        if (event.contains(readyPrt)) {
          print('Matched ready prompt: $readyPrt');
          if (!completer.isCompleted) {
            print('Completing connection flow');
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
            print('Matched error prompt: $error');
            if (!completer.isCompleted) {
              print('Completing connection flow with error');
              tempSub.cancel();
              socket.destroy();
              completer.completeError(error);
            }
          }
        }
      },
      onError: (e) {
        print('Socket error: $e');
        if (!completer.isCompleted) {
          print('Completing connection flow with error');
          completer.completeError('Connect error $e');
        }
      },
      cancelOnError: true,
    );

    // Auto complete by timeout if no success prompt received
    Timer(const Duration(seconds: 5), () {
      if (!completer.isCompleted) {
        print('Completing connection flow timeout error');
        tempSub.cancel();
        socket.destroy();
        completer.completeError('Connect timeout');
      }
    });

    return completer.future;
  }

  Future<LineStats> _getStats() {
    final completer = Completer<LineStats>();
    late StreamSubscription tempSub;

    tempSub = _socketStream!.transform(DebounceBuffer(const Duration(milliseconds: 300))).listen(
      (event) {
        // Wait and parse stats pessimisticaSlly due to possible garbage in stream
        print('Get stats event: $event');
        RawLineStats? maybeStats = cmd2Stats.tryParse(event);
        if (maybeStats != null && !completer.isCompleted) {
          final stats = LineStats(
            snapshotId: snapshotId,
            status: maybeStats.status,
            statusText: maybeStats.statusText.trim(),
            connectionType: maybeStats.connectionType?.trim(),
            upAttainableRate: maybeStats.upAttainableRate,
            downAttainableRate: maybeStats.downAttainableRate,
            upRate: maybeStats.upRate,
            downRate: maybeStats.downRate,
            upMargin: maybeStats.upMargin != null ? (maybeStats.upMargin! * 10).truncate() : null,
            downMargin: maybeStats.downMargin != null ? (maybeStats.downMargin! * 10).truncate() : null,
            upAttenuation: maybeStats.upAttenuation != null ? (maybeStats.upAttenuation! * 10).truncate() : null,
            downAttenuation: maybeStats.downAttenuation != null ? (maybeStats.downAttenuation! * 10).truncate() : null,
            upCRC: maybeStats.upCRC,
            downCRC: maybeStats.downCRC,
            upFEC: maybeStats.upFEC,
            downFEC: maybeStats.downFEC,
            upCRCIncr: _incrDiff(_prevStats?.upCRC, maybeStats.upCRC),
            downCRCIncr: _incrDiff(_prevStats?.downCRC, maybeStats.downCRC),
            upFECIncr: _incrDiff(_prevStats?.upFEC, maybeStats.upFEC),
            downFECIncr: _incrDiff(_prevStats?.downFEC, maybeStats.downFEC),
          );
          print('Completing with stats: $stats');

          _prevStats = stats;
          tempSub.cancel();
          completer.complete(stats);
        }
      },
      onError: (e) {
        print('Get stats error: $e');
        if (!completer.isCompleted) {
          print('Completing get stats flow with error');
          completer.completeError('Connect error $e');
        }
      },
      cancelOnError: true,
    );

    // Send command to get stats
    print('Sending command: ${cmd2Stats.command}');
    _socket!.write('${cmd2Stats.command}\n');

    // Auto complete by timeout if no stats received
    Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        print('Completing get stats flow with timeout error');
        tempSub.cancel();
        completer.completeError('Get stats timeout');
      }
    });

    return completer.future;
  }

  int _incrDiff(int? prev, int? next) {
    if (prev == null || next == null) return 0;
    final diff = next - prev;
    return diff > 0 ? diff : 0;
  }
}
