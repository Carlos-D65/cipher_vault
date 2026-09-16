import 'package:flutter/foundation.dart';

enum DecryptStatus {
  idle,
  selectingImage,
  extracting,
  decrypting,
  success,
  copying,
  saving,
  sharing,
  error,
}

class DecryptProvider extends ChangeNotifier {
  DecryptStatus _status = DecryptStatus.idle;

  Uint8List? _selectedImageBytes;

  String? _selectedFileName;

  String? _payload;

  String? _decryptedText;

  String? _savedPath;

  String? _errorMessage;

  DecryptStatus get status => _status;

  Uint8List? get selectedImageBytes =>
      _selectedImageBytes;

  String? get selectedFileName =>
      _selectedFileName;

  String? get payload => _payload;

  String? get decryptedText =>
      _decryptedText;

  String? get savedPath =>
      _savedPath;

  String? get errorMessage =>
      _errorMessage;

  bool get isBusy {
    return _status ==
            DecryptStatus.selectingImage ||
        _status ==
            DecryptStatus.extracting ||
        _status ==
            DecryptStatus.decrypting ||
        _status ==
            DecryptStatus.copying ||
        _status ==
            DecryptStatus.saving ||
        _status ==
            DecryptStatus.sharing;
  }

  bool get hasImage =>
      _selectedImageBytes != null;

  bool get hasDecryptedText =>
      _decryptedText != null;

  void setSelectingImage() {
    _status =
        DecryptStatus.selectingImage;
    _errorMessage = null;

    notifyListeners();
  }

  void setImage({
    required Uint8List bytes,
    required String fileName,
  }) {
    _selectedImageBytes = bytes;
    _selectedFileName = fileName;

    _payload = null;
    _decryptedText = null;
    _savedPath = null;
    _errorMessage = null;

    _status = DecryptStatus.idle;

    notifyListeners();
  }

  void setExtracting() {
    _status =
        DecryptStatus.extracting;
    _errorMessage = null;

    notifyListeners();
  }

  void setPayload(String payload) {
    _payload = payload;
    _errorMessage = null;

    notifyListeners();
  }

  void setDecrypting() {
    _status =
        DecryptStatus.decrypting;
    _errorMessage = null;

    notifyListeners();
  }

  void setSuccess(String text) {
    _decryptedText = text;
    _savedPath = null;
    _errorMessage = null;
    _status = DecryptStatus.success;

    notifyListeners();
  }

  void setCopying() {
    _status =
        DecryptStatus.copying;
    _errorMessage = null;

    notifyListeners();
  }

  void setSaving() {
    _status =
        DecryptStatus.saving;
    _errorMessage = null;

    notifyListeners();
  }

  void setSharing() {
    _status =
        DecryptStatus.sharing;
    _errorMessage = null;

    notifyListeners();
  }

  void setSaved(String path) {
    _savedPath = path;
    _status = DecryptStatus.success;
    _errorMessage = null;

    notifyListeners();
  }

  void restoreSuccess() {
    if (_decryptedText != null) {
      _status =
          DecryptStatus.success;
    } else {
      _status =
          DecryptStatus.idle;
    }

    notifyListeners();
  }

  void setError(String message) {
    _status = DecryptStatus.error;
    _errorMessage = message;

    notifyListeners();
  }

  void reset() {
    _status =
        DecryptStatus.idle;

    _selectedImageBytes = null;
    _selectedFileName = null;

    _payload = null;
    _decryptedText = null;
    _savedPath = null;
    _errorMessage = null;

    notifyListeners();
  }
}