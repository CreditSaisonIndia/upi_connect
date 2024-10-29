import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'model/flutter_intent_with_result.dart';
import 'model/upi_app.dart';
import 'model/upi_transaction.dart';
import 'model/upi_transaction_response.dart';
import 'upi_connect_platform_interface.dart';

/// An implementation of [UpiConnectPlatform] that uses method channels.
class MethodChannelUpiConnect extends UpiConnectPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.cs.upi_connect/intent');
  final String methodName = "upi_intent";
  final String upiAppsMethodName = "get_all_upi_apps";

  // intentResponseEventChannel is required to listen/capture the result of the started intent
  static const intentResponseEventChannel =
      EventChannel("com.cs.upi_connect/upi_intent_response");

  StreamSubscription<dynamic>? _intentStatusSubscription;

  @override
  Future<dynamic> launchIntent(
      {required FlutterIntentWithResult intentDetails,
      Function(dynamic)? onResponse,
      String? packageName}) async {
    if (onResponse != null) {
      _startListeningToIntentStatus(onResponse);
    }
    try {
      Map? nativeResponse = await methodChannel.invokeMapMethod(
        methodName,
        {
          "intentURL": intentDetails.url,
          "action": intentDetails.action,
          "packageName": packageName,
          "extras": intentDetails.extras,
          "requestCode": intentDetails.requestCode,
        },
      );
      bool isSuccess = ((nativeResponse?["status"] ?? "") == "SUCCESS");
      if (!isSuccess) {
        _intentStatusSubscription?.cancel();
      }
      return nativeResponse;
    } catch (e) {
      // print the error
      rethrow;
    }
  }

  @override
  Future<List<UPIApp>> getAllUpiApps() async {
    try {
      Map? nativeResponse =
          await methodChannel.invokeMapMethod(upiAppsMethodName);

      if (kDebugMode) {
        print(nativeResponse);
      }
      if (nativeResponse != null && nativeResponse.containsKey("appsList")) {
        List rawAppsList = nativeResponse['appsList'];
        List<UPIApp> apps = [];
        for (var element in rawAppsList) {
          apps.add(UPIApp.fromMap(element as Map));
        }
        return apps;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future initiateTransaction({
    required UPITransaction upiTransaction,
  }) async {
    return await launchIntent(
      intentDetails: FlutterIntentWithResult(
        url: upiTransaction.upiUrl,
        requestCode: 1233,
      ),
      onResponse: (dynamic response) {
        upiTransaction.onResponse?.call(UPITransactionResponse.fromString(
            response?['extraData']?['response'] ?? ""));
      },
      packageName: upiTransaction.upiApp?.packageName ?? "",
    );
  }

  _startListeningToIntentStatus(Function(dynamic) onEvent) {
    _intentStatusSubscription =
        intentResponseEventChannel.receiveBroadcastStream().listen(onEvent);
  }
}
