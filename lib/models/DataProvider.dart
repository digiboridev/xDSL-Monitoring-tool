import 'dart:async';
import 'dart:collection';
import 'dart:isolate';

import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'modemClients/Client.dart';
import 'modemClients/Client_Simulator.dart';
import 'modemClients/Client_HG530.dart';
import 'ModemTypes.dart';
import 'IsolateParameters.dart';

class DataProvider extends ChangeNotifier {
  //Initialize global settings
  ModemTypes _modemType = ModemTypes.Dlink_2640u;
  String _hostAdress = '192.168.1.10';
  String _login = 'admin';
  String _password = 'admin';
  int _samplingInterval = 1;
  int _collectInterval = 30;

  //Set vars for isolate
  Isolate isolate;
  ReceivePort receivePort = ReceivePort();

  //Initialize method channel for native operations
  static const platform = const MethodChannel('getsome');

  //Init map for stats collectios
  Map _collectionMap = {};

  //Hive saving optimizations
  int saveCollectionCounter = 0;

  //Shows main counter status
  bool _isCounting = false;

  get isCounting {
    return _isCounting;
  }

  //Length of collections in collection map
  get collectionsCount {
    return _collectionMap.length;
  }

  //Collection keys reversed by nearest time
  get getCollectionsKeys {
    return _collectionMap.keys.toList().reversed;
  }

  //Get collection map instanse
  get getCollections {
    return _collectionMap;
  }

  //Get single collection by id
  //Cast list values type as LineStatsCollection
  List getCollectionByKey(cKey) {
    List<dynamic> raw = _collectionMap[cKey];
    List<LineStatsCollection> typed = raw.cast<LineStatsCollection>();
    return typed;
  }

  //Returns last collection
  get getLastCollection {
    List<dynamic> raw = _collectionMap[getCollectionsKeys.elementAt(0)];
    List<LineStatsCollection> typed = raw.cast<LineStatsCollection>();
    return typed;
  }

  //Update all collection from storage
  void updateCollections() async {
    var collectionMap = await Hive.openBox('collectionMap');
    _collectionMap = collectionMap.toMap();
    notifyListeners();
  }

  //Makes new collection
  void createCollection() {
    //Create cuttent time string
    String time = DateTime.now().toLocal().toString().substring(0, 19);

    //Add new collection named by time
    var collectionMap = Hive.box('collectionMap');
    collectionMap.put(time, []);

    //Clear counter
    saveCollectionCounter = 0;

    //Update to state
    updateCollections();
  }

  //Deleting collection by key
  void deleteCollection(ckey) {
    var collectionMap = Hive.box('collectionMap');
    collectionMap.delete(ckey);
    updateCollections();
  }

  //Adding sample to last collection
  void addToLast(data) {
    //add to provider state
    _collectionMap[_collectionMap.keys.last].add(data);

    //add to hive storage
    //adding every 50 samples for better perfomance
    if (saveCollectionCounter++ % 50 == 0) {
      print(saveCollectionCounter);
      saveLastCollection();
    }

    //Renew collection when reached collection time interval
    var cTime = DateTime.parse(_collectionMap.keys.last);
    var dif = DateTime.now().difference(cTime);
    if (dif >= Duration(minutes: _collectInterval)) {
      renewCollection();
    }

    notifyListeners();
  }

  //Save last collection map to hive storage
  void saveLastCollection() {
    var collectionMap = Hive.box('collectionMap');
    collectionMap.put(
        _collectionMap.keys.last, _collectionMap[_collectionMap.keys.last]);
  }

  //Save last collection and create new
  void renewCollection() {
    saveLastCollection();
    createCollection();
    print('renewed collection');
  }

  void printCollections() async {
    var cTime = DateTime.parse(_collectionMap.keys.last);
    var dif = DateTime.now().difference(cTime);
    print(dif >= Duration(minutes: 10));
  }

  //Global settings

