sealed class AppFailure {
  final String message;

  const AppFailure(this.message);
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

final class SecurityFailure extends AppFailure {
  const SecurityFailure(super.message);
}

final class StorageFailure extends AppFailure {
  const StorageFailure(super.message);
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure(super.message);
}