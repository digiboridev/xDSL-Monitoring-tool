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
  Client_Simulator({ip, user, password})
      : _ip = ip,
        user = user,
        password = password;

  @override
  Future<LineStatsCollection> get getData async {
    try {
      if (Random().nextInt(100) <= 1) {
        throw ('');
      }

      int rnd = Random().nextInt(100);

      if (rnd <= 10) {
        mrU = mrU + (rnd - 50) / 100;
        mrD = mrD + (rnd - 50) / 100;
        attU = attU + (rnd - 50) / 100;
        attD = attD + (rnd - 50) / 100;
        fecU = fecU + rnd * 13;
        fecD = fecD + rnd * 20;
        crcU = crcU + rnd * 6;
        crcD = crcD + rnd * 9;
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
      );
    } catch (e) {
      return LineStatsCollection(isErrored: true, status: 'Connection failed');
    }
  }
}
