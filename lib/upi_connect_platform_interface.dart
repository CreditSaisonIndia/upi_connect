import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'model/flutter_intent_with_result.dart';
import 'model/upi_app.dart';
import 'model/upi_transaction.dart';
import 'upi_connect_method_channel.dart';

abstract class UpiConnectPlatform extends PlatformInterface {
  /// Constructs a UpiConnectPlatform.
  UpiConnectPlatform() : super(token: _token);

  static final Object _token = Object();

  static UpiConnectPlatform _instance = MethodChannelUpiConnect();

  /// The default instance of [UpiConnectPlatform] to use.
  ///
  /// Defaults to [MethodChannelUpiConnect].
  static UpiConnectPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UpiConnectPlatform] when
  /// they register themselves.
  static set instance(UpiConnectPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Map?> launchIntent({required FlutterIntentWithResult intentDetails}) {
    throw UnimplementedError('launchIntent() has not been implemented.');
  }

  Future<List<UPIApp>> getAllUpiApps() {
    throw UnimplementedError('getAllUpiApps() has not been implemented.');
  }

  Future initiateTransaction({
    required UPITransaction upiTransaction,
  }) {
    throw UnimplementedError('initiateTransaction() has not been implemented.');
  }
}
