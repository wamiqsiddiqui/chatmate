import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage {
  Box box = Hive.box('tokenBox');
  setData(String key, String data) {
    box.put(key, data);
  }

  getData(String key) {
    box.get(key);
  }
}
