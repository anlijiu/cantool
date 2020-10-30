import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluro/fluro.dart';

final currentTabInDrawerProvider = StateProvider<int>((ref) => 0);
final routerProvider = Provider<FluroRouter>((ref) => FluroRouter());
