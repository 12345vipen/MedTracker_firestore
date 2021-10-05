import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CartMedicineFilter extends StatefulWidget {
  String name;
  String time;
  String patientId;
  int quantity;
  int index;
  String userId;
  int price;
  dynamic medDocs;

  CartMedicineFilter(
      {Key? key,
        required this.name,
        required this.patientId,
        required this.quantity,
        required this.time,
        required this.index,
        required this.userId,
        required this.medDocs,
        required this.price})
      : super(key: key);

  @override
  _CartMedicineFilterState createState() => _CartMedicineFilterState();
}

class _CartMedicineFilterState extends State<CartMedicineFilter> {
  List listImagesnotFound = [
    "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/323514_2200-732x549.jpg",
    "https://medlineplus.gov/images/Medicines.jpg",
    "https://archive2021.parliament.scot/S5_HealthandSportCommittee/Inquiries/Pills_web.jpg",
    "https://www.who.int/images/default-source/wpro/countries/papua-new-guinea/news/20190815-registration-system-for-safe-meds.jpg?sfvrsn=d6012d58_2",
  ];

  @override
  Widget build(BuildContext context) {
    return
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              color: (widget.quantity!=0 && widget.price!=0) ?Color(0xffffcdd2):Color(0xffb2dfdb),
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.all(10),

            child: (widget.quantity!=0 && widget.price!=0) ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Already In your Medication Box",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  ),
                  Spacer(),
                ],
              ),
            ):Column(
              children: [
                SizedBox(height: 20,),
                Text((widget.name=="")?"Medicine":widget.name,style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.w600,fontSize: 20),),
                SizedBox(height: 20,),
                Text("Quantity: 30"),
                SizedBox(height: 20,),
                Text("Price: ${widget.price.toString()} Rs"),
                SizedBox(height: 5,),
                Text("Amount: ${widget.price*30} Rs",style: TextStyle(color: Colors.red),)
              ],
            ),
          ),
        );
  }
}
