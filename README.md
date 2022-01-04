# value_listenable_test

Assists in testing **ValueListenable** objects (ex: **ValueNotifier**).

## install

Added in your `pubspec.yaml` as **dev dependency**:

```yaml
dev_dependencies:
  value_listenable_test: any
```

## Examples

Listen the emits of ValueListenable:

```dart
 test('valueListenable Matcher', () {
     final counter = ValueNotifier(0);
     expect(counter, emitValues([2, 3, 5]));
     counter.value = 2;
     counter.value = 3;
     counter.value = 5;
   });
```

Also, you can use the test abstraction called **valueListenableTest**:

```dart
valueListenableTest(
  'Counter emits [1] when update method is called',
  build: () => Counter(),
  act: (notifier) => notifier.update(1),
  expect: () => [1],
);
```

That`s it!
