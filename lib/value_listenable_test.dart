library value_listenable_test;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:meta/meta.dart';
// ignore: implementation_imports
import 'package:test_api/src/expect/async_matcher.dart';

export 'src/mock_value_listenable.dart';
export 'src/when_listen.dart';

/// Listen the emits of ValueListenable
///
/// ```dart
///  test('valueListenable Matcher', () {
///      final counter = ValueNotifier(0);
///      expect(counter, emitValues([2, 3, 5]));
///      counter.value = 2;
///      counter.value = 3;
///      counter.value = 5;
///    });
/// ```
_ValueListenableMatcher emitValues(List emits) {
  return _ValueListenableMatcher(emits);
}

/// Creates a new `ValueListenable` object -specific test case with the given [description].
///
/// [build] should be used for all `ValueListenable` initialization and preparation.
/// You must return the `instance` under test.
///
/// [act] is an optional callback which will be invoked with the `ValueListenable` under
/// test and should be used to interact with the `ValueListenable`.
///
/// [expect] is an optional `Function` that returns a `Matcher` which the `ValueListenable`
/// under test is expected to emit after [act] is executed.
///
/// [verify] is a callback which is invoked after [expect]
/// and can be used for additional verification/assertions.
/// [verify] is called with the `ValueListenable` returned by [build].
///
/// ```dart
/// valueListenableTest(
///   'Counter emits [1] when update method is called',
///   build: () => Counter(),
///   act: (notifier) => notifier.update(1),
///   expect: () => [1],
/// );
/// ```
///
/// [valueListenableTest] can also be used to [verify] internal store functionality.
///
/// ```dart
/// valueListenableTest(
///   'Counter emits [1] when update method is called',
///   build: () => Counter(),
///   act: (notifier) => store.update(1),
///   expect: () => [1],
///   verify: (_) {
///     // using mocktail...
///     verify(() => repository.someMethod(any())).called(1);
///   }
/// );
/// ```
@isTest
FutureOr<void> valueListenableTest<T extends ValueListenable>(
  String description, {
  required T Function() build,
  Function(T notifier)? act,
  List Function()? expect,
  Function(T notifier)? verify,
}) {
  flutter_test.test(description, () async {
    final notifier = build();
    final expected = expect?.call();
    final future =
        flutter_test.expectLater(notifier, emitValues(expected ?? []));
    act?.call(notifier);
    await future;
    verify?.call(notifier);
  });
}

class _ValueListenableMatcher extends AsyncMatcher {
  final List emits;

  _ValueListenableMatcher(this.emits);

  @override
  flutter_test.Description describe(flutter_test.Description description) {
    return description.add('ValueListenable test');
  }

  @override
  Future matchAsync(covariant ValueListenable valueListenable) async {
    final _completer = Completer();
    final items = [];

    valueListenable.addListener(() {
      items.add(valueListenable.value);
      for (var i = 0; i < items.length; i++) {
        final emit = emits[i];

        if (emit is flutter_test.Matcher) {
          if (!emit.matches(items[i], {})) {
            _completer.complete('diff');
          }
        } else {
          if (items[i] != emits[i]) {
            _completer.complete('diff');
          }
        }
      }

      if (items.length == emits.length) {
        _completer.complete(null);
      }
    });

    return await _completer.future;
  }
}
