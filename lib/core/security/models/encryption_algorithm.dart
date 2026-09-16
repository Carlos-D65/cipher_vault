enum EncryptionAlgorithm {
  aes256Gcm(
    id: 'aes-256-gcm',
    name: 'AES-256-GCM',
  ),

  chacha20Poly1305(
    id: 'chacha20-poly1305',
    name: 'ChaCha20-Poly1305',
  );

  final String id;
  final String name;

  const EncryptionAlgorithm({
    required this.id,
    required this.name,
  });

  static EncryptionAlgorithm fromId(String id) {
    return EncryptionAlgorithm.values.firstWhere(
      (algorithm) => algorithm.id == id,
      orElse: () {
        throw FormatException(
          'Algoritmo de cifrado no soportado: $id',
        );
      },
    );
  }
}