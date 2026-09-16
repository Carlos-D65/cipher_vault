import 'package:flutter/foundation.dart';

class AppController extends ChangeNotifier {
  int _tabIndex = 0;

  String? _pendingCiphertext;

  String? _lastActivity;

  int get tabIndex => _tabIndex;

  String? get pendingCiphertext => _pendingCiphertext;

  String? get lastActivity => _lastActivity;

  void setTab(int index) {
    if (index < 0 || index > 3) {
      return;
    }

    if (_tabIndex == index) {
      return;
    }

    _tabIndex = index;

    notifyListeners();
  }

  void setPendingCiphertext(String ciphertext) {
    _pendingCiphertext = ciphertext;

    notifyListeners();
  }

  void clearPendingCiphertext() {
    _pendingCiphertext = null;

    notifyListeners();
  }

  void setLastActivity(String activity) {
    _lastActivity = activity;

    notifyListeners();
  }
}