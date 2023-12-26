import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fresh_n_fish_spectrum/view/main-page.dart';
import 'package:get/get.dart';
import 'package:upi_india/upi_app.dart';
import 'package:upi_india/upi_exception.dart';
import 'package:upi_india/upi_india.dart';
import 'package:upi_india/upi_response.dart';
import 'package:uuid/uuid.dart';

import '../controller/place-order-controller.dart';
import '../utils/app-constant.dart';

class UpiPage extends StatefulWidget {
  final String name, phone, address, customerToken, totalAmount;

  const UpiPage({
    Key? key,
    required this.name,
    required this.phone,
    required this.address,
    required this.customerToken,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<UpiPage> createState() => _UpiPageState();
}

class _UpiPageState extends State<UpiPage> {
  final PlaceOrderController _placeOrderController =
  Get.put(PlaceOrderController());
  Future<UpiResponse>? _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  TextStyle header = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  @override
  void initState() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    String transactionId = Uuid().v4();
    double amount = double.parse(widget.totalAmount);

    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: "vineeth.venu.mini@okicici",
      receiverName: 'Vineeth Venu',
      transactionRefId: transactionId,
      transactionNote: 'Fresh N Fish Inc',
      amount: amount,
    );
  }

  Widget displayUpiApps() {
    if (apps == null) {
      return Center(child: CircularProgressIndicator());
    } else if (apps!.isEmpty) {
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          style: header,
        ),
      );
    } else {
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app);
                  setState(() {});
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on the device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status, String transactionRefId) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        _placeOrderController.placeOrder(
          context: context,
          customerName: widget.name,
          customerPhone: widget.phone,
          customerAddress: widget.address,
          customerDeviceToken: widget.customerToken,
        );
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        break;
      default:
        print('Received an unknown transaction status');
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: header),
          Flexible(
            child: Text(
              body,
              style: value,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appMainColor,
          elevation: 2,
          leading: IconButton(
            onPressed: () => Get.offAll(() => MainPage(),
                transition: Transition.leftToRightWithFade),
            icon: const Icon(CupertinoIcons.back, color: Colors.white),
          ),
          centerTitle: true,
          title: Text(
            "Upi Page",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontFamily: 'Roboto-Regular',
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: displayUpiApps(),
            ),
            Expanded(
              child: FutureBuilder(
                future: _transaction,
                builder:
                    (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          _upiErrorHandler(snapshot.error.runtimeType),
                          style: header,
                        ),
                      );
                    }
      
                    UpiResponse _upiResponse = snapshot.data!;
                    String txnId = _upiResponse.transactionId ?? 'N/A';
                    String resCode = _upiResponse.responseCode ?? 'N/A';
                    String txnRef = _upiResponse.transactionRefId ?? 'N/A';
                    String status = _upiResponse.status ?? 'N/A';
                    String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
      
                    _checkTxnStatus(status, txnRef);
      
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          displayTransactionData('Transaction Id', txnId),
                          displayTransactionData('Response Code', resCode),
                          displayTransactionData('Reference Id', txnRef),
                          displayTransactionData('Status', status.toUpperCase()),
                          displayTransactionData('Approval No', approvalRef),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(''),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
