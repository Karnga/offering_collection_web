
import 'dart:html' as file;
import 'dart:io';
import 'dart:js';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> generateCenteredText(String text) async {
    final pdf = Document();

    final font = await rootBundle.load("assets/open-sans.ttf");
    final ttf = Font.ttf(font);

    pdf.addPage(Page(
      build: (context) => Center(
        child: Text(text, style: TextStyle(font: ttf,fontSize: 48)),
      )
      ));

      return saveDocument(name: 'my_exampl.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationCacheDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);
    
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}