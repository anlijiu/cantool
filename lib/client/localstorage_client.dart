import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cantool/localstorage_proxy.dart';

final localStorageProvider =
    FutureProvider.family<LocalStorageProxy, String>((ref, dbname) async {
  print("localStorageProvider in ");
  final storage = LocalStorageProxy(dbname);
  await storage.ready;
  return storage;
});
