import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FaturaService {
  static Future<void> gerarEBaixarFatura({
    required String mes,
    required String valor,
    required String status,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text(
                  "FATURA ENERGIA - EQUATORIAL",
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text("Referência: $mes"),
                pw.Text("Valor: R\$ $valor"),
                pw.Text("Status: $status"),
                pw.SizedBox(height: 40),
                pw.BarcodeWidget(
                  data: '836400000012354701380014',
                  barcode: pw.Barcode.itf(),
                  width: 300,
                  height: 50,
                ),
              ],
            ),
          );
        },
      ),
    );

    // Esta é a linha que estava causando a exceção por falta de compilação nativa
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'fatura_$mes.pdf',
    );
  }
}
