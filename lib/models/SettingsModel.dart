import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'ModemTypes.dart';

class SettingsModel extends ChangeNotifier {
  //Initialize parameters with defaults

  ModemTypes _modemType = ModemTypes.Dlink_2640u;
  String _hostAdress = '192.168.1.10';
  String _externalAdress = '8.8.8.8';
  String _login = 'admin';
  String _password = 'admin';
  int _samplingInterval = 1;
  int _collectInterval = 30;
  bool _animated = true;
  bool _orientFixed = true;

  SettingsModel() {
    updateSettings();
  }

  //Global settings

  //Update settings from storage
  void updateSettings() {
    var box = Hive.box('settings');
    _modemType = box.get('modem') == null ? _modemType : box.get('modem');
    _hostAdress =
        box.get('hostAdress') == null ? _hostAdress : box.get('hostAdress');
    _externalAdress = box.get('externalAdress') == null
        ? _externalAdress
        : box.get('externalAdress');
    _login = box.get('login') == null ? _login : box.get('login');
    _password = box.get('password') == null ? _password : box.get('password');
    _samplingInterval = box.get('samplingInterval') == null
        ? _samplingInterval
        : box.get('samplingInterval');
    _collectInterval = box.get('collectInterval') == null
        ? _collectInterval
        : box.get('collectInterval');
    _animated = box.get('animated') == null ? _animated : box.get('animated');
    _orientFixed = box.get('orient') == null ? _orientFixed : box.get('orient');
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

  set setExternalAdress(value) {
    void setToHive() async {
      var box = await Hive.openBox('settings');
      box.put('externalAdress', value);
    }

    setToHive();

    _externalAdress = value;
    notifyListeners();
  }

  get getExternalAdress {
    return _externalAdress;
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

  set setAnimated(bool val) {
    void setToHive() async {
      var box = await Hive.openBox('settings');
      box.put('animated', val);
    }

    setToHive();
    _animated = val;
    notifyListeners();
    print(val);
  }

  get getAnimated {
    return _animated;
  }

  set setOrient(bool val) {
    void setToHive() async {
      var box = await Hive.openBox('settings');
      box.put('orient', val);
    }

    setToHive();
    _orientFixed = val;
    notifyListeners();
    print(val);
  }

  get getOrient {
    return _orientFixed;
  }
}
