import 'package:flutter/material.dart';
import 'package:med_tracker/pages/homePage.dart';
import 'package:med_tracker/payments/payment_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'cart_medicine_filter.dart';
import 'cart_medicines.dart';

class OrderScreen extends StatefulWidget {
  final num totalAmount;
  final num noOfItems;
  final String name;
  final String phoneNo;
  const OrderScreen({Key? key,required this.totalAmount,required this.noOfItems
  ,required this.name,required this.phoneNo}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Razorpay razorpay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    razorpay = new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFaliure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }
  void openCheckout() {
    var options = {
      "key":"rzp_test_Hzo11p8AHGHGR7",
      "amount": widget.totalAmount * 100,
      "name":"MedTracker",
      "description":"Payment for the medications",
      "prefill":{
        "contact":"5252525252",
        "email":"dsalgo@gmail.com"
      },
      "external":{
        "wallets":["paytm","phonepe"]
      }
    };
    try{
      razorpay.open(options);
    }catch(e){
      print(e.toString());
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    print("payment success");
    final snackBar = SnackBar(
        backgroundColor: Colors.black,
        content: Text("Payment Success",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 25),));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (builder)=>CartMedicines(name: widget.name,phoneNo: widget.phoneNo,orderPlaced: true,)));
  }

  void handlerErrorFaliure(PaymentFailureResponse response) {
    print("payment Error");
    final snackBar = SnackBar(
        backgroundColor: Colors.black,
        content: Text("Payment Failed",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 25),));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void handlerExternalWallet(ExternalWalletResponse response) {
    print("External Wallet");
    final snackBar = SnackBar(
        backgroundColor: Colors.black,
        content: Text("Uable to open External Wallet",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 25),));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm your order!"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
            Image(image: AssetImage('assets/logo.jpg')),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Card(
                  child: ListTile(
                    title: Text("No of items: ${widget.noOfItems}"),
                    trailing: Icon(Icons.shopping_cart),
                    subtitle: Text("Recheck by clicking at Cart"),
                  ),
                ),
              ),
              Card(
                color: Colors.black54,
                child: ListTile(
                  title: Center(child: Text("Total Amount: ${widget.totalAmount} Rs",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)),
                ),
              ),
              SizedBox(height: 25,),
              InkWell(
                onTap: () {
                  openCheckout();
                },
                child: Card(
                  color: Colors.deepPurple,
                  child: ListTile(title: Center(child: Text("Pay Now",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)),),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
