sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Failure<T>;
}

final class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);
}

final class Failure<T> extends Result<T> {
  final Object error;

  const Failure(this.error);
}