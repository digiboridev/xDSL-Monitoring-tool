// ignore_for_file: prefer_interpolation_to_compose_strings
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:xdslmt/core/app_logger.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/raw_line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';

String ultraEncoder(text) {
  var ultraHash = base64.encode(utf8.encode((sha256.convert(utf8.encode(text))).toString()));
  return ultraHash;
}

class HG532eClientImpl implements NetUnitClient {
  final String ip;
  final String login;
  final String password;
  HG532eClientImpl({required this.ip, required this.login, required this.password});

  String? _cookie;

  Future<bool> get _loginRequest async {
    AppLogger.debug(name: 'HG532eClientImpl', 'login request');

    final url = Uri.parse('http://$ip/index/login.cgi');

    final response = await http.post(
      url,
      body: 'Username=$login&Password=${ultraEncoder(password)}',
      headers: {'Cookie': 'Language=ru; FirstMenu=Admin_0; SecondMenu=Admin_0_0; ThirdMenu=Admin_0_0_0; '},
    );

    AppLogger.debug(name: 'HG532eClientImpl', 'statusCode: ${response.statusCode}');
    AppLogger.debug(name: 'HG532eClientImpl', 'headers: ${response.headers}');
    AppLogger.debug(name: 'HG532eClientImpl', 'body: ${response.body}');

    if (response.headers['content-length'] == '707') {
      _cookie = response.headers['set-cookie'];
      return true;
    }

    return false;
  }

  Future<http.Response> get _dataRequest async {
    final url = Uri.parse('http://$ip/html/status/dslinfo.asp');
    final response = await http.get(url, headers: {'Cookie': 'Language=ru; FirstMenu=Admin_0; SecondMenu=Admin_0_0; ThirdMenu=Admin_0_0_0; ${_cookie ?? ''}'});
    return response;
  }

  RawLineStats _parser(String res) {
    AppLogger.debug(name: 'HG532eClientImpl', 'parser res: $res');

    final substr = res.substring(res.indexOf('"InternetGatewayDevice.WANDevice.1.WANDSLInterfaceConfig"'), res.indexOf('),null'));
    AppLogger.debug(name: 'HG532eClientImpl', 'parser substr: $substr');

    final List<dynamic> decoded = jsonDecode('[' + substr + ']');
    AppLogger.debug(name: 'HG532eClientImpl', 'parser decoded: $decoded');

    num? upMargin = num.tryParse(decoded[7]);
    if (upMargin != null) upMargin /= 10;
    num? downMargin = num.tryParse(decoded[8]);
    if (downMargin != null) downMargin /= 10;
    num? upAttenuation = num.tryParse(decoded[12]);
    if (upAttenuation != null) upAttenuation /= 10;
    num? downAttenuation = num.tryParse(decoded[13]);
    if (downAttenuation != null) downAttenuation /= 10;

    final stats = RawLineStats(
      status: decoded[2] == 'Up' ? SampleStatus.connectionUp : SampleStatus.connectionDown,
      statusText: decoded[2],
      connectionType: decoded[1],
      upAttainableRate: int.tryParse(decoded[3]),
      downAttainableRate: int.tryParse(decoded[4]),
      upRate: int.tryParse(decoded[5]),
      downRate: int.tryParse(decoded[6]),
      upMargin: upMargin?.toDouble(),
      downMargin: downMargin?.toDouble(),
      upAttenuation: upAttenuation?.toDouble(),
      downAttenuation: downAttenuation?.toDouble(),
      upCRC: int.tryParse(decoded[18]),
      downCRC: int.tryParse(decoded[17]),
      upFEC: int.tryParse(decoded[20]),
      downFEC: int.tryParse(decoded[19]),
    );

    return stats;
  }

  @override
  dispose() {}

  @override
  Future<RawLineStats> fetchStats() async {
    try {
      // TODO: refactor dat shit
      http.Response response = await _dataRequest;
      if (response.headers['content-length'] == '691') {
        if (await _loginRequest) {
          response = await _dataRequest;
        } else {
          return RawLineStats.errored(statusText: 'Failed to login');
        }
      }
      return _parser(response.body);
    } catch (e, s) {
      AppLogger.warning(name: 'HG532eClientImpl', 'Fetch error: $e', error: e, stack: s);
      return RawLineStats.errored(statusText: 'Connection failed');
    }
  }
}
