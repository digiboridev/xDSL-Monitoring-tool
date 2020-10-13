import 'dart:async';
import 'dart:isolate';

import 'package:dslstats/screens/SettingsScreen/HostAdress.dart';
import 'package:dslstats/screens/SettingsScreen/SamplingInterval.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'modemClients/Client.dart';
import 'modemClients/LineStatsCollection.dart';
import 'modemClients/Client_Simulator.dart';
import 'modemClients/Client_HG530.dart';

import 'package:dslstats/models/modemClients/Contact.dart';

class IsolateParameters {
  Client client;
  SendPort sendPort;
  int samplingInterval;

  IsolateParameters(this.client, this.sendPort, this.samplingInterval);
}

enum ModemTypes { Huawei_HG532e, Dlink_2640u, ZTE_h108n, Tebda_D301 }

class DataProvider extends ChangeNotifier {
  Isolate isolate;
  ReceivePort receivePort = ReceivePort();
  static const platform = const MethodChannel('getsome');

  ModemTypes _modemType = ModemTypes.Dlink_2640u;
  String _hostAdress = '192.168.1.10';
  String _login = 'admin';
  String _password = 'admin';
  int _samplingInterval = 1;
  int _collectInterval = 60;

  List _collectionKeys = [];
  Map _collections = {};

  bool isCounting = false;

  get collectionsCount {
    return _collectionKeys.length;
  }

  get getCollectionsKeys {
    return _collectionKeys;
  }

  get getCollections {
    return _collections;
  }

  void updateCollections() async {
    var collectionKeys = await Hive.openBox('collectionKeys');
    _collectionKeys = collectionKeys.values.toList();

    Map collections = {};

    _collectionKeys.forEach((element) async {
      var collection = await Hive.openBox(element);
      collections[element] = collection.values;
    });

    _collections = collections;
  }

  void createCollection() async {
    String time = DateTime.now().toString();
    var collectionKeys = await Hive.openBox('collectionKeys');
    collectionKeys.add(time);
    Hive.openBox(time);

    updateCollections();
  }

  void addToLast(data) async {
    var collection = await Hive.openBox(_collectionKeys.last);
    collection.add(data);
  }

  void printCollections() async {
    // print(_collectionKeys);
    print(_collections[_collectionKeys.last].elementAt(0));
  }

  //Global settings

  set setPassword(value) {
    _password = value;
    notifyListeners();
  }

  get getPassword {
    return _password;
  }

  set setLogin(value) {
    _login = value;
    notifyListeners();
  }

  get getLogin {
    return _login;
  }

  set setHostAdress(value) {
    _hostAdress = value;
    notifyListeners();
  }

  get getHostAdress {
    return _hostAdress;
  }

  set setModemtype(ModemTypes type) {
    _modemType = type;
    notifyListeners();
  }

  get getModemType {
    return _modemType;
  }

  set setSamplingInterval(s) {
    _samplingInterval = s;
    notifyListeners();
    print(s);
  }

  get getSamplingInterval {
    return _samplingInterval;
  }

  set setCollectInterval(m) {
    _collectInterval = m;
    notifyListeners();
    print(m);
  }

  get getCollectInterval {
    return _collectInterval;
  }

// Methods
  void startCounter() {
    if (isCounting) {
      print('Started');
    } else {
      isCounting = true;
      setIsolatedTimer();
      startForegroundService();
      startWakelock();
    }
  }

  void stopCounter() {
    if (!isCounting) {
      print('Stopped');
    } else {
      isCounting = false;
      isolate.kill();
      isolate = null;
      receivePort.close();
      stopWakelock();
      FlutterForegroundPlugin.stopForegroundService();
    }
  }

  static void isolateFunc(params) {
    void tick() async {
      params.sendPort.send(await params.client.getData);
      Timer(new Duration(seconds: params.samplingInterval), tick);
    }

    tick();
  }

  void setIsolatedTimer() async {
    ReceivePort receivePort = ReceivePort();

    Client client() {
      if (_modemType == ModemTypes.Huawei_HG532e) {
        return Client_HG530e(
            ip: _hostAdress, user: _login, password: _password);
      } else {
        return Client_Simulator();
      }
    }

    IsolateParameters params = new IsolateParameters(
        client(), receivePort.sendPort, _samplingInterval);

    isolate = await Isolate.spawn(
      isolateFunc,
      params,
    );
    receivePort.listen((data) {
      print(data.getAsMap);
      addToLast(data);
      // setCounter = data;
    });
  }

  void startWakelock() async {
    String value;
    try {
      value = await platform.invokeMethod('startWakeLock');
    } catch (e) {
      print(e);
    }
    print(value);
  }

  void stopWakelock() async {
    String value;
    try {
      value = await platform.invokeMethod('stopWakeLock');
    } catch (e) {
      print(e);
    }
    print(value);
  }

  static void foregroundServiceFunc() {
    debugPrint("Foreground service tick ${DateTime.now()}");
  }

  void startForegroundService() async {
    await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 360);
    await FlutterForegroundPlugin.setServiceMethod(foregroundServiceFunc);
    await FlutterForegroundPlugin.startForegroundService(
      holdWakeLock: false,
      onStarted: () {
        print("Foreground on Started");
      },
      onStopped: () {
        print("Foreground on Stopped");
      },
      title: "Sampling started",
      content: null,
      iconName: "ic_stat_show_chart",
    );
  }
}
