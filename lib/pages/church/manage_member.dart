// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:offering_collection_web/model/offering_model.dart';
// import 'package:offering_collection_web/services/firestore_helper.dart';

// class ManageMemberPage extends StatefulWidget {
//   static const String id = "manage-member-page";

//   const ManageMemberPage({
//     super.key,
//   });

//   @override
//   State<ManageMemberPage> createState() => _ManageMemberPageState();
// }

// class _ManageMemberPageState extends State<ManageMemberPage> {
//   dynamic image;
//   late String fileName;

//   String errorMsg = "";
//   final TextEditingController _offeringType = TextEditingController();
//   final TextEditingController _paymentMetohd = TextEditingController();
//   final TextEditingController _amount = TextEditingController();

//   // final GlobalKey _formKey = GlobalKey<FormState>();

//   String defaultImageUrl = '';
//   bool isItemSaved = false;
//   String imageLink = '';

//   @override
//   void dispose() {
//     _offeringType.dispose();
//     _paymentMetohd.dispose();
//     _amount.dispose();
//     // super.dispose();
//   }

//   void clear() {
//     _offeringType.clear();
//     _paymentMetohd.clear();
//     _amount.clear();
//   }

//   // dynamic image;
//   // late String fileName;

//   pickImage() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: false,
//     );

//     if (result != null) {
//       setState(() {
//         image = result.files.first.bytes;
//         fileName = result.files.first.name;
//       });
//     } else {
//       print("No image selected");
//     }
//   }

//   clearImage() async {
//     setState(() {
//       image = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       // ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: (){
//             AddDialogBox();
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.blue,
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       body: Column(
//         children: [
//           Text(
//               "MEMBERS",
//               style: TextStyle(
//                 color: Colors.blue,
//                 fontSize: 30,
//               )),
//           Container(
//             decoration: BoxDecoration(
//               border: Border(
//                 top: BorderSide(color: Colors.grey),
                
//               ),
//             ),
//             height: 543,
//             child: StreamBuilder<List<OfferingModel>>(
//               stream: FirestoreHelper.read(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Text('Failed');
//                 }
            
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
            
//                 if (snapshot.hasData) {
//                   final offeringData = snapshot.data;
//                   return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: offeringData!.length,
//                       itemBuilder: (context, index) {
//                         final singleOffering = offeringData[index];
            
//                         return Card(
//                           child: ListTile(
//                             onTap: () {
//                               viewDialogBox(singleOffering);
//                             },
//                             leading: Container(
//                               width: 40,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                   color: Colors.deepPurple, shape: BoxShape.circle),
//                             ),
//                             title: Text("${singleOffering.amount}"),
//                             subtitle: Text("${singleOffering.offeringType}"),
//                             trailing: Wrap(
//                               spacing: 30, // space between two icons
//                               children: <Widget>[
//                                 InkWell(
//                                     onTap: () {
//                                       EditDialogBox(singleOffering);
//                                       // Navigator.push(context, MaterialPageRoute(builder: (context) => MyDialog()));
//                                     },
//                                     child: Icon(Icons.edit)), // icon-1
            
//                                 InkWell(
//                                     onTap: () {
//                                       FirestoreHelper.delete(singleOffering);
//                                     },
//                                     child: Icon(Icons.delete)), // icon-2
//                               ],
//                             ),
//                           ),
//                         );
//                       });
//                 }
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }),
//           ),
//             // Stack(child: FloatingActionButton(onPressed: (){})),
            
//       ]),
//     );
//   }

