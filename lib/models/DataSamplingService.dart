import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:hive/hive.dart';

import 'IsolateParameters.dart';
import 'ModemTypes.dart';
import 'modemClients/Client.dart';
import 'modemClients/Client_HG530.dart';
import 'modemClients/Client_Simulator.dart';

class DataSamplingService extends ChangeNotifier {
  ModemTypes _modemType = ModemTypes.Dlink_2640u;
  String _hostAdress = '192.168.1.10';
  String _externalAdress = '8.8.8.8';
  String _login = 'admin';
  String _password = 'admin';
  int _samplingInterval = 1;
  bool _isCounting = false;

  get isCounting {
    return _isCounting;
  }

  //Set vars for isolate
  Isolate _isolate;
  ReceivePort _receivePort = ReceivePort();

  //Constructor
  DataSamplingService() {
    updateSettings();
  }

  //Update settings from storage
  void updateSettings() {
    updateHostAdress();
    updateExternalAdress();
    updateModemtype();
    updateLogin();
    updatePassword();
    updateSamplingInterval();
  }

  //  Settings manipulation mathods

  //  Set to local variable and hive sore
  //  Update from hive
  //  Get from local

  // Password

  set setPassword(value) {
    void setToHive() async {
      var box = await Hive.openBox('settings');
      box.put('password', value);
    }

    setToHive();

    _password = value;
    notifyListeners();
  }

  void updatePassword() {
    Box box = Hive.box('settings');
    if (box.get('password') != null) {
      _password = box.get('password');
    }
    notifyListeners();
  }

  get getPassword {
    return _password;
  }

  // Login

  set setLogin(value) {
    void setToHive() {
      Box box = Hive.box('settings');
      box.put('login', value);
    }

    setToHive();

    _login = value;
    notifyListeners();
  }

  void updateLogin() {
    Box box = Hive.box('settings');
    if (box.get('login') != null) {
      _login = box.get('login');
    }
    notifyListeners();
  }

  get getLogin {
    return _login;
  }

  // Host

  set setHostAdress(value) {
    void setToHive() {
      Box box = Hive.box('settings');
      box.put('hostAdress', value);
    }

    setToHive();

    _hostAdress = value;
    notifyListeners();
  }

  void updateHostAdress() {
    Box box = Hive.box('settings');
    if (box.get('hostAdress') != null) {
      _hostAdress = box.get('hostAdress');
    }
    notifyListeners();
  }

  get getHostAdress {
    return _hostAdress;
  }

  // External host

  set setExternalAdress(value) {
    void setToHive() {
      Box box = Hive.box('settings');
      box.put('externalAdress', value);
    }

    setToHive();

    _externalAdress = value;
    notifyListeners();
  }

  void updateExternalAdress() {
    Box box = Hive.box('settings');
    if (box.get('externalAdress') != null) {
      _externalAdress = box.get('externalAdress');
    }
    notifyListeners();
  }

  get getExternalAdress {
    return _externalAdress;
  }

  // Modem type

  set setModemtype(ModemTypes type) {
    void setToHive() {
      Box box = Hive.box('settings');
      box.put('modem', type);
    }

    setToHive();
    _modemType = type;
    notifyListeners();
  }

  void updateModemtype() {
    Box box = Hive.box('settings');
    if (box.get('modem') != null) {
      _modemType = box.get('modem');
    }
    notifyListeners();
  }

  get getModemType {
    return _modemType;
  }

  //Sampling interval

  set setSamplingInterval(s) {
    void setToHive() {
      Box box = Hive.box('settings');
      box.put('samplingInterval', s);
    }

    setToHive();

    _samplingInterval = s;
    notifyListeners();
    print(s);
  }

  void updateSamplingInterval() {
    Box box = Hive.box('settings');
    if (box.get('samplingInterval') != null) {
      _samplingInterval = box.get('samplingInterval');
    }
    notifyListeners();
  }

  get getSamplingInterval {
    return _samplingInterval;
  }

  void startSampling(callback) {
    //Check counting status
    if (_isCounting) {
      print('Started');
    } else {
      //Mark sampling as started
      _isCounting = true;

      //Start isolate with inner timer
      _setIsolatedTimer(callback);

      //Start foreground notification
      _startForegroundService();

      //Start native partial wakelock
      _startWakelock();

      notifyListeners();
    }
  }

  void stopSampling() {
    //Check sampling status
    if (!_isCounting) {
      print('Stopped');
    } else {
      //Killing isolate
      _killingIsolate();

      //Close receiver port
      _receivePort.close();

      //Stop native partial wakelock
      _stopWakelock();

      //Remove foreground notification
      FlutterForegroundPlugin.stopForegroundService();

      //Change status
      _isCounting = false;

      notifyListeners();
    }
  }

  //kill isolate
  void _killingIsolate() {
    if (_isolate == null) {
      print('Provider Isolate kill tick');
      Timer(Duration(milliseconds: 100), _killingIsolate);
    } else {
      _isolate.kill();
      _isolate = null;
    }
  }

  //Initialize method channel for native operations
  static const _platform = const MethodChannel('getsome');

  //Isolate
  static void _backgroundDataParser(params) {
    void tick() async {
      params.sendPort.send(await params.client.getData);
      Timer(new Duration(seconds: params.samplingInterval), tick);
    }

    tick();
  }

//Start isolate and receiver port
  void _setIsolatedTimer(callback) async {
    ReceivePort receivePort = ReceivePort();

    //Return modem client instance by _modemType parameter
    Client client() {
      if (_modemType == ModemTypes.Huawei_HG532e) {
        return Client_HG530e(
            ip: _hostAdress,
            extIp: _externalAdress,
            user: _login,
            password: _password);
      } else {
        return Client_Simulator(ip: _hostAdress, extIp: _externalAdress);
      }
    }

    //Create instance of isolate parameters with client sendport and interval
    IsolateParameters params = new IsolateParameters(
        client(), receivePort.sendPort, _samplingInterval);

    //Spawn isolate
    _isolate = await Isolate.spawn(
      _backgroundDataParser,
      params,
    );

    //Add listener to receiveport
    receivePort.listen((data) async {
      print(data.getAsMap);
      callback(data);
    });
  }

//Start partial wakelock by native message
  void _startWakelock() async {
    String value;
    try {
      value = await _platform.invokeMethod('startWakeLock');
    } catch (e) {
      print(e);
    }
    print(value);
  }

//Stop partial wakelock by native message
  void _stopWakelock() async {
    String value;
    try {
      value = await _platform.invokeMethod('stopWakeLock');
    } catch (e) {
      print(e);
    }
    print(value);
  }

//Show notify message
  static void _foregroundServiceFunc() {
    debugPrint("Foreground service tick ${DateTime.now()}");
  }

  void _startForegroundService() async {
    await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 10);
    await FlutterForegroundPlugin.setServiceMethod(_foregroundServiceFunc);
    await FlutterForegroundPlugin.startForegroundService(
      // stopAction: true,
      // stopIcon: "ic_stat_show_chart",
      chronometer: true,
      holdWakeLock: false,
      onStarted: () {
        print("Foreground on Started");
      },
      onStopped: () {
        print("Foreground on Stopped");
      },
      title: 'Sampling is on',
      content: 'Host: ' + _hostAdress,
      iconName: "ic_stat_show_chart",
    );
  }
}
