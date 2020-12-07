import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class SettingsModel extends ChangeNotifier {
  //Initialize parameters with defaults
  bool _animated = true;
  bool _orientFixed = true;

  SettingsModel() {
    updateSettings();
  }

  //Global settings

  //Update settings from storage
  void updateSettings() {
    updateAnimated();
    updateOrient();
  }

  //  Settings manipulation mathods

  //  Set to local variable and hive sore
  //  Update from hive
  //  Get from local

  // Animation

  set setAnimated(bool val) {
    void setToHive() {
      Box box = Hive.box('settings');
      box.put('animated', val);
    }

    setToHive();
    _animated = val;
    notifyListeners();
    print(val);
  }

  void updateAnimated() {
    Box box = Hive.box('settings');
    if (box.get('animated') != null) {
      _animated = box.get('animated');
    }
    notifyListeners();
  }

  get getAnimated {
    return _animated;
  }

  //Orientation

  set setOrient(bool val) {
    void setToHive() async {
      Box box = await Hive.box('settings');
      box.put('orient', val);
    }

    setToHive();
    _orientFixed = val;
    notifyListeners();
    print(val);
  }

  void updateOrient() {
    Box box = Hive.box('settings');
    if (box.get('orient') != null) {
      _orientFixed = box.get('orient');
    }
    notifyListeners();
  }

  get getOrient {
    return _orientFixed;
  }
}
