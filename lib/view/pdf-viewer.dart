import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatelessWidget {
  final String url;
  const PdfViewerPage({@required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: url.startsWith('http')
            ? SfPdfViewer.network(url)
            : SfPdfViewer.file(File(url)),
      ),
    );
  }
}
