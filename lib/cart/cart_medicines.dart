import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_tracker/medicines/medicine_decoration.dart';

import 'cart_medicine_filter.dart';
import 'order_screen.dart';

class CartMedicines extends StatefulWidget {
  String name;
  String phoneNo;
  bool orderPlaced;

  CartMedicines(
      {Key? key,
      required this.name,
      required this.phoneNo,
      required this.orderPlaced})
      : super(key: key);

  @override
  _CartMedicinesState createState() => _CartMedicinesState();
}

class _CartMedicinesState extends State<CartMedicines> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String userId = "";

  _CartMedicinesState() {
    // very important if u wana change Future<String> into String
    getId().then((val) => setState(() {
          userId = val;
        }));
  }

  num totalAmount = 0;
  num noOfItems = 0;

  @override
  Widget build(BuildContext context) {
    return (userId == "")
        ? CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.teal,
              title: Row(
                children: [
                  Text("${widget.name}'s Cart",
                      style: TextStyle(color: Colors.white, fontSize: 22)),
                ],
              ),
            ),
            body: SafeArea(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderScreen(
                                  totalAmount: totalAmount,
                                  noOfItems: noOfItems,
                                  name: widget.name,
                                  phoneNo: widget.phoneNo),
                            ));
                      },
                      child: Card(
                        color: Colors.black54,
                        child: ListTile(
                          leading: Icon(
                            Icons.medical_services_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                          title: Text(
                            'Place Your Order',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_sharp,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("MedTracker")
                          .doc(userId)
                          .collection(widget.name + " " + widget.phoneNo)
                          .snapshots(),
                      builder: (BuildContext context, snapshot) {
                        int countId = snapshot.data?.docs.length ?? 0;
                        if (countId == 0) {
                          return SingleChildScrollView(
                            child: Container(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: MediaQuery.of(context).size.height*.1,),
                                    Center(child: Image(image: AssetImage("assets/cartEmpty.png"))),
                                  ],
                                )),
                          );
                        }
                        return GridView.builder(
                          physics: ScrollPhysics(), // to disable GridView's scrolling
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            Map<String, dynamic> document =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            if(document['quantity']==0) {
                              totalAmount =
                                  totalAmount + document['price'] * 30;
                            }
                            noOfItems = noOfItems + 1;
                            if (widget.orderPlaced && document['price']!=0 ) {
                              print("placed");
                              FirebaseFirestore.instance
                                  .collection('MedTracker')
                                  .doc(userId)
                                  .collection(widget.name + " " + widget.phoneNo)
                                  .doc(snapshot.data!.docs[index].id)
                                  .update({"quantity": 30});
                            }
                            return CartMedicineFilter(
                              name: document["name"],
                              time: document["time"],
                              quantity: document["quantity"],
                              patientId: widget.name + " " + widget.phoneNo,
                              index: index,
                              userId: userId,
                              medDocs: snapshot.data!.docs,
                              price: document['price'],
                            );
                          },
                          itemCount: snapshot.data!.docs.length,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Future<String> getId() async {
    final user = await FirebaseAuth.instance.currentUser!;
    return user.uid;
  }
}
