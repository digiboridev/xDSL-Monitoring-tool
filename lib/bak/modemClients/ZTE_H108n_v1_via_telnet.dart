import 'dart:io';
import 'dart:async';

import 'client.dart';
import 'LineStatsCollection.dart';
import 'TrendchipTelnetParser.dart';

class ZTE_H108n_v1_via_telnet implements Client {
  //variables
  final String _ip;
  final String user;
  final String password;
  final String _extIp;
  Socket socket;
  Stream socketStream;

  //constructor
  ZTE_H108n_v1_via_telnet({ip, extIp, user, password})
      : _ip = ip,
        _extIp = extIp,
        user = user,
        password = password;

  //Socket wipe
  void _socketWipe() {
    socket?.destroy();
    socket = null;
  }

  //http get data request
  Future<LineStatsCollection> get _dataRequest async {
    StreamSubscription sub;
    var completer = Completer<LineStatsCollection>();

    // Create instance of parser
    // parser will receive parts of massages and complete future when all parts is received
    var parser = TrendchipTelnetParser((collection) {
      sub.cancel();
      completer.complete(collection);
    });

    // Subscribe for socket events
    // Pass handler and error catcher
    sub = socketStream.listen(parser.receiver, onError: (e) {
      debugPrint('error in data request');
      sub.cancel();
      _socketWipe();
      completer.completeError(e);
    });

    // Write data request
    socket.write('wa ad status\nwa ad diag\n\n');

    // Automatic complete after timeout
    Timer(Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        sub.cancel();
        _socketWipe();
        completer.completeError('Custom timeout');
      }
    });

    // Return uncomplete future
    return completer.future;
  }

  // Connect and autthorize
  Future<bool> get _loginRequest async {
    StreamSubscription sub;
    var completer = Completer<bool>();

    // Socket message handler
    void handler(data) {
      // Parse charcodes
      var answer = String.fromCharCodes(data).trim();

      // Print result
      debugPrint(answer);

      // Check for contains keywords
      // If contains password request pass the password
      // If contains modem prefix return true
      // If contains bad password return false
      if ('Password:'.allMatches(answer).isNotEmpty) {
        socket.write('$password\n');
      } else if ('ZTE>'.allMatches(answer).isNotEmpty) {
        sub.cancel();
        completer.complete(true);
      } else if ('Bad Password!!!'.allMatches(answer).isNotEmpty) {
        debugPrint('not');
        sub.cancel();
        _socketWipe();
        completer.complete(false);
      }
    }

    // Open socket and connect
    socket = await Socket.connect('$_ip', 23);

    // Prevent unhandled error
    socket.done.catchError((e) {});

    // Make socket events chanell for unlisten in future
    socketStream = socket.asBroadcastStream();

    // Listen to events
    sub = socketStream.listen(handler);

    // Automatic complete and wipe after timeout
    Timer(Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        completer.complete(false);
        _socketWipe();
      }
    });

    // Return uncomplete future
    return completer.future;
  }

  //Simple pinger by running unix ping and parse it to double
  //return 0 if any errors or out of 1 second timeout
  Future<double> _pingTo(String adress) async {
    ProcessResult result = await Process.run('ping', ['-c', '1', '-W', '1', adress]);
    String out = result.stdout;

    if (result.exitCode == 0) {
      return double.parse(out.substring(out.indexOf('time=') + 5, out.indexOf(' ms')));
    } else {
      return 0;
    }
  }

  // Returns collection with modem data
  @override
  Future<LineStatsCollection> get _getCollection async {
    try {
      if (socket == null) {
        debugPrint('login try');
        var log = await _loginRequest;
        if (log) {
          debugPrint('login complete');
          var collection = await _dataRequest;
          return collection;
        } else {
          debugPrint('login failed');
          return LineStatsCollection(isErrored: true, status: 'Failed to login', dateTime: DateTime.now());
        }
      } else {
        debugPrint('socket opened');
        var collection = await _dataRequest;
        return collection;
      }
    } catch (e) {
      debugPrint('grand catch');
      debugPrint(e);
      return LineStatsCollection(isErrored: true, status: 'Connection failed', dateTime: DateTime.now());
    }
  }

  // Wait for ping and collection parallel
  // return collection with pings
  @override
  Future<LineStatsCollection> get getData async {
    LineStatsCollection collection;
    await Future.wait([_getCollection, _pingTo(_ip), _pingTo(_extIp)]).then((value) {
      collection = value[0];
      collection.latencyToModem = value[1];
      collection.latencyToExternal = value[2];
    });
    return collection;
  }
}
