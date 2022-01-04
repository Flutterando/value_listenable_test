import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:value_listenable_test/value_listenable_test.dart';

void main() {
  test('valueListenableMatcher', () {
    final counter = ValueNotifier(0);
    expect(counter, emitValues([2, 3, 5]));
    counter.value = 2;
    counter.value = 3;
    counter.value = 5;
  });

  valueListenableTest<ValueNotifier<int>>(
    'test',
    build: () => ValueNotifier<int>(2),
    act: (notifier) {
      notifier.value = 3;
      notifier.value = 5;
      notifier.value = 6;
    },
    expect: () => [3, equals(5), isA<int>()],
  );
}
