import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_tracker/medicines/medicine_screen.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class IdDecoration extends StatefulWidget {
  final String name;
  final String phoneNo;
  final String bloodGroup;
  final int age;
  final String userId;
  const IdDecoration(
      {Key? key,
      required this.name,
      required this.age,
      required this.bloodGroup,
      required this.phoneNo,
        required this.userId})
      : super(key: key);

  @override
  _IdDecorationState createState() => _IdDecorationState();
}

class _IdDecorationState extends State<IdDecoration> {
  double temp = 25;
  double pulseRate = 25;
  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Delete"),
      onPressed:  () {
        FirebaseFirestore.
        instance.collection("MedTracker").doc(widget.userId).collection(
            widget.name + " " + widget.phoneNo).get().then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        });
        FirebaseFirestore.
        instance.collection("MedTracker").doc(widget.userId).collection(
            "userData").doc(widget.name + " " + widget.phoneNo).delete();
        Navigator.pop(context);
      },

    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text("Do you want to delete ${widget.name}'s Id?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MedicineScreen(name:widget.name,phoneNo:widget.phoneNo),
            ));
      },
      onLongPress: ()async {
        await showAlertDialog(context);
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/black.jpg"),
            fit: BoxFit.cover,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 8,
            ),
            Card(
              color: Colors.black45,
              child: ListTile(
                leading: Icon(
                  Icons.perm_contact_cal_sharp,
                  color: Colors.white,
                  size: 40,
                ),
                title: Text(
                  widget.name,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                subtitle: Row(
                  children: [
                    Text(
                      "Blood group: ${widget.bloodGroup}",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Spacer(),
                    Text(
                      "Age: ${widget.age.toString()} years",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                SleekCircularSlider(
                  appearance: CircularSliderAppearance(
                    customColors: CustomSliderColors(
                      hideShadow: true,
                      progressBarColor: Colors.transparent,
                      trackColor: Colors.green,
                      dotColor: Colors.red,
                    ),
                    customWidths: CustomSliderWidths(
                      trackWidth: 5,
                      shadowWidth: 0,
                      progressBarWidth: 01,
                      handlerSize: 7,
                    ),
                  ),
                  initialValue: 25,
                  onChange: (double value) {
                    temp = double.parse((value).toStringAsFixed(2));
                  },
                  innerWidget: (percentage) {
                    return Center(
                      child: Text(
                        'Teperature ${temp}°c',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    );
                  },
                ),
                Spacer(),
                SleekCircularSlider(
                  appearance: CircularSliderAppearance(
                    customColors: CustomSliderColors(
                      hideShadow: false,
                      progressBarColor: Colors.blue,
                      trackColor: Colors.blue,
                      dotColor: Colors.orangeAccent,
                    ),
                    customWidths: CustomSliderWidths(
                      trackWidth: 5,
                      shadowWidth: 0,
                      progressBarWidth: 01,
                      handlerSize: 7,
                    ),
                  ),
                  initialValue: 25,
                  onChange: (double value) {
                    pulseRate = double.parse((value).toStringAsFixed(2));
                  },
                  innerWidget: (percentage) {
                    return Center(
                      child: Text(
                        'Pulse Rate ${pulseRate}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
