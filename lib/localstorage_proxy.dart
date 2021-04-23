import "package:localstorage/localstorage.dart";
import 'package:rxdart/rxdart.dart';

class LocalStorageProxy {
  late LocalStorage storage;

  static final Map<String, BehaviorSubject> subjects =
      <String, BehaviorSubject>{};

  static final Map<String, LocalStorageProxy> _cache =
      <String, LocalStorageProxy>{};

  factory LocalStorageProxy(String key,
      [String? path, Map<String, dynamic>? initialData]) {
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    } else {
      final proxy = LocalStorageProxy._internal(key, path, initialData);
      _cache[key] = proxy;
      return proxy;
    }
  }

  LocalStorageProxy._internal(String key,
      [String? path, Map<String, dynamic>? initialData]) {
    storage = LocalStorage(key, path, initialData);
  }

  Future<bool> get ready {
    return storage.ready;
  }

  void dispose() {
    storage.dispose();
  }

  dynamic getItem(String key) {
    return storage.getItem(key);
  }

  Stream watchItem(String key) {
    subjects[key] ??= BehaviorSubject.seeded(storage.getItem(key));
    return subjects[key]!.stream;
  }

  Future<void> setItem(
    String key,
    value, [
    Object toEncodable(Object nonEncodable)?,
  ]) async {
    await storage.setItem(key, value, toEncodable);
    subjects[key]?.add(value);
  }
}
