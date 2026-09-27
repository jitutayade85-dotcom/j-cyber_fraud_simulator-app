import 'dart:math';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CertificateService {
  static Future<void> generateAndShare({
    required String name,
    required int correct,
    required int total,
  }) async {
    final percent = ((correct / total) * 100).round();
    final tier = percent >= 90
        ? 'GOLD - CYBER VIGILANT'
        : percent >= 70
            ? 'SILVER - CYBER AWARE'
            : 'BRONZE - NEEDS PRACTICE';
    final certId =
        'CEP-${DateTime.now().millisecondsSinceEpoch.remainder(1000000).toString().padLeft(6, '0')}';

    final pdf = pw.Document();
    final navy = PdfColor.fromInt(0xFF0A2342);
    final gold = PdfColor.fromInt(0xFFD4AF37);

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (context) => pw.Container(
        color: navy,
        padding: const pw.EdgeInsets.all(24),
        child: pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: gold, width: 4),
            borderRadius: pw.BorderRadius.circular(12),
          ),
          padding: const pw.EdgeInsets.all(24),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('CERTIFICATE OF DIGITAL SAFETY',
                  style: pw.TextStyle(
                      fontSize: 26, color: gold, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.Text('& CYBER VIGILANCE',
                  style: pw.TextStyle(fontSize: 18, color: PdfColors.white)),
              pw.SizedBox(height: 20),
              pw.Text('This certificate is proudly presented to',
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.grey300)),
              pw.SizedBox(height: 10),
              pw.Text(name.toUpperCase(),
                  style: pw.TextStyle(
                      fontSize: 30,
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: gold),
                  borderRadius: pw.BorderRadius.circular(20),
                ),
                child: pw.Text('$tier  |  SCORE: $percent%',
                    style: pw.TextStyle(fontSize: 13, color: gold)),
              ),
              pw.SizedBox(height: 24),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('VERIFICATION ID: $certId',
                          style: pw.TextStyle(
                              fontSize: 10, color: PdfColors.grey400)),
                      pw.SizedBox(height: 4),
                      pw.Text(
                          'ISSUED DATE: ${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}',
                          style: pw.TextStyle(
                              fontSize: 10, color: PdfColors.grey400)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('CEP CYBER SAFETY CELL',
                          style: pw.TextStyle(
                              fontSize: 11,
                              color: gold,
                              fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text('National Online Safety Initiative',
                          style: pw.TextStyle(
                              fontSize: 9, color: PdfColors.grey400)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));

    await Printing.sharePdf(
        bytes: await pdf.save(), filename: '${name}_CEP_Certificate.pdf');
  }
}
