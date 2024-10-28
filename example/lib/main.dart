import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upi_connect/upi_connect.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String intentRes = "";
  List<UPIApp> upiApps = [];

  final String upiIdRegex = r'^[\w\.\-]+@[a-zA-Z]+$';
  final String amountRegex = r'^[0-9]+(\.[0-9]{1,2})?$';

  bool isFormValid = false;

  final TextEditingController _receiverUpiId = TextEditingController();
  final TextEditingController _amountController =
  TextEditingController(text: "50");
  final TextEditingController _transactionNotesController =
  TextEditingController(text: "Test Transaction");

  @override
  void initState() {
    super.initState();
    _fetchUPIApps();
  }

  _fetchUPIApps() async {
    upiApps = await UpiConnect.getAll();
    setState(() {});
  }

  _onResult(dynamic resultData) {
    if (kDebugMode) {
      print(resultData);
    }
    setState(() {
      intentRes = "Intent Response - \n$resultData";
    });
  }

  Widget _upiAppsList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.6,
        crossAxisSpacing: 26.0,
        mainAxisSpacing: 26.0,
      ),
      itemCount: upiApps.length,
      itemBuilder: (context, index) {
        return upiAppTile(upiApps[index]);
      },
    );
  }

  Widget upiAppTile(UPIApp upiApp) {
    return InkWell(
      onTap: isFormValid
          ? () {
        _makePayment(upiApp: upiApp);
      }
          : null,
      child: Column(
        children: [
          Image.memory(
            Uint8List.fromList(upiApp.icon),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              upiApp.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(
      {required String text, Function()? onTap, bool isEnabled = false}) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: isEnabled ? Colors.blueAccent.shade700 : Colors.grey,
      ),
      onPressed: isEnabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('UPI'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _upiForm(),
                      _verticalSpacer(),
                      const Text("or Select UPI app to pay"),
                      _verticalSpacer(),
                      _upiAppsList(),
                    ],
                  ),
                ),
              ),
              Text("UPI Apps found: ${upiApps.length}"),
              Text(intentRes),
            ],
          ),
        ),
      ),
    );
  }

  Widget _verticalSpacer() {
    return const SizedBox(
      height: 30,
    );
  }

  Widget _upiForm() {
    return Column(
      children: [
        const Text("UPI Form"),
        _receiverUpiIdField(),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _amountController,
          decoration: const InputDecoration(
            labelText: "Amount",
          ),
          onChanged: _onChange,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter amount';
            }
            if (!RegExp(amountRegex).hasMatch(value)) {
              return 'Please enter valid amount';
            }
            return null;
          },
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _transactionNotesController,
          decoration: const InputDecoration(
            labelText: "Transaction Note",
          ),
        ),
        const SizedBox(
          height: 18,
        ),
        _button(
          text: "Make Payment",
          onTap: _makePayment,
          isEnabled: isFormValid,
        ),
      ],
    );
  }

  _onChange(_) {
    bool isUpiIdValid = RegExp(upiIdRegex).hasMatch(
      _receiverUpiId.text,
    );
    bool isAmountValid = RegExp(amountRegex).hasMatch(_amountController.text);

    setState(() {
      isFormValid = isUpiIdValid && isAmountValid;
    });
  }

  Widget _receiverUpiIdField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _receiverUpiId,
      decoration: const InputDecoration(
        labelText: "Receiver UPI ID",
      ),
      onChanged: _onChange,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter UPI ID';
        }
        if (!RegExp(upiIdRegex).hasMatch(value)) {
          return 'Please enter valid UPI ID';
        }
        return null;
      },
    );
  }

  _makePayment({UPIApp? upiApp}) {
    UPITransaction upiTransaction = UPITransaction(
      amount: double.parse(_amountController.text),
      receiverName: "TestUser",
      receiverUpiId: _receiverUpiId.text,
      transactionId: "1234567890",
      transactionNote: _transactionNotesController.text,
      onResponse: (UPITransactionResponse response) {
        _onResult(response.toString());
      },
      upiApp: upiApp,
    );
    upiTransaction.initiate();
  }
}
