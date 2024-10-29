# UPI Connect

[![pub package](https://img.shields.io/pub/v/upi_connect.svg)](https://pub.dev/packages/upi_connect)

`upi_connect` is a Flutter plugin designed to execute UPI transactions seamlessly using an intent URL on Android devices. This plugin supports executing UPI transactions with various UPI apps installed on the device and provides a structured response back to the application, enabling easy handling of transaction results.

### Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Examples](#examples)
  - [List UPI Apps](#1-list-all-upi-apps)
  - [Make UPI Transaction Using Intent URL](#2-make-upi-transaction-using-intent-url)
  - [Make UPI Transaction by Passing Arguments](#3-make-upi-transaction-by-passing-required-arguments)
- [API](#api)
  - [Methods](#methods)
  - [Response Format](#response-format)
- [Platform Support](#platform-support)
- [Contributing](#contributing)
- [Support](#support)
- [License](#license)

---

## Features

- Executes UPI transactions using a URL intent on Android.
- Supports handling responses after UPI transactions.
- Currently supports **Android** only.

## Installation

Add `upi_connect` as a dependency in your `pubspec.yaml`:

```yaml
dependencies:
  upi_connect: latest_version
```

Run the following command:

```bash
flutter pub get
```

## Examples

### 1. List All UPI Apps

Retrieve a list of UPI apps installed on the device.

```dart
List<UPIApp> upiApps = await UpiConnect.getAllApps();
upiApps.forEach((app) {
  print("UPI App: ${app.name}, Package: ${app.packageName}");
});
```

| Parameter   | Type        | Description              |
| ----------- | ----------- | ------------------------ |
| name        | `String`    | App's name               |
| icon        | `List<int>` | Icon as a list of bytes  |
| packageName | `String`    | Package name for the app |

### 2. Make UPI Transaction Using Intent URL

```dart
UPITransaction upiTransaction = UPITransaction.fromUrl(
  upiUrl: "upi://pay?pa=test@ybl&pn=test&am=1.00&tr=1210374251828217008&tn=Getupiapps&cu=INR&mode=04",
  onResponse: (UPITransactionResponse response) {
    _onResult(response.toString());
  },
  upiApp: upiApp,
);
upiTransaction.initiate();
```

| Parameter  | Type                               | Description                                       |
| ---------- | ---------------------------------- | ------------------------------------------------- |
| upiUrl     | `String`                           | UPI intent URL string                             |
| onResponse | `Function(UPITransactionResponse)` | Callback that receives the UPITransactionResponse |
| upiApp     | `UPIApp?`                          | [Optional] UPI app to initiate the transaction    |

### 3. Make UPI Transaction by Passing Required Arguments

```dart
UPITransaction upiTransaction = UPITransaction(
  amount: 50.0,
  receiverName: "TestUser",
  receiverUpiId: "test@ybl",
  transactionId: "1234567890",
  transactionNote: "Test Transaction",
  onResponse: (UPITransactionResponse response) {
    _onResult(response.toString());
  },
  upiApp: upiApp,
);
upiTransaction.initiate();
```

| Parameter       | Type                               | Description                                       |
| --------------- | ---------------------------------- | ------------------------------------------------- |
| amount          | `double`                           | Transaction amount                                |
| receiverName    | `String`                           | Receiver's name                                   |
| receiverUpiId   | `String`                           | UPI ID of the receiver                            |
| transactionId   | `String`                           | Unique ID for the transaction                     |
| transactionNote | `String`                           | Optional note for the transaction                 |
| onResponse      | `Function(UPITransactionResponse)` | Callback that receives the UPITransactionResponse |
| upiApp          | `UPIApp?`                          | [Optional] UPI app to initiate the transaction    |

## API

### Methods

#### `UpiConnect.getAllApps()`

Returns a list of installed UPI apps.

#### `UPITransaction.fromUrl`

Initializes a UPI transaction using a UPI intent URL.

#### `UPITransaction`

Configures a UPI transaction with specified parameters.

### Response Format

The `UPITransactionResponse` model includes:

| Field         | Type                | Description                                        |
| ------------- | ------------------- | -------------------------------------------------- |
| transactionId | `String`            | Transaction's unique ID                            |
| responseCode  | `String`            | Code for the transaction's result                  |
| referenceId   | `String`            | Reference ID of the transaction                    |
| status        | `TRANSACTIONSTATUS` | Transaction status (`success`, `failure`, `other`) |
| statusMessage | `String`            | Message describing the transaction result          |
| rawResponse   | `dynamic`           | Original response from the UPI app                 |

#### Status Enum

- `TRANSACTIONSTATUS.success`: Successful transaction.
- `TRANSACTIONSTATUS.failure`: Failed transaction.
- `TRANSACTIONSTATUS.other`: No response or unknown status.

## Platform Support

- **Android**: Supported
- **iOS**: Not supported yet

## Contributing

Feel free to submit issues and pull requests! Contributions help improve this plugin's functionality.

## Support

For questions, open an issue or reach out directly.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
