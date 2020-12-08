import 'package:dslstats/models/StorageManager/ISettingsStorageManager.dart';
import 'package:hive/hive.dart';

mixin HiveSettingsStorageManager implements ISettingsStorageManager {
  Box box = Hive.box('settings');

  void saveToStorage(String key, value) async {
    box.put('$key', value);
  }

  loadFromStorage(String key) {
    return box.get('$key');
  }
}