//   // dialogBox(singleOffering) {
//   //   _offeringType.text = singleOffering.offeringType;
//   //   _paymentMetohd.text = singleOffering.paymentMethod;
//   //   _amount.text = singleOffering.amount;
//   //   pickImage() async {
//   //     FilePickerResult? result = await FilePicker.platform.pickFiles(
//   //       type: FileType.image,
//   //       allowMultiple: false,
//   //     );
//   //     if (result != null) {
//   //       image = result.files.first.bytes;
//   //       setState(() {
//   //         image = result.files.first.bytes;
//   //         fileName = result.files.first.name;
//   //       });
//   //     } else {
//   //       print("No image selected");
//   //     }
//   //   }
//   //   showDialog(
//   //       context: context,
//   //       builder: (context) {
//   //         return StatefulBuilder(builder: (context, setStateForDialog) {
//   //           return AlertDialog(
//   //             shape: RoundedRectangleBorder(
//   //                 borderRadius: BorderRadius.all(Radius.circular(15.0))),
//   //             scrollable: true,
//   //             title: Text(
//   //               "ADD NEW OFFERING",
//   //               textAlign: TextAlign.center,
//   //             ),
//   //             contentPadding:
//   //                 EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
//   //             content: Column(
//   //               children: [
//   //                 InkWell(
//   //                   onTap: pickImage,
//   //                   child: Container(
//   //                       height: 200,
//   //                       width: 200,
//   //                       // color: Colors.blueGrey,
//   //                       decoration: BoxDecoration(
//   //                         color: Colors.blueGrey,
//   //                         borderRadius: BorderRadius.circular(8),
//   //                         border: Border.all(
//   //                           color: Colors.blue,
//   //                           width: 2,
//   //                         ),
//   //                       ),
//   //                       child: image == null
//   //                           ? Center(child: Icon(Icons.file_upload))
//   //                           : Image.memory(
//   //                               image,
//   //                               fit: BoxFit.cover,
//   //                             )),
//   //                 ),
//   //                 SizedBox(
//   //                   height: 45.0,
//   //                   child: TextField(
//   //                     // maxLength: 2,
//   //                     // keyboardType: TextInputType.number,
//   //                     // enableInteractiveSelection: false,
//   //                     controller: _offeringType,
//   //                     decoration: InputDecoration(
//   //                       counterText: "",
//   //                       focusedBorder: OutlineInputBorder(
//   //                         borderSide:
//   //                             BorderSide(color: Colors.grey, width: 2.0),
//   //                         borderRadius: BorderRadius.all(Radius.circular(20.0)),
//   //                       ),
//   //                       enabledBorder: OutlineInputBorder(
//   //                         borderSide:
//   //                             BorderSide(color: Colors.black, width: 1.0),
//   //                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//   //                       ),
//   //                       labelText: "Type",
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 SizedBox(
//   //                   height: 45.0,
//   //                   child: TextField(
//   //                     // maxLength: 2,
//   //                     // keyboardType: TextInputType.number,
//   //                     // enableInteractiveSelection: false,
//   //                     controller: _paymentMetohd,
//   //                     decoration: InputDecoration(
//   //                       counterText: "",
//   //                       focusedBorder: OutlineInputBorder(
//   //                         borderSide:
//   //                             BorderSide(color: Colors.grey, width: 2.0),
//   //                         borderRadius: BorderRadius.all(Radius.circular(20.0)),
//   //                       ),
//   //                       enabledBorder: OutlineInputBorder(
//   //                         borderSide:
//   //                             BorderSide(color: Colors.black, width: 1.0),
//   //                         borderRadius: BorderRadius.all(Radius.circular(20.0)),
//   //                       ),
//   //                       labelText: "Method",
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 SizedBox(
//   //                   height: 45.0,
//   //                   child: TextField(
//   //                     // maxLength: 2,
//   //                     // keyboardType: TextInputType.number,
//   //                     // enableInteractiveSelection: false,
//   //                     controller: _amount,
//   //                     decoration: InputDecoration(
//   //                       counterText: "",
//   //                       focusedBorder: OutlineInputBorder(
//   //                         borderSide:
//   //                             BorderSide(color: Colors.grey, width: 2.0),
//   //                         borderRadius: BorderRadius.all(Radius.circular(20.0)),
//   //                       ),
//   //                       enabledBorder: OutlineInputBorder(
//   //                         borderSide:
//   //                             BorderSide(color: Colors.black, width: 1.0),
//   //                         borderRadius: BorderRadius.all(Radius.circular(20.0)),
//   //                       ),
//   //                       labelText: "Amount",
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 SizedBox(
//   //                   height: 15.0,
//   //                 ),
//   //                 ElevatedButton(
//   //                   style: ElevatedButton.styleFrom(
//   //                     fixedSize: Size(
//   //                       MediaQuery.of(context).size.width / 1.6,
//   //                       50,
//   //                     ),
//   //                   ),
//   //                   onPressed: () {
//   //                     FirestoreHelper.update(OfferingModel(
//   //                         id: singleOffering?.id,
//   //                         paymentMethod: _offeringType.text,
//   //                         amount: _amount.text,
//   //                         offeringType: _paymentMetohd.text));
//   //                     Navigator.pop(context);
//   //                   },
//   //                   child: Text('Save Data'),
//   //                 ),
//   //                 SizedBox(
//   //                   width: 15.0,
//   //                 ),
//   //                 TextButton(
//   //                     onPressed: () {
//   //                       Navigator.pop(context);
//   //                     },
//   //                     child: Text('Cancel')),
//   //               ],
//   //             ),
//   //           );
//   //         });
//   //       });
//   // }

//   viewDialogBox(singleOffering) {
//     _offeringType.text = singleOffering.offeringType;
//     _paymentMetohd.text = singleOffering.paymentMethod;
//     _amount.text = singleOffering.amount;

//     showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, setStateForDialog) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(15.0))),
//               scrollable: true,
//               title: Text(
//                 "CHURCH DETAILS",
//                 textAlign: TextAlign.center,
//               ),
//               contentPadding:
//                   EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
//               content: Column(
//                 children: [
//                   Container(
//                       height: 100,
//                       width: 100,
//                       // color: Colors.blueGrey,
//                       decoration: BoxDecoration(
//                         color: Colors.blueGrey,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: Colors.blue,
//                           width: 2,
//                         ),
//                       ),
//                       child: image == null
//                           ? Center(child: Icon(Icons.file_upload))
//                           : Image.memory(
//                               image,
//                               fit: BoxFit.cover,
//                             )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   TextField(
//                     enabled: false,
//                     controller: _offeringType,
//                     decoration: InputDecoration(
//                       labelText: "Offering Type",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   TextField(
//                     enabled: false,
//                     controller: _paymentMetohd,
//                     decoration: InputDecoration(
//                       labelText: "Payment Method",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   TextField(
//                     enabled: false,
//                     controller: _amount,
//                     decoration: InputDecoration(
//                       labelText: "Amount",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   TextField(
//                     enabled: false,
//                     // controller: _amount,
//                     decoration: InputDecoration(
//                       labelText: "Amount",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   TextField(
//                     enabled: false,
//                     // controller: _amount,
//                     decoration: InputDecoration(
//                       labelText: "Amount",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15.0,
//                   ),
//                   TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text('CLOSE')),
//                 ],
//               ),
//             );
//           });
//         });
//   }

//   EditDialogBox(singleOffering) {
//     _offeringType.text = singleOffering.offeringType;
//     _paymentMetohd.text = singleOffering.paymentMethod;
//     _amount.text = singleOffering.amount;

//     showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, setStateForDialog) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(15.0))),
//               scrollable: true,
//               title: Text(
//                 "CHURCH DETAILS",
//                 textAlign: TextAlign.center,
//               ),
//               contentPadding:
//                   EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
//               content: Column(
//                 children: [
//                   Container(
//                       height: 100,
//                       width: 100,
//                       // color: Colors.blueGrey,
//                       decoration: BoxDecoration(
//                         color: Colors.blueGrey,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: Colors.blue,
//                           width: 2,
//                         ),
//                       ),
//                       child: image == null
//                           ? Center(child: Icon(Icons.file_upload))
//                           : Image.memory(
//                               image,
//                               fit: BoxFit.cover,
//                             )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   TextField(
//                     // enabled: false,
//                     controller: _offeringType,
//                     decoration: InputDecoration(
//                     labelText: "Offering Type",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   TextField(
//                     // enabled: false,
//                     controller: _paymentMetohd,
//                     decoration: InputDecoration(
//                       labelText: "Payment Method",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   TextField(
//                     // enabled: false,
//                     controller: _amount,
//                     decoration: InputDecoration(
//                       labelText: "Amount",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   TextField(
//                     // enabled: false,
//                     // controller: _amount,
//                     decoration: InputDecoration(
//                       labelText: "Email",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   TextField(
//                     // enabled: false,
//                     // controller: _amount,
//                     decoration: InputDecoration(
//                       labelText: "Contact",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15.0,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       TextButton(
//                           onPressed: () {
//                             FirestoreHelper.update(OfferingModel(
//                                 id: singleOffering?.id,
//                                 offeringType: _offeringType.text,
//                                 paymentMethod: _paymentMetohd.text,
//                                 amount: _amount.text));
//                             Navigator.pop(context);
//                           },
//                           child: Text("UPDATE")),
//                       TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: Text('CLOSE')),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           });
//         });
//   }

//   AddDialogBox() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, setStateForDialog) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(15.0))),
//               scrollable: true,
//               title: Text(
//                 "CHURCH DETAILS",
//                 textAlign: TextAlign.center,
//               ),
//               contentPadding:
//                   EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
//               content: Column(
//                 children: [
//                   Container(
//                       height: 100,
//                       width: 100,
//                       // color: Colors.blueGrey,
//                       decoration: BoxDecoration(
//                         color: Colors.blueGrey,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: Colors.blue,
//                           width: 2,
//                         ),
//                       ),
//                       child: image == null
//                           ? Center(child: Icon(Icons.file_upload))
//                           : Image.memory(
//                               image,
//                               fit: BoxFit.cover,
//                             )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   TextField(
//                     // enabled: false,
//                     controller: _offeringType,
//                     decoration: InputDecoration(
//                     labelText: "Offering Type",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   TextField(
//                     // enabled: false,
//                     controller: _paymentMetohd,
//                     decoration: InputDecoration(
//                       labelText: "Payment Method",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   TextField(
//                     // enabled: false,
//                     controller: _amount,
//                     decoration: InputDecoration(
//                       labelText: "Amount",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   TextField(
//                     // enabled: false,
//                     // controller: _amount,
//                     decoration: InputDecoration(
//                       labelText: "Email",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   TextField(
//                     // enabled: false,
//                     // controller: _amount,
//                     decoration: InputDecoration(
//                       labelText: "Contact",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15.0,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       TextButton(
//                           onPressed: () {
//                             FirestoreHelper.create(OfferingModel(
//                                 // id: singleOffering?.id,
//                                 offeringType: _offeringType.text,
//                                 paymentMethod: _paymentMetohd.text,
//                                 amount: _amount.text
//                             ));
//                             Navigator.pop(context);
//                           },
//                           child: Text("UPDATE")),
//                       TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: Text('CLOSE')),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           });
//         });
//   }
// }
