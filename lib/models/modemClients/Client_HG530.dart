import 'dart:io';

import 'package:http/http.dart' as http;
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

class Client_HG530e implements Client {
  //variables
  String _cookie;

  final String _ip;
  final String _extIp;
  final String user;
  final String password;

  //constructor
  Client_HG530e({ip, extIp, user, password})
      : _ip = ip,
        _extIp = extIp,
        user = user,
        password = password;

  //http get data request
  Future<http.Response> get _dataRequest async {
    final url = 'http://$_ip/html/status/dslinfo.asp';
    final response = await http.get(url, headers: {
      'Cookie':
          'Language=ru; FirstMenu=Admin_0; SecondMenu=Admin_0_0; ThirdMenu=Admin_0_0_0; ${_cookie ?? ''}'
    });
    return response;
  }

  //login post request
  Future<bool> get _loginRequest async {
    final url = 'http://$_ip/index/login.cgi';

    final response = await http.post(url,
        body: 'Username=$user&Password=${ultraEncoder(password)}',
        headers: {
          'Cookie':
              'Language=ru; FirstMenu=Admin_0; SecondMenu=Admin_0_0; ThirdMenu=Admin_0_0_0; '
        });
    if (response.headers['content-length'] == '707') {
      _cookie = response.headers['set-cookie'];
      return true;
    }

    return false;
  }

  //Data parcer
  //Parce string of adsl data,add latencyes and return LineStatsCollection instance
  LineStatsCollection _parser(String res, double ltcModem, double ltcExt) {
    final substr = res.substring(
        res.indexOf(
            '"InternetGatewayDevice.WANDevice.1.WANDSLInterfaceConfig"'),
        res.indexOf('),null'));

    final List<dynamic> decodedString = jsonDecode('[' + substr + ']');

    return LineStatsCollection(
      isErrored: false,
      isConnectionUp: decodedString[2] == 'Up' ? true : false,
      status: decodedString[2],
      connectionType: decodedString[1],
      upMaxRate: int.parse(decodedString[3]),
      downMaxRate: int.parse(decodedString[4]),
      upRate: int.parse(decodedString[5]),
      downRate: int.parse(decodedString[6]),
      upMargin: double.parse(decodedString[7]) / 10,
      downMargin: double.parse(decodedString[8]) / 10,
      upAttenuation: double.parse(decodedString[12]) / 10,
      downAttenuation: double.parse(decodedString[13]) / 10,
      upCRC: int.parse(decodedString[18]),
      downCRC: int.parse(decodedString[17]),
      upFEC: int.parse(decodedString[20]),
      downFEC: int.parse(decodedString[19]),
      dateTime: DateTime.now(),
      latencyToModem: ltcModem,
      latencyToExternal: ltcExt,
    );
  }

  //Simple pinger by running unix ping and parse it to double
  //return 0 if any errors or out of 1 second timeout
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

  //Main procedure of getting data
  @override
  Future<LineStatsCollection> get getData async {
    double ping1 = 0;
    double ping2 = 0;
    try {
      //Send parallel adsl data request to modem and pings to modem and external host
      await Future.wait([_pingTo(_ip), _pingTo(_extIp)]).then((value) {
        ping1 = value[0];
        ping2 = value[1];
      });

      //extract only adsl data
      http.Response response = await _dataRequest;

      //check for login by content length
      if (response.headers['content-length'] == '691') {
        //if length invalid send login request
        if (await _loginRequest) {
          //then retry response
          response = await _dataRequest;
        } else {
          //or return as failed to login
          return LineStatsCollection(
              isErrored: true,
              status: 'Failed to login',
              dateTime: DateTime.now(),
              latencyToModem: ping1,
              latencyToExternal: ping2);
        }
      }

      //If all is ok send all data to parser end return conpleted LineStatsCollection instance
      return _parser(response.body, ping1, ping2);
    } catch (e) {
      return LineStatsCollection(
          isErrored: true,
          status: 'Connection failed',
          dateTime: DateTime.now(),
          latencyToModem: ping1,
          latencyToExternal: ping2);
    }
  }
}
