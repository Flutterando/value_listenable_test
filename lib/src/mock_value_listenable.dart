import 'package:flutter/foundation.dart';
import 'package:mocktail/mocktail.dart';

/// Extend or mixin this class to mark the implementation as a [MockValueListenable].
///
/// A mocked value listenable implements all fields and methods with a default
/// implementation that does not throw a [NoSuchMethodError],
/// and may be further customized at runtime to define how it may behave using [when] and [whenListen].
///
/// To notify the listeners with a new value call the [callListeners] method.
class MockValueListenable<V> extends Mock implements ValueListenable<V> {
  final _callList = <Function()>[];

  /// Notifies all listeners.
  void callListeners() {
    for (final call in _callList) {
      call();
    }
  }

  @override
  void addListener(VoidCallback listener) => _callList.add(listener);

  @override
  void removeListener(VoidCallback listener) => _callList.remove(listener);
}
