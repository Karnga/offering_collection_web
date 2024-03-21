import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offering_collection_web/model/offering_model.dart';
import 'package:offering_collection_web/pages/church/pdf%20report/report.dart';

class SearchPage extends StatefulWidget {
  static const String id = "search-page";
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  String churchId = "";
  String name = "";

  List<OfferingModel>? offeringData;
  List<OfferingModel> offeringsFiltered = [];

  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  getOfferingData() async {
    var chruchDataFromFirebase = await FirebaseFirestore.instance
        .collection('Churches')
        .where("email", isEqualTo: currentUser.email)
        .get();
    var churchData = chruchDataFromFirebase.docs;
    var church = churchData[0].data();
    churchId = church['id'];

    var offeringDataFromFirebase = await FirebaseFirestore.instance
        .collection('Offerings')
        .where("church_id", isEqualTo: churchId)
        .get();

    List offeringDocument = offeringDataFromFirebase.docs;

    setState(() {
      offeringData = offeringDocument
          .map((offerings) => OfferingModel.fromDoc(offerings))
          .toList();
      offeringsFiltered = offeringData!;
    });
  }

  @override
  void initState() {
    super.initState();
    getOfferingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: SizedBox(
            width: 500,
            child: CupertinoSearchTextField(
                placeholder: 'Search by date...',
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    _searchResult = value;
                    offeringsFiltered = offeringData!
                        .where((offering) =>
                            offering.date!
                                .toLowerCase()
                                .contains(_searchResult) ||
                            offering.date!.contains(_searchResult))
                        .toList();
                  });
                }),
          ),
        ),
        actions: [
          // TextButton(onPressed: (){}, child: Text('')),

          Container(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Report(
                            docid: offeringsFiltered,
                          )),
                );
              },
              style: ButtonStyle(
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // animationDuration: Duration(milliseconds: 200),
              ),
              child: const Text(
                'PRINT REPORT',
                style:
                    TextStyle(color: Colors.white, fontStyle: FontStyle.normal),
              ),
            ),
          ),

          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 530,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Member Email',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Member Contact',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Offering Type',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Payment Method',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Payment Date',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Amount',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    offeringsFiltered.length,
                    (index) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text('${offeringsFiltered[index].email}')),
                        DataCell(Text('${offeringsFiltered[index].number}')),
                        DataCell(
                            Text('${offeringsFiltered[index].offeringType}')),
                        DataCell(
                            Text('${offeringsFiltered[index].paymentMethod}')),
                        DataCell(Text('${offeringsFiltered[index].date}')),
                        DataCell(Text('${offeringsFiltered[index].amount}')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
