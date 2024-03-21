// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:offering_collection_web/model/invoice_model.dart';
// import 'package:offering_collection_web/model/offering_model.dart';

// class InvoicePage extends StatelessWidget {
//   InvoicePage({super.key});

//   final invoices = [
//   Invoice(
//       customer: 'David Thomas',
//       address: '123 Fake St\r\nBermuda Triangle',
//       items: [
//         LineItem(
//           'Technical Engagement',
//           120,
//         ),
//         LineItem('Deployment Assistance', 200),
//         LineItem('Develop Software Solution', 3020.45),
//         LineItem('Produce Documentation', 840.50),
//       ],
//       name: 'Create and deploy software package'),
//   Invoice(
//     customer: 'Michael Ambiguous',
//     address: '82 Unsure St\r\nBaggle Palace',
//     items: [
//       LineItem('Professional Advice', 100),
//       LineItem('Lunch Bill', 43.55),
//       LineItem('Remote Assistance', 50),
//     ],
//     name: 'Provide remote support after lunch',
//   ),
//   Invoice(
//     customer: 'Marty McDanceFace',
//     address: '55 Dancing Parade\r\nDance Place',
//     items: [
//       LineItem('Program the robots', 400.50),
//       LineItem('Find tasteful dance moves for the robots', 80.55),
//       LineItem('General quality assurance', 80),
//     ],
//     name: 'Create software to teach robots how to dance',
//   )
// ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
          
//         ],
//       ),
//     );
//   }

//   Future<Uint8List> makePdf(Invoice invoice) async {
//   final pdf = Document();
//   pdf.addPage(
//     Page(
//     build: (context) {
//       return Column(
//         children: []
//       }
//     );
// }
// }

// class PdfPreviewPage extends StatelessWidget {
//   final Invoice invoice;
//   const PdfPreviewPage({Key? key, required this.invoice}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//     appBar: AppBar(
//       title: Text('Invoices'),
//     ),
//     body: ListView(
//       children: [
//         ...invoices.map(
//           (e) => ListTile(
//             title: Text(e.name),
//             subtitle: Text(e.customer),
//             trailing: Text('\$${e.totalCost().toStringAsFixed(2)}'),
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (builder) => DetailPage(invoice: e),
//                 ),
//               );
//             },
//           ),
//         )
//       ],
//     ),
//   );
//   }
// }
