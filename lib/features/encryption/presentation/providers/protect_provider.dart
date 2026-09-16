import 'package:flutter/foundation.dart';

import '../../../../core/security/models/escrypted_data.dart';

enum ProtectStatus { idle, encrypting, success, error, saving, sharing }

class ProtectProvider extends ChangeNotifier {
  ProtectStatus _status = ProtectStatus.idle;

  EncryptedData? _encryptedData;
  String? _encryptedPayload;
  String? _errorMessage;

  ProtectStatus get status => _status;

  EncryptedData? get encryptedData => _encryptedData;

  String? get encryptedPayload => _encryptedPayload;

  String? get errorMessage => _errorMessage;

  bool get isEncrypting => _status == ProtectStatus.encrypting;

  bool get isSaving => _status == ProtectStatus.saving;

  bool get isSharing => _status == ProtectStatus.sharing;

  bool get isBusy => isEncrypting || isSaving || isSharing;

  bool get hasResult => _encryptedPayload != null;

  void setEncrypting() {
    _status = ProtectStatus.encrypting;
    _encryptedData = null;
    _encryptedPayload = null;
    _errorMessage = null;

    notifyListeners();
  }

  void setSuccess({
    required EncryptedData encryptedData,
    required String encryptedPayload,
  }) {
    _status = ProtectStatus.success;
    _encryptedData = encryptedData;
    _encryptedPayload = encryptedPayload;
    _errorMessage = null;

    notifyListeners();
  }

  void setSaving() {
    _status = ProtectStatus.saving;
    _errorMessage = null;

    notifyListeners();
  }

  void setSharing() {
    _status = ProtectStatus.sharing;
    _errorMessage = null;

    notifyListeners();
  }

  void restoreSuccessState() {
    if (_encryptedPayload == null) {
      _status = ProtectStatus.idle;
    } else {
      _status = ProtectStatus.success;
    }

    notifyListeners();
  }

  void setError(String message) {
    _status = ProtectStatus.error;
    _errorMessage = message;

    notifyListeners();
  }

  void reset() {
    _status = ProtectStatus.idle;
    _encryptedData = null;
    _encryptedPayload = null;
    _errorMessage = null;

    notifyListeners();
  }
}
