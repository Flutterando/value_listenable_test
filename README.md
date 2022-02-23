# value_listenable_test

Assists in testing **ValueListenable** objects (ex: **ValueNotifier**).

## install

Added in your `pubspec.yaml` as **dev dependency**:

```yaml
dev_dependencies:
  value_listenable_test: any
```
## Unit test with emitValues and valueListenableTest

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
valueListenableTest<Counter>(
  'Counter emits [1] when update method is called',
  build: () => Counter(),
  act: (notifier) => notifier.update(1),
  expect: () => [1],
);
```
## Mock

It's easy, just extend the `MockValueListenable`:

```dart
class MockCounter extends MockValueListenable<int> {}
```

To notify the listeners with a new value call the [callListeners] method.

```dart
final counter = MockCounter();
counter.addListener(() => print(counter.value)); // 50
when(() => counter.value).thenReturn(50);
print(counter.value); // 50
counter.callListeners();
```

## Stub the value

Creates a stub response for the `addListener` method on a `valueListenable`.
The `valueListenable` will have each `value` (in order) after the`input` is called.
Optionally provide an `initialValue` to stub the `value` of the `valueListenable`,
or also optionally provide a `delay` between the `values` change.

```dart
// Create a mock instance
final counter = CounterMock();

// Stub the value
whenListen(
  counter,
  input: counter.increment,
  initialValue: 0,
  values: [1, 2, 3],
);

// Assert that the initial value is correct.
expect(counter.value, 0);

// Verifies values after to call increment
valueListenableTest<Counter>(
  'value = [1, 2, 3] when increment is called',
  build: () => counter,
  act: (notifier) => notifier.increment(),
  expect: () => [1, 2, 3],
);
```

>**Note:** When setting the **initialValue** the listeners are never called, then **emitValues**
>and **valueListenableTest** methods never must expect that.

That`s it!
