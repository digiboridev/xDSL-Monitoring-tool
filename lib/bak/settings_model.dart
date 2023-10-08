// import 'package:flutter/foundation.dart';
// import 'package:xdslmt/models/StorageManager/HiveSettingsStorageManager.dart';

// class SettingsModel extends ChangeNotifier with HiveSettingsStorageManager {
//   //Initialize parameters with defaults
//   bool _animated = true;
//   bool _orientFixed = true;

//   SettingsModel() {
//     updateSettings();
//   }

//   //Global settings

//   //Update settings from storage
//   void updateSettings() {
//     updateAnimated();
//     updateOrient();
//   }

//   //  Settings manipulation mathods

//   //  Set to local variable and hive sore
//   //  Update from hive
//   //  Get from local

//   // Animation

//   set setAnimated(bool value) {
//     saveToStorage('animated', value);
//     _animated = value;
//     notifyListeners();
//   }

//   void updateAnimated() {
//     _animated = loadFromStorage('animated') ?? _animated;
//     notifyListeners();
//   }

//   get getAnimated {
//     return _animated;
//   }

//   //Orientation

//   set setOrient(bool value) {
//     saveToStorage('orient', value);
//     _orientFixed = value;
//     notifyListeners();
//   }

//   void updateOrient() {
//     loadFromStorage('orient');
//     notifyListeners();
//   }

//   get getOrient {
//     return _orientFixed;
//   }
// }
