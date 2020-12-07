import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ADSLDataModel extends ChangeNotifier {
  int _collectInterval = 30;

  set setCollectInterval(m) {
    void setToHive() {
      Box box = Hive.box('settings');
      box.put('collectInterval', m);
    }

    setToHive();
    _collectInterval = m;
    notifyListeners();
    print(m);
  }

  void updateCollectInterval() {
    Box box = Hive.box('settings');
    if (box.get('collectInterval') != null) {
      _collectInterval = box.get('collectInterval');
    }
    notifyListeners();
  }

  get getCollectInterval {
    return _collectInterval;
  }

  ADSLDataModel() {
    updateCollections();
    updateCollectInterval();
  }

  //Init map for stats collectios
  Map _collectionMap = {};

  //Hive saving optimizations
  int saveCollectionCounter = 0;

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
  void updateCollections() {
    var collectionMap = Hive.box('collectionMap');
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
}
