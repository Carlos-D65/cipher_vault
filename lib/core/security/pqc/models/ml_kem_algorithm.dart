enum MlKemAlgorithm {
  mlKem512(
    id: 'ml-kem-512',
    name: 'ML-KEM-512',
    securityLevel: 1,
  ),

  mlKem768(
    id: 'ml-kem-768',
    name: 'ML-KEM-768',
    securityLevel: 3,
  ),

  mlKem1024(
    id: 'ml-kem-1024',
    name: 'ML-KEM-1024',
    securityLevel: 5,
  );

  final String id;
  final String name;
  final int securityLevel;

  const MlKemAlgorithm({
    required this.id,
    required this.name,
    required this.securityLevel,
  });

  static MlKemAlgorithm fromId(String id) {
    return values.firstWhere(
      (algorithm) => algorithm.id == id,
      orElse: () {
        throw FormatException(
          'Algoritmo ML-KEM no soportado: $id',
        );
      },
    );
  }
}