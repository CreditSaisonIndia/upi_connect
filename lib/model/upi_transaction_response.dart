enum TRANSACTIONSTATUS { success, failure, other }

class UPITransactionResponse {
  late String transactionId = "";
  late String responseCode = "";
  late String referenceId = "";
  late TRANSACTIONSTATUS status = TRANSACTIONSTATUS.other;
  late String statusMessage = "";
  late dynamic rawResponse;

  UPITransactionResponse({
    required this.transactionId,
    required this.responseCode,
    required this.referenceId,
    required this.status,
    required this.statusMessage,
  });

  @override
  String toString() {
    return 'UPITransactionResponse{transactionId: $transactionId, responseCode: $responseCode, referenceId: $referenceId, status: $status, statusMessage: $statusMessage, rawResponse: $rawResponse}';
  }

  UPITransactionResponse.fromString(String this.rawResponse) {
    if (rawResponse.isEmpty) {
      return;
    }
    List<String> transactionDetailsList = rawResponse.split("&");
    for (String transactionDetail in transactionDetailsList) {
      List<String> keyValue = transactionDetail.split("=");
      String key = keyValue[0].toLowerCase();
      String value = keyValue[1].toLowerCase();
      switch (key) {
        case "txnId":
          transactionId = value;
          break;
        case "txnRef":
          referenceId = value;
          break;
        case "responseCode":
          responseCode = value;
          break;
        case "status":
          statusMessage = value;
          switch (value) {
            case "success":
              status = TRANSACTIONSTATUS.success;
              break;
            case "failure":
            case "failed":
              status = TRANSACTIONSTATUS.failure;
              break;
          }
          break;
      }
    }
  }
}
