import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offering_collection_web/pages/church/pdf%20test2/url_text.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// List<OfferingModel>? offeringData;
//   List<OfferingModel> offeringsFiltered = [];
//   TextEditingController controller = TextEditingController();
//   String _searchResult = '';

//   getOfferingData() async {
//     var dataFromFirebase =
//         await FirebaseFirestore.instance.collection('Offerings').get();
//     List offeringDocument = dataFromFirebase.docs;
//     setState(() {
//       offeringData = offeringDocument
//           .map((offerings) => OfferingModel.fromDoc(offerings))
//           .toList();
//       offeringsFiltered = offeringData!;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getOfferingData();
//   }

Future<Uint8List> generatePdf(final PdfPageFormat format) async {
  final doc = pw.Document(title: 'Flutter School');

  final logoImage = pw.MemoryImage((await rootBundle.load('profile-default.jpeg')).buffer.asUint8List());

  final footerImage = pw.MemoryImage((await rootBundle.load('profile-default.jpeg')).buffer.asUint8List());

  final font = await rootBundle.load('OpenSans-Regular.ttf');
  final ttf = pw.Font.ttf(font);

  final pageTheme = await _myPageTheme(format);

  doc.addPage(pw.MultiPage(
    pageTheme: pageTheme,
    header: (final context) => pw.Image(
      alignment: pw.Alignment.topLeft,
      logoImage,
      fit: pw.BoxFit.contain,
      width: 180,
    ),
    footer: (final context) => pw.Image(
      footerImage,
      fit: pw.BoxFit.scaleDown,
    ),
    build: (final context) => [
      pw.Container(
          padding: pw.EdgeInsets.only(left: 30, bottom: 20),
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Padding(padding: pw.EdgeInsets.only(top: 20)),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text('Phone : '),
                            pw.Text('Phone : '),
                            pw.Text('Phone : '),
                          ]),
                      pw.SizedBox(width: 70),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('0012 345 6789'),
                            UrlText('myFlutterSchool@gmail.com',
                                'myFlutterSchool@gmail.com'),
                            UrlText('flutter tutorial', '@flutter_tutjorial')
                          ]),
                      pw.SizedBox(width: 70),
                      pw.BarcodeWidget(
                        data: "Flutter School",
                        width: 40,
                        height: 40,
                        barcode: pw.Barcode.qrCode(),
                        drawText: false,
                      ),
                      pw.Padding(padding: pw.EdgeInsets.zero),
                    ])
              ])
        ),
        pw.SizedBox(height: 30),
        pw.Divider(),
      pw.Center(
        child: pw.Text('Church Offering Report',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: ttf,
              fontSize: 30,
              fontWeight: pw.FontWeight.bold,
            )),
      ),
      pw.SizedBox(height: 10),
      pw.Divider(thickness: 5),
      // pw.Align(
      //   alignment: pw.Alignment.centerLeft,
      //   child:
      //   MyCategory(
      //     'Flutter School',
      //     ttf,
      //   ),
      // ),
      pw.Table(
        border: pw.TableBorder.all(),
        children: [
          pw.TableRow(
            children: [
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  //
                  // pw.Placeholder(
                  //     fallbackHeight: 50,
                  //     fallbackWidth: 75,
                  //     strokeWidth: 2),
                  // pw.Text(
                  //   'Offering Type',
                  //   style: pw.TextStyle(fontSize: 8, color: PdfColors.grey),
                  // ),
                  pw.Text(
                    'Offering Type',
                    style: pw.TextStyle(
                        fontSize: 20, color: PdfColors.deepOrange400),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Regular Offering',
                    style: pw.TextStyle(fontSize: 10, color: PdfColors.black),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Tithe',
                    style: pw.TextStyle(fontSize: 10, color: PdfColors.black),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Pastor Appreciation',
                    style: pw.TextStyle(fontSize: 10, color: PdfColors.black),
                  ),
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'Offering Quantity',
                    style: pw.TextStyle(
                        fontSize: 20, color: PdfColors.deepOrange400),
                  ),
                  // pw.Text('Reference Number',
                  //     textAlign: pw.TextAlign.right),
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Sub-Total',
                    style: pw.TextStyle(
                        fontSize: 20, color: PdfColors.deepOrange400),
                  ),
                  // pw.Text('Reference Number',
                  //     textAlign: pw.TextAlign.right),
                ],
              ),
            ],
          ),
        ],
        //
      ),
      pw.Divider(),
    ],
  ));
  return doc.save();
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  final logoimage = pw.MemoryImage(
    (await rootBundle.load('profile-default.jpeg')).buffer.asUint8List(),
  );
  return pw.PageTheme(
      margin: const pw.EdgeInsets.symmetric(
          horizontal: 1 * PdfPageFormat.cm, vertical: 0.5 * PdfPageFormat.cm),
      textDirection: pw.TextDirection.ltr,
      orientation: pw.PageOrientation.portrait,
      buildBackground: (final context) => pw.FullPage(
          ignoreMargins: true,
          child: pw.Watermark(
              angle: 20,
              child: pw.Opacity(
                  opacity: 0.5,
                  child: pw.Image(
                      alignment: pw.Alignment.center,
                      logoimage,
                      fit: pw.BoxFit.cover)))));
}

Future<void> saveAsfile(
  final BuildContext context,
  final LayoutCallback build,
  final PdfPageFormat pageFormat,
) async {
  final bytes = await build(pageFormat);

  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath/document.pdf');
  print('save as file ${file.path}...');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}

void showPrintedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document printed successfully')));
}

void showSharedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document shared successfully')));
}
