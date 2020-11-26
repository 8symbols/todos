/// Обертка, которая позволяет отправлять в опциональные параметры [null].
class Nullable<T> {
  /// Значение поля.
  ///
  /// Может быть равным null.
  final T value;

  const Nullable(this.value);
}
