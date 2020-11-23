import 'dart:io';
import 'dart:math';

import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'Client.dart';
import 'LineStatsCollection.dart';

String ultraEncoder(text) {
  var ultraHash = base64
      .encode(utf8.encode((sha256.convert(utf8.encode(text))).toString()));
  return ultraHash;
}

class Client_Simulator implements Client {
  //variables

  final String _ip;
  final String _extIp;
  final String user;
  final String password;
  double mrU = 10;
  double mrD = 10;
  double attU = 40;
  double attD = 40;
  int fecU = 0;
  int fecD = 0;
  int crcU = 0;
  int crcD = 0;

  //constructor
  Client_Simulator({ip, extIp, user, password})
      : _ip = ip,
        _extIp = extIp,
        user = user,
        password = password;

  Future<double> _pingTo(String adress) async {
    ProcessResult result =
        await Process.run('ping', ['-c', '1', '-W', '1', adress]);
    String out = result.stdout;

    if (result.exitCode == 0) {
      return double.parse(
          out.substring(out.indexOf('time=') + 5, out.indexOf(' ms')));
    } else {
      return 0;
    }
  }

  @override
  Future<LineStatsCollection> get getData async {
    try {
      if (Random().nextInt(100) <= 1) {
        throw ('');
      }

      var latencys = await Future.wait([_pingTo(_ip), _pingTo(_extIp)]);

      int rndd = Random().nextInt(100);
      int rndu = Random().nextInt(100);
      int rndChance = Random().nextInt(100);

      if (rndChance <= 10) {
        mrD = ((mrD + (rndd - 50) / 100) * 100).round() / 100;
        attD = ((attD + (rndd - 50) / 100) * 100).round() / 100;
        fecD = fecD + rndd * 20;
        crcD = crcD + rndd * 9;
      }

      if (rndChance <= 10) {
        mrU = ((mrU + (rndu - 50) / 100) * 100).round() / 100;
        attU = ((attU + (rndu - 50) / 100) * 100).round() / 100;
        fecU = fecU + rndu * 13;
        crcU = crcU + rndu * 6;
      }
      return LineStatsCollection(
        isErrored: false,
        isConnectionUp: true,
        status: 'Up',
        connectionType: 'ADSL2+',
        upMaxRate: 2000,
        downMaxRate: 19000,
        upRate: 1898,
        downRate: 17809,
        upMargin: mrU,
        downMargin: mrD,
        upAttenuation: attU,
        downAttenuation: attD,
        upCRC: crcU,
        downCRC: crcD,
        upFEC: fecU,
        downFEC: fecD,
        dateTime: DateTime.now(),
        latencyToModem: latencys[0],
        latencyToExternal: latencys[1],
      );
    } catch (e) {
      return LineStatsCollection(
          isErrored: true,
          status: 'Connection failed',
          dateTime: DateTime.now());
    }
  }
}
