import 'dart:io';

/// Verifier si l'appareil est connecté à internet
class NetworkInfo {
  Future<bool> isConnected() async {
    bool? connect;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connect = true;
      }
    } on SocketException catch (_) {
      connect = false;
    }
    return connect!;
  }
}
