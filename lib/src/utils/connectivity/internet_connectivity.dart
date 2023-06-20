import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityStatus {
  final ConnectivityResult connectivityResult;

  ConnectivityStatus(this.connectivityResult);

  bool get isConnected =>
      connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi;
}
