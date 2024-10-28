// import 'package:flutter_test/flutter_test.dart';
// import 'package:upi_connect/upi_connect.dart';
// import 'package:upi_connect/upi_connect_platform_interface.dart';
// import 'package:upi_connect/upi_connect_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockUpiConnectPlatform
//     with MockPlatformInterfaceMixin
//     implements UpiConnectPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final UpiConnectPlatform initialPlatform = UpiConnectPlatform.instance;

//   test('$MethodChannelUpiConnect is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelUpiConnect>());
//   });

//   test('getPlatformVersion', () async {
//     UpiConnect upiConnectPlugin = UpiConnect();
//     MockUpiConnectPlatform fakePlatform = MockUpiConnectPlatform();
//     UpiConnectPlatform.instance = fakePlatform;

//     expect(await upiConnectPlugin.getPlatformVersion(), '42');
//   });
// }
