import 'package:mocktail/mocktail.dart';
import 'package:value_listenable_test/value_listenable_test.dart';

/// Creates a stub response for the `addListener` method on a [valueListenable].
/// The [valueListenable] will have each `value` (in order) after the [input] is called.
/// Optionally provide an [initialValue] to stub the `value` of the [valueListenable],
/// or also optionally provide a [delay] between the `values` change.
///
/// ```dart
/// whenListen(
///   counter,
///   input: counter.increment,
///   initialValue: 0,
///   values: [1, 2, 3],
/// );
///
/// expect(counter.value, 0);
///```
///
///```dart
/// whenListen(
///   counter,
///   input: counter.increment,
///   initialValue: 0,
///   values: [1, 2, 3],
/// );
///
/// valueListenableTest<Counter>(
///  'value = [1, 2, 3] when increment is called',
///   build: () => counter,
///   act: (notifier) => notifier.increment(),
///   expect: () => [1, 2, 3],
/// );
///```
///
/// Note: When setting the [initialValue] the listeners are never called, then [emitValues]
/// and [valueListenableTest] methods never must expect that.
///
void whenListen<ValueType>(
  MockValueListenable<ValueType> valueListenable, {
  required Function() input,
  Duration delay = Duration.zero,
  List<ValueType> values = const [],
  ValueType? initialValue,
}) {
  if (initialValue != null) {
    when((() => valueListenable.value)).thenReturn(initialValue);
  }
  when(input).thenAnswer((_) async {
    for (final value in values) {
      when((() => valueListenable.value)).thenReturn(value);
      valueListenable.callListeners();
      await Future.delayed(delay);
    }
  });
}
