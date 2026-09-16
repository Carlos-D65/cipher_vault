import 'package:flutter/foundation.dart';

enum HideStatus {
  idle,
  selectingImage,
  processing,
  success,
  saving,
  sharing,
  error,
}

class HideProvider extends ChangeNotifier {
  HideStatus _status = HideStatus.idle;

  Uint8List? _selectedImageBytes;
  Uint8List? _protectedImageBytes;

  String? _selectedFileName;
  String? _payload;
  String? _savedPath;
  String? _errorMessage;

  HideStatus get status => _status;

  Uint8List? get selectedImageBytes => _selectedImageBytes;

  Uint8List? get protectedImageBytes => _protectedImageBytes;

  String? get selectedFileName => _selectedFileName;

  String? get payload => _payload;

  String? get savedPath => _savedPath;

  String? get errorMessage => _errorMessage;

  bool get isBusy {
    return _status == HideStatus.selectingImage ||
        _status == HideStatus.processing ||
        _status == HideStatus.saving ||
        _status == HideStatus.sharing;
  }

  bool get hasImage => _selectedImageBytes != null;

  bool get hasResult => _protectedImageBytes != null;

  void setSelectingImage() {
    _status = HideStatus.selectingImage;
    _errorMessage = null;

    notifyListeners();
  }

  void setImage({
    required Uint8List bytes,
    required String fileName,
  }) {
    _selectedImageBytes = bytes;
    _selectedFileName = fileName;

    _protectedImageBytes = null;
    _savedPath = null;
    _errorMessage = null;
    _status = HideStatus.idle;

    notifyListeners();
  }

  void setPayload(String payload) {
    _payload = payload;
    _errorMessage = null;

    notifyListeners();
  }

  void setProcessing() {
    _status = HideStatus.processing;
    _errorMessage = null;

    notifyListeners();
  }

  void setSuccess(Uint8List bytes) {
    _status = HideStatus.success;
    _protectedImageBytes = bytes;
    _savedPath = null;
    _errorMessage = null;

    notifyListeners();
  }

  void setSaving() {
    _status = HideStatus.saving;
    _errorMessage = null;

    notifyListeners();
  }

  void setSharing() {
    _status = HideStatus.sharing;
    _errorMessage = null;

    notifyListeners();
  }

  void setSaved(String path) {
    _savedPath = path;
    _status = HideStatus.success;
    _errorMessage = null;

    notifyListeners();
  }

  void restoreSuccess() {
    if (_protectedImageBytes != null) {
      _status = HideStatus.success;
    } else {
      _status = HideStatus.idle;
    }

    notifyListeners();
  }

  void setError(String message) {
    _status = HideStatus.error;
    _errorMessage = message;

    notifyListeners();
  }

  void reset() {
    _status = HideStatus.idle;
    _selectedImageBytes = null;
    _protectedImageBytes = null;
    _selectedFileName = null;
    _payload = null;
    _savedPath = null;
    _errorMessage = null;

    notifyListeners();
  }
}