class KdfParameters {
  final String algorithm;
  final int memory;
  final int iterations;
  final int parallelism;
  final int keyLength;

  const KdfParameters({
    required this.algorithm,
    required this.memory,
    required this.iterations,
    required this.parallelism,
    required this.keyLength,
  });

  Map<String, dynamic> toJson() {
    return {
      'algorithm': algorithm,
      'memory': memory,
      'iterations': iterations,
      'parallelism': parallelism,
      'keyLength': keyLength,
    };
  }

  factory KdfParameters.fromJson(Map<String, dynamic> json) {
    return KdfParameters(
      algorithm: json['algorithm'] as String,
      memory: json['memory'] as int,
      iterations: json['iterations'] as int,
      parallelism: json['parallelism'] as int,
      keyLength: json['keyLength'] as int,
    );
  }
}