#ifndef FLUTTER_PLUGIN_UPI_CONNECT_PLUGIN_H_
#define FLUTTER_PLUGIN_UPI_CONNECT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace upi_connect {

class UpiConnectPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  UpiConnectPlugin();

  virtual ~UpiConnectPlugin();

  // Disallow copy and assign.
  UpiConnectPlugin(const UpiConnectPlugin&) = delete;
  UpiConnectPlugin& operator=(const UpiConnectPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace upi_connect

#endif  // FLUTTER_PLUGIN_UPI_CONNECT_PLUGIN_H_
