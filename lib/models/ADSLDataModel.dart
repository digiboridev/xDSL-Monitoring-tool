import 'dart:async';
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

class ADSLDataModel extends ChangeNotifier {
  //Initialize global settings
  ModemTypes _modemType;
  String _hostAdress;
  String _externalAdress;
  String _login;
  String _password;
  int _samplingInterval;
  int _collectInterval;

  ADSLDataModel(
      {modemType,
      hostAdress,
      externalAdress,
      login,
      password,
      samplingInt,
      collectInt})
      : _modemType = modemType,
        _hostAdress = hostAdress,
        _externalAdress = externalAdress,
        _login = login,
        _password = password,
        _samplingInterval = samplingInt,
        _collectInterval = collectInt;

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
    isolate = await Isolate.spawn(
      backgroundDataParser,
      params,
    );

    //Add listener to receiveport
    receivePort.listen((data) async {
      print(saveCollectionCounter);
      print(data.getAsMap);
      addToLast(data);
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
    await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 10);
    await FlutterForegroundPlugin.setServiceMethod(foregroundServiceFunc);
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
