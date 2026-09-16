import 'dart:math';

abstract final class SecureRandomBytes {
  static final Random _random = Random.secure();

  static List<int> bytes(int length) {
    if (length <= 0) {
      throw ArgumentError.value(
        length,
        'length',
        'Debe ser mayor que cero.',
      );
    }

    return List<int>.generate(
      length,
      (_) => _random.nextInt(256),
    );
  }
}