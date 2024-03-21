import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:offering_collection_web/model/church_model.dart';
import 'package:offering_collection_web/model/offering_model.dart';

class ManageOfferingPage extends StatefulWidget {
  static const String id = "manage-offering-page";
  const ManageOfferingPage({super.key});

  @override
  State<ManageOfferingPage> createState() => _ManageOfferingPageState();
}

class _ManageOfferingPageState extends State<ManageOfferingPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  String churchId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Churches')
              .where("email", isEqualTo: currentUser.email)
              .snapshots(),
          builder: (context, snapshot1) {
            if (!snapshot1.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var churchData = snapshot1.data!.docs;
            final church = churchData[0].data()! as Map<String, dynamic>;
            churchId = church['id'];

            return StreamBuilder<List<OfferingModel>>(
                stream: churchOffering(),
                builder: (context, snapshot2) {
                  if (snapshot2.hasError && snapshot1.hasError) {
                    return Text('Loading...');
                  }
                  if (snapshot2.connectionState == ConnectionState.waiting) {
                    return LinearProgressIndicator();
                  }

                  if (snapshot2.hasData && snapshot1.hasData) {
                    final offeringData = snapshot2.data;
                    // final churchData = snapshot1.data;

                    return DataTable(
                      columns: <DataColumn>[
                        DataColumn(label: Text('Member Email')),
                        DataColumn(label: Text('Offering Type')),
                        DataColumn(label: Text('Payment Method')),
                        DataColumn(label: Text('Amount')),
                        DataColumn(label: Text('Date')),
                      ],
                      rows: List<DataRow>.generate(
                          offeringData!.length,
                          (index) => DataRow(cells: [
                                DataCell(Text('${offeringData[index].email}')),
                                DataCell(Text(
                                    '${offeringData[index].offeringType}')),
                                DataCell(Text(
                                    '${offeringData[index].paymentMethod}')),
                                DataCell(Text('${offeringData[index].amount}')),
                                DataCell(Text('${offeringData[index].date}')),
                              ])),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                });
          },
        ),
      ]),
    );
  }

  Stream<List<ChurchModel>> readSingleChurch() {
    var churchCollection = FirebaseFirestore.instance.collection("Churches");
    var church = churchCollection.where("email", isEqualTo: "fbc@gmail.com");
    return church.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ChurchModel.fromSnapshot(e)).toList());
  }

  Stream<List<OfferingModel>> churchOffering() {
    final offeringCollection =
        FirebaseFirestore.instance.collection("Offerings");

    var offerings = offeringCollection.where("church_id", isEqualTo: churchId);
    return offerings.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => OfferingModel.fromSnapshot(e)).toList());
  }
}
