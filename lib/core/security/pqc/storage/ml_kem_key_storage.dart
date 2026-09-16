import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/ml_kem_algorithm.dart';
import '../models/ml_kem_key_pair.dart';

class MlKemKeyStorage {
  static const String _algorithmKey =
      'ciphervault.mlkem.algorithm';

  static const String _publicKeyKey =
      'ciphervault.mlkem.public_key';

  static const String _secretKeyKey =
      'ciphervault.mlkem.secret_key';

  final FlutterSecureStorage _storage;

  const MlKemKeyStorage({
    FlutterSecureStorage storage =
        const FlutterSecureStorage(),
  }) : _storage = storage;

  Future<MlKemKeyPair?> readKeyPair() async {
    final algorithmId =
        await _storage.read(key: _algorithmKey);

    final publicKeyEncoded =
        await _storage.read(key: _publicKeyKey);

    final secretKeyEncoded =
        await _storage.read(key: _secretKeyKey);

    if (algorithmId == null ||
        publicKeyEncoded == null ||
        secretKeyEncoded == null) {
      return null;
    }

    final algorithm =
        MlKemAlgorithm.fromId(algorithmId);

    final publicKey = Uint8List.fromList(
      base64Url.decode(publicKeyEncoded),
    );

    final secretKey = Uint8List.fromList(
      base64Url.decode(secretKeyEncoded),
    );

    return MlKemKeyPair(
      algorithm: algorithm,
      publicKey: publicKey,
      secretKey: secretKey,
    );
  }

  Future<void> writeKeyPair(
    MlKemKeyPair keyPair,
  ) async {
    await _storage.write(
      key: _algorithmKey,
      value: keyPair.algorithm.id,
    );

    await _storage.write(
      key: _publicKeyKey,
      value: base64UrlEncode(
        keyPair.publicKey,
      ),
    );

    await _storage.write(
      key: _secretKeyKey,
      value: base64UrlEncode(
        keyPair.secretKey,
      ),
    );
  }

  Future<void> deleteKeyPair() async {
    await _storage.delete(
      key: _algorithmKey,
    );

    await _storage.delete(
      key: _publicKeyKey,
    );

    await _storage.delete(
      key: _secretKeyKey,
    );
  }
}