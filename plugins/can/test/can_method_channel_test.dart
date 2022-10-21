import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:can/can_method_channel.dart';

void main() {
  MethodChannelCan platform = MethodChannelCan();
  const MethodChannel channel = MethodChannel('can');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
