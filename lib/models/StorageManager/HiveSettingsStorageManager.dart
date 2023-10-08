import 'package:hive/hive.dart';
import 'package:xdslmt/models/StorageManager/ISettingsStorageManager.dart';

mixin HiveSettingsStorageManager implements ISettingsStorageManager {
  Box box = Hive.box('settings');

  void saveToStorage(String key, value) async {
    box.put('$key', value);
  }

  loadFromStorage(String key) {
    return box.get('$key');
  }
}