  //Update settings from storage
  void updateSettings() async {
    var box = await Hive.openBox('settings');
    _modemType = box.get('modem') == null ? _modemType : box.get('modem');
    _hostAdress =
        box.get('hostAdress') == null ? _hostAdress : box.get('hostAdress');
    _login = box.get('login') == null ? _login : box.get('login');
    _password = box.get('password') == null ? _password : box.get('password');
    _samplingInterval = box.get('samplingInterval') == null
        ? _samplingInterval
        : box.get('samplingInterval');
    _collectInterval = box.get('collectInterval') == null
        ? _collectInterval
        : box.get('collectInterval');
  }

  //Settings setters and getters
  set setPassword(value) {
    void setToHive() async {
      var box = await Hive.openBox('settings');
      box.put('password', value);
    }

    setToHive();

    _password = value;
    notifyListeners();
  }

  get getPassword {
    return _password;
  }

  set setLogin(value) {
    void setToHive() async {
      var box = await Hive.openBox('settings');
      box.put('login', value);
    }

    setToHive();

    _login = value;
    notifyListeners();
  }

  get getLogin {
    return _login;
  }

  set setHostAdress(value) {
    void setToHive() async {
      var box = await Hive.openBox('settings');
      box.put('hostAdress', value);
    }

    setToHive();

    _hostAdress = value;
    notifyListeners();
  }

  get getHostAdress {
    return _hostAdress;
  }

  set setModemtype(ModemTypes type) {
    void setToHive() async {
      var box = await Hive.openBox('settings');
      box.put('modem', type);
    }

    setToHive();
    _modemType = type;
    notifyListeners();
  }

  get getModemType {
    return _modemType;
  }

  set setSamplingInterval(s) {
    void setToHive() async {
      var box = await Hive.openBox('settings');
      box.put('samplingInterval', s);
    }

    setToHive();

    _samplingInterval = s;
    notifyListeners();
    print(s);
  }

  get getSamplingInterval {
    return _samplingInterval;
  }

  set setCollectInterval(m) {
    void setToHive() async {
      var box = await Hive.openBox('settings');
      box.put('collectInterval', m);
    }

    setToHive();
    _collectInterval = m;
    notifyListeners();
    print(m);
  }

  get getCollectInterval {
    return _collectInterval;
  }

// Methods

//Starts global sampling
  void startCounter() {
    if (_isCounting) {
      print('Started');
    } else {
      //Mark sampling as started
      _isCounting = true;

      //Create new collection
      createCollection();

      //Start isolate with inner timer
      setIsolatedTimer();

      //Start foreground notification
      startForegroundService();

      //Start native partial wakelock
      startWakelock();

      //Notify
      notifyListeners();
    }
  }

//stops global sampling
  void stopCounter() {
    void killingIsolate() {
      if (isolate == null) {
        print('Provider Isolate kill tick');
        Timer(Duration(milliseconds: 100), killingIsolate);
      } else {
        isolate.kill();
        isolate = null;
      }
    }

    if (!_isCounting) {
      print('Stopped');
    } else {
      //Mark sampling as stopped
      _isCounting = false;

      //Killing isolate
      killingIsolate();

      //Close receiver port
      receivePort.close();

      //Stop native partial wakelock
      stopWakelock();

      //Remove foreground notification
      FlutterForegroundPlugin.stopForegroundService();

      //Save last local collection to storage
      saveLastCollection();

      //Notify
      notifyListeners();
    }
  }

//Isolate
  static void backgroundDataParser(params) {
    void tick() async {
      params.sendPort.send(await params.client.getData);
      Timer(new Duration(seconds: params.samplingInterval), tick);
    }

    tick();
  }

//Start isolate and receiver port
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
      backgroundDataParser,
      params,
    );
    receivePort.listen((data) {
      print(data.getAsMap);
      addToLast(data);
      // setCounter = data;
    });
  }

//Start partial wakelock by native message
  void startWakelock() async {
    String value;
    try {
      value = await platform.invokeMethod('startWakeLock');
    } catch (e) {
      print(e);
    }
    print(value);
  }

//Stop partial wakelock by native message
  void stopWakelock() async {
    String value;
    try {
      value = await platform.invokeMethod('stopWakeLock');
    } catch (e) {
      print(e);
    }
    print(value);
  }

//Show notify message
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
      title: 'Sampling is on',
      content: 'Host: ' + _hostAdress,
      iconName: "ic_stat_show_chart",
    );
  }
}
