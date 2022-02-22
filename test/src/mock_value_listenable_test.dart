import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:value_listenable_test/value_listenable_test.dart';

class MockCounter extends MockValueListenable<int> {}

void main() {
  final counter = MockCounter();

  group('MockValueListenable', () {
    test('is compatible with when', () {
      when(() => counter.value).thenReturn(50);
      expect(counter.value, 50);
    });

    test('notifies all listeners with a new value', () {
      int value = 0;
      counter.addListener(() => value += counter.value);
      counter.addListener(() => value += counter.value);

      when(() => counter.value).thenReturn(50);
      counter.callListeners();
      when(() => counter.value).thenReturn(100);
      counter.callListeners();

      expect(value, 300);
    });

    test('not notify removed listeners', () {
      int value = 0;
      final listener = () => value += counter.value;
      counter.addListener(listener);

      when(() => counter.value).thenReturn(50);
      counter.callListeners();

      counter.removeListener(listener);

      when(() => counter.value).thenReturn(100);
      counter.callListeners();

      expect(value, 50);
    });
  });
}
