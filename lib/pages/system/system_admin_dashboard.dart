import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:offering_collection_web/pages/services/firebase_services.dart';

class SystemAdminDashboard extends StatelessWidget {
  static const String id = "dashboard-page";
  FirebaseServices _services = FirebaseServices();

  final currentUser = FirebaseAuth.instance.currentUser!;
  String churchId = "";

  @override
  Widget build(BuildContext context) {
    Widget analyticWidget({required String title, required String value}) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          height: 200,
          width: 400,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey),
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title, 
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.show_chart, 
                        color: Colors.white,
                        size: 50,
                      ),
                    ],
                  ),

                  SizedBox(height: 30),

                Center(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _services.users.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong!");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                        height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )),
                  );
                }
                if (snapshot.hasData) {
                  return analyticWidget(
                      title: "Total User(s)",
                      value: snapshot.data!.size.toString());
                }
                return SizedBox();
              },
            ),

             StreamBuilder<QuerySnapshot>(
              stream: _services.churches.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong!");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                        height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )),
                  );
                }
                if (snapshot.hasData) {
                  return analyticWidget(
                      title: "Total Churches(s)",
                      value: snapshot.data!.size.toString());
                }
                return SizedBox();
              },
            ),
            // analyticWidget(title: "Total Churches", value: "4"),
          ],
        ),
      ],
    );
  }
}
