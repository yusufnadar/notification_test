import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class LocalService {
  static late GetStorage _getStorage;
  static LocalService? _instance;

  static LocalService get instance {
    _instance ??= LocalService._init();
    GetStorage.init();
    _getStorage = GetStorage();
    return _instance!;
  }

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  LocalService._init();

  dynamic read(key) {
    return _getStorage.read(key);
  }

  Future<void> write(key, dynamic value) async {
    await _getStorage.write(key, value);
  }

  Future<void> remove(key) async {
    await _getStorage.remove(key);
  }
}
