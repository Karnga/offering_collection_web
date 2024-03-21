import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:offering_collection_web/pages/church/pdf%20test2/util.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfPage extends StatefulWidget {
  static const String id = "pdf-page";
  const PdfPage({super.key});

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {

  PrintingInfo? printingInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug= true;
    final actions = <PdfPreviewAction>[
      if(!kIsWeb)
        const PdfPreviewAction(icon: Icon(Icons.home), onPressed: saveAsfile)
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter PDF'),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        actions: actions,
        onPrinted: showPrintedToast,
        onShared: showSharedToast,
        build: generatePdf,
        ),
    );
  }
}