#include "include/upi_connect/upi_connect_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "upi_connect_plugin.h"

void UpiConnectPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  upi_connect::UpiConnectPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
