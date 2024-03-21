import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offering_collection_web/model/offering_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Report extends StatefulWidget {
  List<OfferingModel> docid;
  Report({required this.docid});

  @override
  State<Report> createState() => _ReportState(docid: docid);
}

class _ReportState extends State<Report> {
  // List docid;
  List<OfferingModel> docid;
  _ReportState({required this.docid});

  // late List<OfferingModel> offeringsFiltered;

  final pdf = pw.Document();

  var regularOfferingCount = '';
  var titheCount = '';
  var pastorAppreciationCount = '';

  double regularOfferingAmount = 0.0;
  double titheAmount = 0.0;
  double pastorAppreciationAmount = 0.0;

  int offeringCount = 0;

  double grandTotal = 0.0;

  var marks = 2;

  void initState() {
    offeringData(docid);
    super.initState();
  }

  offeringData(List<OfferingModel> docid) {
    // var element;
    regularOfferingCount = docid
        .where((element) => element.offeringType == 'Regular Offering')
        .length
        .toString();
    titheCount = docid
        .where((element) => element.offeringType == 'Tithe')
        .length
        .toString();
    pastorAppreciationCount = docid
        .where((element) => element.offeringType == 'Pastor Appreciation')
        .length
        .toString();

    offeringCount = int.parse(regularOfferingCount) + int.parse(titheCount) + int.parse(pastorAppreciationCount);

    docid
        .where((element) => element.offeringType == 'Regular Offering')
        .forEach((item) {
      //getting the key direectly from the name of the key
      regularOfferingAmount += int.parse(item.amount as String);
    });

    docid
        .where((element) => element.offeringType == 'Tithe')
        .forEach((item) {
      //getting the key direectly from the name of the key
      titheAmount += int.parse(item.amount as String);
    });

    docid
        .where((element) => element.offeringType == 'Pastor Appreciation')
        .forEach((item) {
      //getting the key direectly from the name of the key
      pastorAppreciationAmount += int.parse(item.amount as String);
    });

    // Grand total
    docid.forEach((item) {
      //getting the key direectly from the name of the key
      grandTotal += int.parse(item.amount as String);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Offering Report', style: TextStyle(color: Colors.blue),)),
      ),
      body: PdfPreview(
        // maxPageWidth: 700,
        maxPageWidth: 700,
        previewPageMargin: EdgeInsets.all(50),
        // useActions: false,
        canChangePageFormat: true,
        canChangeOrientation: false,
        // pageFormats:pageformat,
        canDebug: false,

        build: (format) => generateDocument(
          format,
        ),
      ),
    );
  }

  Future<Uint8List> generateDocument(PdfPageFormat format) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();
    // final image = await imageFromAssetBundle('assets/r2.svg');

    // String? _logo = await rootBundle.loadString('assets/harvest.png');

    final _logo = pw.MemoryImage(
        (await rootBundle.load('harvest.png')).buffer.asUint8List());

    final pageTheme = await _myPageTheme(format);

