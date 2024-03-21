// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:offering_collection_web/model/offering_model.dart';
// import 'package:offering_collection_web/services/firestore_helper.dart';

// class OfferingList extends StatefulWidget {
//   final OfferingModel offering;
//   const OfferingList({super.key, required this.offering,});

//   @override
//   State<OfferingList> createState() => _OfferingListState();
// }

// class _OfferingListState extends State<OfferingList> {

//   final TextEditingController _offeringType = TextEditingController();
//   final TextEditingController _paymentMetohd = TextEditingController();
//   final TextEditingController _amount = TextEditingController();

//   dynamic image;
//     late String fileName;

//   @override
//   Widget build(BuildContext context) {

//     return StreamBuilder<List<OfferingModel>>(
//         stream: FirestoreHelper.read(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Failed');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return LinearProgressIndicator();
//           }

//           if (snapshot.hasData) {
//             final offeringData = snapshot.data;
//             return ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: offeringData!.length,
//                 itemBuilder: (context, index) {
//                   final singleOffering = offeringData[index];
            
//                   return Container(
//                     margin: EdgeInsets.symmetric(vertical: 5),
//                     child: ListTile(
//                       // onLongPress: () {
//                       //   showDialog(
//                       //       context: context,
//                       //       builder: (context) {
//                       //         return AlertDialog(
//                       //           title: Text("Delete"),
//                       //           content:
//                       //               Text("are you sure you want to delete"),
//                       //           actions: [
//                       //             ElevatedButton(
//                       //                 onPressed: () {
//                       //                   FirestoreHelper.delete(singleOffering)
//                       //                       .then((value) {
//                       //                     Navigator.pop(context);
//                       //                   });
//                       //                 },
//                       //                 child: Text("Delete"))
//                       //           ],
//                       //         );
//                       //       });
//                       // },
//                       leading: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                             color: Colors.deepPurple, shape: BoxShape.circle),
//                       ),
//                       title: Text("${singleOffering.amount}"),
//                       subtitle: Text("${singleOffering.offeringType}"),
//                       trailing: Wrap(
//                         spacing: 12, // space between two icons
//                         children: <Widget>[
//                           InkWell(
//                             onTap: () {
//                               dialogBox();
//                                 // Navigator.push(context, MaterialPageRoute(builder: (context) => MyDialog()));
//                               },
//                             child: Icon(Icons.edit)), // icon-1
                              
//                           InkWell(
//                               onTap: () {
//                                 FirestoreHelper.delete(singleOffering);
//                               },
//                               child: Icon(Icons.delete)), // icon-2
//                         ],
//                       ),
//                     ),
//                   );
//                 });
//           }
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         });
//   }

//   dialogBox() {

//     pickImage() async {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.image,
//         allowMultiple: false,
//       );

//       if (result != null) {
//         image = result.files.first.bytes;
//         // print(image.toString());
//         // fileName = result.files.first.name;
//         setState(() {
//           image = result.files.first.bytes;
//           fileName = result.files.first.name;
//           Navigator.pop(context);
//           dialogBox();
//         });
//       } else {
//         print("No image selected");
//       }
//     }

//     showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, setStateForDialog) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(15.0))),
//               scrollable: true,
//               title: Text(
//                 "UPDATE OFFERING",
//                 textAlign: TextAlign.center,
//               ),
//               contentPadding:
//                   EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
//               content: Column(
//                 children: [
//                   InkWell(
//                     onTap: pickImage,
//                     child: Container(
//                         height: 200,
//                         width: 200,
//                         // color: Colors.blueGrey,
//                         decoration: BoxDecoration(
//                           color: Colors.blueGrey,
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                             color: Colors.blue,
//                             width: 2,
//                           ),
//                         ),
//                         child: image == null
//                             ? Center(child: Icon(Icons.file_upload))
//                             : 
//                             Image.memory(
//                                 image,
//                                 fit: BoxFit.cover,
//                               )),
//                   ),
//                   SizedBox(
//                     height: 45.0,
//                     child: TextField(
//                       // maxLength: 2,
//                       // keyboardType: TextInputType.number,
//                       // enableInteractiveSelection: false,
//                       controller: _offeringType,
//                       decoration: InputDecoration(
//                         counterText: "",
//                         focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.grey, width: 2.0),
//                           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.black, width: 1.0),
//                           borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         ),
//                         labelText: "Type",
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 45.0,
//                     child: TextField(
//                       // maxLength: 2,
//                       // keyboardType: TextInputType.number,
//                       // enableInteractiveSelection: false,
//                       controller: _paymentMetohd,
//                       decoration: InputDecoration(
//                         counterText: "",
//                         focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.grey, width: 2.0),
//                           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.black, width: 1.0),
//                           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                         ),
//                         labelText: "Method",
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 45.0,
//                     child: TextField(
                      
//                       // maxLength: 2,
//                       // keyboardType: TextInputType.number,
//                       // enableInteractiveSelection: false,
//                       controller: _amount,
//                       decoration: InputDecoration(
//                         counterText: "",
//                         focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.grey, width: 2.0),
//                           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.black, width: 1.0),
//                           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                         ),
//                         labelText: "Amount",
//                       ),
//                     ),
//                   ),
                
//                   SizedBox(
//                     height: 15.0,
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       fixedSize: Size(
//                         MediaQuery.of(context).size.width / 1.6,
//                         50,
//                       ),
//                     ),
//                     onPressed: () {
//                       FirestoreHelper.update(OfferingModel(id: widget.offering.id, paymentMethod: _offeringType.text, amount: _amount.text, offeringType: _paymentMetohd.text));
//                       Navigator.pop(context);
//                     },
//                     child: Text('UPDATE'),
//                   ),
//                   SizedBox(
//                     width: 15.0,
//                   ),
//                   TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text('Cancel')),
//                 ],
//               ),
//             );
//           });
//         });
//   }
// }
