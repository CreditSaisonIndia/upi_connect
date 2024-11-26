import 'package:upi_connect/upi_connect_method_channel.dart';

class FlutterIntentWithResult {
  final String url;
  final String action;
  final Map<String, dynamic>? extras;
  final int requestCode;

  FlutterIntentWithResult({
    required this.url,
    this.action = "android.intent.action.VIEW",
    required this.requestCode,
    this.extras,
  });

  Future<Map?> launch({Function(dynamic)? onResultCallBack}) {
    return MethodChannelUpiConnect().launchIntent(
      intentDetails: this,
      onResponse: onResultCallBack,
    );
  }
}
