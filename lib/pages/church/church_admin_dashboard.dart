import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:offering_collection_web/model/offering_model.dart';
import 'package:offering_collection_web/pages/services/firebase_services.dart';

class ChurchAdminDashboard extends StatefulWidget {
  static const String id = "dashboard-page";

  @override
  State<ChurchAdminDashboard> createState() => _ChurchAdminDashboardState();
}

class _ChurchAdminDashboardState extends State<ChurchAdminDashboard> {
  FirebaseServices _services = FirebaseServices();

  final currentUser = FirebaseAuth.instance.currentUser!;

  String churchId = "";
  
  // late Future<Map> memberEmailCounted;

  getChurchData() async {
    var chruchDataFromFirebase = await FirebaseFirestore.instance
        .collection('Churches')
        .where("email", isEqualTo: currentUser.email)
        .get();
    var churchData = chruchDataFromFirebase.docs;
    var church = churchData[0].data();
    churchId = church['id'];
  }

  @override
  void initState() {
    super.initState();
    getChurchData();
  }

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
    // FutureBuilder(future: future, builder: builder);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Churches')
                  .where("email", isEqualTo: currentUser.email)
                  .snapshots(),
              builder: (context, snapshot1) {
                if (!snapshot1.hasData) {
                  return SizedBox();
                }
                var churchData = snapshot1.data!.docs;
                final church = churchData[0].data()! as Map<String, dynamic>;
                churchId = church['id'];

                return StreamBuilder<List<OfferingModel>>(
                  stream: churchOffering(),
                  builder: (context, snapshot2) {
                    if (snapshot2.hasError) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot2.connectionState == ConnectionState.waiting) {
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
                    if (snapshot2.hasData) {
                      return analyticWidget(
                          title: "Total Offering(s)",
                          value: snapshot2.data!.length.toString());
                    }
                    return SizedBox();
                  },
                );
              },
            ),

            FutureBuilder(
              future:  countMember(), 
                  builder: (context, snapshot2){
                    if (snapshot2.hasError) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot2.connectionState == ConnectionState.waiting) {
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
                    if (snapshot2.hasData) {
                      return analyticWidget(
                          title: "Total Contributor(s)",
                          value: snapshot2.data!.toString());
                    }
                    return SizedBox();
                  }
            ),
          ],
        ),
      ],
    );
  }

  Future<int> countMember() async {

    var memberEmailCounted = {};
    String chId = "";

    var chruchDataFromFirebase = await FirebaseFirestore.instance
        .collection('Churches')
        .where("email", isEqualTo: currentUser.email)
        .get();
    var churchData = chruchDataFromFirebase.docs;
    var church = churchData[0].data();
    chId = church['id'];

   await FirebaseFirestore.instance.collection('Offerings').where("church_id", isEqualTo: churchId).get().then((value) {
  
  // var memberEmailCounted = {};
  List memberEmails = [];

  value.docs.forEach((data) {
    var doc = data.data();

    memberEmails.add(doc['email']);
  });

  memberEmails.forEach((e) {
    if (!memberEmailCounted.containsKey(e)) {
      memberEmailCounted[e] = 1;
    } else {
      memberEmailCounted[e] += 1;
    }
  });
  // countedMember = memberEmailCounted.length;
  // print(memberEmailCounted.length);
  // print(churchId);
  // result should be:
  //  {Screen Reader: 2, ...etc }
});

  return memberEmailCounted.length;
}

  Stream<List<OfferingModel>> churchOffering() {
    final offeringCollection =
        FirebaseFirestore.instance.collection("Offerings");

    var offerings = offeringCollection.where("church_id", isEqualTo: churchId);
    return offerings.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => OfferingModel.fromSnapshot(e)).toList());
  }

  // Stream churchMember() {
  //   var memberEmailCounted = {};
    
  //   FirebaseFirestore.instance.collection('Offerings').where("church_id", isEqualTo: churchId).get().then((value) {
  
  //     // var memberEmailCounted = {};
  //     List memberEmails = [];

  //     value.docs.forEach((data) {
  //       var doc = data.data();

  //       memberEmails.add(doc['email']);
  //     });

  //     memberEmails.forEach((e) {
  //       if (!memberEmailCounted.containsKey(e)) {
  //         memberEmailCounted[e] = 1;
  //       } else {
  //         memberEmailCounted[e] += 1;
  //       }
  //     }
  //     );

  //   });

  //   return memberEmailCounted;

  // }

}
