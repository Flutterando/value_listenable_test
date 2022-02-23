import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:value_listenable_test/value_listenable_test.dart';

class Counter extends ValueNotifier<int> {
  Counter() : super(0);

  void increment() => value += 1;
}

class MockCounter extends MockValueListenable<int> implements Counter {}

void main() {
  late MockCounter counter;

  group('whenListen', () {
    setUp(() => counter = MockCounter());

    test('mocks the initial value', () {
      whenListen(
        counter,
        initialValue: 150,
        input: counter.increment,
      );
      expect(counter.value, 150);
    });

    test('mocks the values', () async {
      whenListen(
        counter,
        initialValue: 0,
        input: counter.increment,
        values: [1, 2],
      );
      expect(counter, emitValues([1, 2]));
      counter.increment();
    });

    test('mocks the values with delay', () async {
      whenListen(
        counter,
        initialValue: 0,
        input: counter.increment,
        values: [1, 2, 3],
        delay: const Duration(milliseconds: 50),
      );
      expect(counter.value, 0);
      counter.increment();
      expect(counter.value, 1);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(counter.value, 2);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(counter.value, 3);
    });

    test('not mocks the values when not calls the input', () async {
      whenListen(
        counter,
        initialValue: 0,
        input: counter.increment,
        values: [1, 2],
      );
      expect(counter.value, 0);
      await Future.delayed(Duration.zero);
      expect(counter.value, 0);
    });

    test('throws assert error if initialValue is null and values is empty',
        () async {
      expect(
        () => whenListen(
          counter,
          input: counter.increment,
        ),
        throwsAssertionError,
      );
    });
  });
}
