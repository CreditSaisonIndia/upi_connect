import 'package:upi_connect/upi_connect_method_channel.dart';
import 'package:upi_connect/model/upi_app.dart';
import 'package:upi_connect/model/upi_transaction_response.dart';

class UPITransaction {
  late final double amount;
  late final String receiverName;
  late final String receiverUpiId;
  late final String transactionId;
  late final String transactionNote;
  late final bool flexibleAmount;
  UPIApp? upiApp;
  final Function(UPITransactionResponse)? onResponse;
  late final String upiUrl;

  UPITransaction({
    required this.amount,
    required this.receiverName,
    required this.receiverUpiId,
    required this.transactionId,
    required this.transactionNote,
    this.flexibleAmount = false,
    required this.onResponse,
    this.upiApp,
  }) {
    upiUrl =
    "upi://pay?pa=$receiverUpiId&pn=$receiverName&tr=$transactionId&tn=$transactionNote&am=$amount&mc=0000&mode=02&cu=INR";
  }

  UPITransaction.fromQRScanner({
    required this.upiUrl,
    required this.onResponse,
  });

  Future<dynamic> initiate({Function(dynamic)? onResultCallBack}) {
    return MethodChannelUpiConnect().initiateTransaction(
      upiTransaction: this,
    );
  }
}
