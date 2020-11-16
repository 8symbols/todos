/// Обертка, которая позволяет устанавливать поля в null в методах copyWith.
class Nullable<T> {
  /// Значение поля.
  ///
  /// Может быть равным null.
  final T value;

  Nullable(this.value);
}
