import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'create_id.dart';
import 'id_decoration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String userId = "";

  _HomeScreenState() {
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
              backgroundColor: Colors.black,
              title: Row(
                children: [
                  Text(
                    "Med",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text("Tracker",
                      style: TextStyle(color: Colors.green, fontSize: 23)),
                ],
              ),
              actions: [
                Center(
                    child: Text(
                  "Create id",
                  style: TextStyle(fontSize: 18),
                )),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateId(),
                          ));
                    },
                    icon: Icon(Icons.create)),
              ],
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("MedTracker")
                  .doc(userId)
                  .collection("userData")
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                int countId = snapshot.data?.docs.length??0;
                if (countId==0) {
                  return SingleChildScrollView(
                    child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height:100),
                            Text("Nothing Created Yet!",style: TextStyle(color: Colors.blue,fontSize: 22),),
                            SizedBox(height:10),
                            Text("Click on Create Id button on top."),
                            SizedBox(height:100),
                            Center(child: CircularProgressIndicator()),
                          ],
                        )),
                  );
                }
                return ListView.builder(
                  itemBuilder: (context, index) {
                    Map<String,dynamic> document = snapshot.data!.docs[index].data() as Map<String,dynamic>;
                    return IdDecoration(
                      name:document["name"],
                      age:document["age"],
                        bloodGroup:document["bloodGroup"],
                      phoneNo:document["phoneNo"],
                      userId:userId
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              },
            ),
          );
  }

  Future<String> getId() async {
    final user = await FirebaseAuth.instance.currentUser!;
    return user.uid;
  }
}
