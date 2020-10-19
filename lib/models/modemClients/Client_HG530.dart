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
  final String user;
  final String password;

  //constructor
  Client_HG530e({ip, user, password})
      : _ip = ip,
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

  //data parser
  LineStatsCollection _parser(String res) {
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
    );
  }

  //complex procedure
  @override
  Future<LineStatsCollection> get getData async {
    try {
      var response = await _dataRequest;
      if (response.headers['content-length'] == '691') {
        if (await _loginRequest) {
          response = await _dataRequest;
        } else {
          return LineStatsCollection(
              isErrored: true, status: 'Failed to login');
        }
      }

      return _parser(response.body);
    } catch (e) {
      return LineStatsCollection(
          isErrored: true,
          status: 'Connection failed',
          dateTime: DateTime.now());
    }
  }
}