    doc.addPage(
      pw.Page(
        pageTheme: pageTheme,

        // pw.PageTheme(
        //   pageFormat: format.copyWith(
        //     marginBottom: 0,
        //     marginLeft: 0,
        //     marginRight: 0,
        //     marginTop: 0,
        //   ),
        //   orientation: pw.PageOrientation.portrait,
        //   theme: pw.ThemeData.withFont(
        //     base: font1,
        //     bold: font2,
        //   ),
        // ),

        build: (final context) => pw.Container(
          // padding: pw.EdgeInsets.only(left: 30, bottom: 20),
          padding: pw.EdgeInsets.all(30),
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
                            pw.Text('Email : '),
                            pw.Text('Address : '),
                          ]),
                      pw.SizedBox(width: 70),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('0012 345 6789'),
                            pw.Text('offeringcollectionapp@gmail.com'),
                            pw.Text('City Road 1st Street PO Box: 8563')
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
                    ]),

                pw.SizedBox(height: 30),
                // pw.Divider(),
                pw.SizedBox(height: 30),

                pw.Center(
                  child: pw.Text('Church Offering Report',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        // font: ttf,
                        fontSize: 30,
                        fontWeight: pw.FontWeight.bold,
                      )),
                ),

                pw.SizedBox(height: 30),
                // pw.Divider(),

                pw.Table(
                  border: pw.TableBorder.symmetric(),
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
                                  fontSize: 20, color: PdfColors.blue),
                            ),
                            pw.Divider(),
                            pw.SizedBox(height: 20),

                            pw.Text(
                              'Regular Offering',
                              style: pw.TextStyle(
                                  fontSize: 12, color: PdfColors.black),
                            ),
                            
                            pw.SizedBox(height: 20),

                            pw.Text(
                              'Tithe',
                              style: pw.TextStyle(
                                  fontSize: 12, color: PdfColors.black),
                            ),
                            
                            pw.SizedBox(height: 20),

                            pw.Text(
                              'Pastor Appreciation',
                              style: pw.TextStyle(
                                  fontSize: 12, color: PdfColors.black),
                            ),

                            pw.SizedBox(height: 40),

                            pw.Text(
                              'Total Offering : ' + offeringCount.toString(),
                              style: pw.TextStyle(
                                  fontSize: 13, color: PdfColors.black,),
                            ),

                          ],
                        ),

                        pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Offering Quantity',
                              style: pw.TextStyle(
                                  fontSize: 20, color: PdfColors.blue),
                            ),

                            pw.Divider(),
                            pw.SizedBox(height: 20),

                            pw.Text(regularOfferingCount, style: pw.TextStyle(fontSize: 12), textAlign: pw.TextAlign.right),

                            pw.SizedBox(height: 20),

                            pw.Text(titheCount, style: pw.TextStyle(fontSize: 12), textAlign: pw.TextAlign.right),

                            pw.SizedBox(height: 20),

                            pw.Text(pastorAppreciationCount, style: pw.TextStyle(fontSize: 12), textAlign: pw.TextAlign.right),

                            pw.SizedBox(height: 40),

                            pw.Text('', style: pw.TextStyle(fontSize: 12), textAlign: pw.TextAlign.right),

                          ],
                        ),

                        pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Sub-Total',
                              style: pw.TextStyle(
                                  fontSize: 20, color: PdfColors.blue),
                            ),

                            pw.Divider(),
                            pw.SizedBox(height: 20),

                            pw.Text(regularOfferingAmount.toString(), style: pw.TextStyle(fontSize: 12),
                                textAlign: pw.TextAlign.right),

                            pw.SizedBox(height: 20),

                            pw.Text(titheAmount.toString(), style: pw.TextStyle(fontSize: 12), textAlign: pw.TextAlign.right),

                            pw.SizedBox(height: 20),

                            pw.Text(pastorAppreciationAmount.toString(), style: pw.TextStyle(fontSize: 12),
                                textAlign: pw.TextAlign.right),

                            pw.SizedBox(height: 40),

                            pw.Text('Grand Total : ' + '' + grandTotal.toString(), style: pw.TextStyle(fontSize: 12),
                                textAlign: pw.TextAlign.right),

                          ],
                        ),

                      ],
                    ),
                  ],
                  //
                ),
                pw.SizedBox(height: 10),
                pw.Divider(),

              ]),
        ),
      ),
    );

    return doc.save();
  }

  pw.Expanded itemColumn(List<OfferingModel> docid) {
    return pw.Expanded(
      child: pw.Column(
        children: [
          for (var element in docid)
            pw.Row(
              children: [
                pw.Expanded(
                    child:
                        pw.Text(element.amount!, textAlign: pw.TextAlign.left)),
                // pw.Expanded(
                //     child: pw.Text(element.itemPrice,
                //         textAlign: pw.TextAlign.right)),
                // pw.Expanded(
                //     child:
                //         pw.Text(element.amount, textAlign: pw.TextAlign.right)),
                // pw.Expanded(
                //     child:
                //         pw.Text(element.total, textAlign: pw.TextAlign.right)),
                // pw.Expanded(
                //     child: pw.Text(element.vat, textAlign: pw.TextAlign.right)),
              ],
            )
        ],
      ),
    );
  }

  Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
    final logoimage = pw.MemoryImage(
      (await rootBundle.load('harvest.png')).buffer.asUint8List(),
    );
    return const pw.PageTheme(
        margin: pw.EdgeInsets.symmetric(
            horizontal: 1 * PdfPageFormat.cm, vertical: 0.5 * PdfPageFormat.cm),
        textDirection: pw.TextDirection.ltr,
        orientation: pw.PageOrientation.portrait,
        // buildBackground: (final context) => pw.FullPage(
        //     ignoreMargins: true,
        //     child: pw.Watermark(
        //         angle: 20,
        //         child: pw.Opacity(
        //             opacity: 0.5,
        //             child: pw.Image(
        //                 alignment: pw.Alignment.center,
        //                 logoimage,
        //                 fit: pw.BoxFit.cover)
        //         )
        //                 )
        // )
                        );
  }
}
