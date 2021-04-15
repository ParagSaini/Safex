import 'package:barcode_scan_fix/barcode_scan.dart';

class QrScannerScreen {
  Future<String> scanQrCode() async {
    String result = '';
    try {
      String qrCode = await BarcodeScanner.scan();
      result = qrCode;
    } catch (e) {
      print(e);
    }
    return result;
  }
}
