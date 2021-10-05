import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'cart_decoration.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String userId = "";

  _CartScreenState() {
    // very important if u wana change Future<String> into String
    getId().then((val) => setState(() {
      userId = val;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return (userId == "")
        ? CircularProgressIndicator()
        : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Cart",
            style: TextStyle(color: Colors.white, fontSize: 23)),

      ),
      body: SafeArea(

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Choose member for whom you want to order!",
              style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("MedTracker")
                  .doc(userId)
                  .collection("userData")
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                int countId = snapshot.data?.docs.length??0;
                if (countId==0) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Map<String,dynamic> document = snapshot.data!.docs[index].data() as Map<String,dynamic>;
                    return CartDecoration(
                      name:document["name"],
                      age:document["age"],
                      bloodGroup:document["bloodGroup"],
                      phoneNo:document["phoneNo"],
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              },
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
