extension ListExtension<E> on List<E> {
  List<E> updateWhere(bool Function(E e) test, E newElement) {
    where(test).forEach((e) {
      final index = indexOf(e);
      if(index >= 0 && index < length) {
        this[index] = newElement;
      }
    });
    return this;
  }

  List<E> reverseIf(bool reverse) {
    if(reverse) {
      return reversed.toList();
    } else {
      return this;
    }
  }

  List<R> mapIf<R>(R Function(E e) toElement, bool Function(E e) condition) {
    return where(condition).map<R>(toElement).toList();
  }

  E? firstWhereOrNull(bool Function(E element) test) {
    try {
      return firstWhere(test);
    } on StateError {
      return null;
    }
  }
}