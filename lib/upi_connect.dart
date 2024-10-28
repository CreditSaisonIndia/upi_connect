import 'package:upi_connect/upi_connect_method_channel.dart';
import 'model/upi_app.dart';

export 'package:upi_connect/model/upi_app.dart';
export 'package:upi_connect/model/upi_transaction.dart';
export 'package:upi_connect/model/upi_transaction_response.dart';
export 'package:upi_connect/upi_connect_platform_interface.dart';

class UpiConnect {
  static Future<List<UPIApp>> getAll() async {
    return MethodChannelUpiConnect().getAllUpiApps();
  }
}
