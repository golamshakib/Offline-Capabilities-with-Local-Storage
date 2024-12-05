import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
  final _connectivity = Connectivity();
  bool _isConnected = true;
  VoidCallback? _onConnectedCallback;

  /// -- Getter
  bool get isConnected => _isConnected;

  /// -- Setter
  set onConnectedCallback(VoidCallback callback) {
    _onConnectedCallback = callback;
  }

  /// - Connectivity method
  ConnectivityProvider() {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _checkInitialConnection();
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final connection = result == ConnectivityResult.wifi || result == ConnectivityResult.mobile;
    if (_isConnected != connection) {
      _isConnected = connection;
      notifyListeners();
      if(_isConnected && _onConnectedCallback != null){
        _onConnectedCallback!();
      }
    }
  }

  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }
}
