import 'package:flutter_test/flutter_test.dart';
import 'package:can/can.dart';
import 'package:can/can_platform_interface.dart';
import 'package:can/can_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCanPlatform 
    with MockPlatformInterfaceMixin
    implements CanPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CanPlatform initialPlatform = CanPlatform.instance;

  test('$MethodChannelCan is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCan>());
  });

  test('getPlatformVersion', () async {
    Can canPlugin = Can();
    MockCanPlatform fakePlatform = MockCanPlatform();
    CanPlatform.instance = fakePlatform;
  
    expect(await canPlugin.getPlatformVersion(), '42');
  });
}
